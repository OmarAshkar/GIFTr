#'
#' @title Generate A GIFT File of Different Question Types From a Spreadsheet
#'
#' @description  GIFTr function is the main function of \pkg{'GIFTr'} package.
#' You provide it dataframe and select \code{question_type} column
#' where a more specialized functions can process the file. See Details and Examples
#' @details \pkg{'GIFTr'} package is intended to reduce the time a course creator would
#' take to make input question on 'MOODLE' without the pain of writing markup.\cr\cr
#'\pkg{'GIFTr'} package is build on \href{https://docs.moodle.org/37/en/GIFT_format}{'MOODLE' guidelines}. The idea is simple, you create a spreadsheet in a special format, call \code{GIFTr} function, get a GIFT formatted file that can be imported by 'MOODLE' and other LMS systems. \cr
#' \code{GIFTr} function is unique in that it gives you detailed \strong{\emph{statistics}} and can work with \strong{\emph{the 4 question types}} supported by \pkg{'GIFTr'} package. \code{question_type} argument is unique for \code{GIFTr} function in this package and must be passed to map the questions. The current supported question types are \strong{\code{\link{mcq}{multiple choices question}}, \code{\link{num_q}{numeric entry}}, \code{\link{tf_q}{true or talse}}, and \code{\link{short_ans}{short answer}}}questions.You can find more details on the individual functions details. \cr\cr 'GIFTr' supports basic markdown and GIFT syntax. See the vignette and sections below for complete documentation of formatting your data.
#'
#' @inheritSection mcq Formatting Multiple Choices Questions
#' @inheritSection num_q Numeric Entry Questions Formatting
#' @inheritSection tf_q True or False Questions Formatting
#' @inheritSection short_ans Short Answer Questions Formatting
#'
#' @section Formatting Your Data: A guideline for creating you questions data can be found below. Check the data \code{\link{GIFTrData}} and  \code{\link{GIFTrData_2}} as example for formatted questions.
#' \subsection{Markdown, HTML Support and LATEX support}{
#' 'MOODLE' itself supports basic markdown and HTML for questions formatting. So when formatting your data you can use HTML tags like <sub> and <sup>. Also you can use markdown  **bold** or __bold__ and  *italic* or _italic_ ...etc. However it is better a better practice to avoid using asterisk to avoid confusion with MCQ format. For more about the supported markdown see \href{https://docs.moodle.org/37/en/Markdown}{'MOODLE' documentation}.
#' }
#'
#' \subsection{LATEX Support}{'MOODLE' also supports inline and block LATEX equations through \href{https://www.mathjax.org/}{mathjax}, however you have to be careful with the \href{https://docs.moodle.org/37/en/GIFT_format#Special_Characters_.7E_.3D_.23_.7B_.7D}{special characters} like curly brackets /{/} and equal sign = , so you have to use back slash before those to ensure you can import correctly.\cr\cr Note that if you see thee data in console, you will find it with 2 backslash \\, however that's the escaping of the backslash in R and you write with with single slash normally. Check \link{GIFTrData} \code{GIFTrData[11,3]}for an example. For further details on LATEX, check \href{https://docs.moodle.org/23/en/Using_TeX_Notation}{'MOODLE' docs}.}
#' \subsection{Answer Feedback}{You can easily choose to enter a feedback by using #sign after the answer you want to specify a feedback on. Check \link{GIFTrData} for examples.}
#' \subsection{Data columns}{The data passed would differ slightly according to question type, however generally you need to have: \enumerate{
#' \item a column contains question. This cannot contain empty values
#' \item answer(s) column(s). This may be multiple columns if you have multiple answers. If you mix single and multiple answer it is better to write the single answer in the first column. If you have \strong{only single answer MCQ and NO multiple answer MCQ}, you can set the answers without asterisk in the first column of the answers columns. More details in the vignette and below.
#' \item a column specifying the type of question. The current supported questions are multiple choices, numerical entry, true or false and short answer questions. The should be named 'mcq' , 'num_q' , 'tf_q' and 'short_ans' respectively.
#' \item a column specifying categories and subcategories in the 'MOODLE' categories are important when you are preparing a quiz as you may want to specify certain proportions of inclusions. Categories and subcategories are spaced by forward slash like Categ1/subcateg1/subsubcateg1 ...etc.
#' \item a column specifying question names. So you can easily enter a certain question names by like certain ID or keyword to make the questions easily on the system. however you don't need to worry about that as automatically if not set, the first 40 letter are set a question name.
#'

#'
#' }
#'   }
#'
#' @param data dataframe or tibble of the questions data
#' @param questions name(string) or index(integer) of the questions column
#' @param answers a vector of names(strings) or indices of answers column(s)
#' @param categories name(string) or index(integer) of categories column if available, Default: NULL
#'
#' @param question_names name(string) or index(integer) of the questions names column. If NULL, it will be the first 40 letters of the question title, Default: NULL
#' @param question_type name(string) or index(integer) of the questions type column.
#' @param mcq_answer_column If TRUE, the first column of answers columns will be set as the right answer, Default: FALSE
#' @param output directory of .txt file name the questions will be exported to.
#' @param verbose If TRUE, the functions will print to the console the statistics of writing the output, Default: TRUE
#' @seealso \link{mcq}, \link{num_q} , \link{tf_q}, \link{short_ans}
#'
#' @return None
#'
#' @examples
#' #' load Data and Check structure
#' data(GIFTrData)
#' str(GIFTrData)
#'
#' GIFTr::GIFTr(data = GIFTrData, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_type = 9,
#'  output = file.path(tempdir(), "quiz.txt"))
#'  #write file"quiz.txt" in tempdir()
#'
#'  GIFTr::GIFTr(data = GIFTrData, question_names = 2,
#'  questions = 3, answers = c(4:8),
#'  categories = 1, question_type = 9,
#'  output = file.path(tempdir(), "quiz2.txt"))
#'  #write file"quiz2.txt" in tempdir()
#'
#'
#'
#' @importFrom glue glue
#' @export
#'
GIFTr <-
    function(data,
             output,
             questions,
             answers,
             question_type,
             categories = NULL,
             question_names = NULL,
             mcq_answer_column = FALSE,
             verbose = TRUE) {
        # remove empty rows
        data <- dgift(data, questions)
        # check valid question_types
        if (is.null(question_type)) {
            stop("`question_type` cannot be empty")
        }

        errorv <-
            unlist(data[, question_type]) %in% c("mcq", "tf_q", "num_q", "short_ans")
        if (any(!errorv)) {
            warning(data[which(!errorv), question_type])
            stop(
                "`question_type` column contains value that is not
                'mcq', 'tf_q', 'num_q' or 'short_ans'"
            )
        }

        # Show statistics
        if(verbose)message("Total Number of Questions passed: ", nrow(data))
        if (!is.null(categories)) {
            if(verbose)addmargins(table(unlist(data[, categories]), unlist(data[, question_type])))
        }
        if(verbose)message(rep("\n====", 3), "\n====\n")

        # split by question type
        sdat <- split(data, f = data[, question_type])
        col_names <- names(data)

        # Loop question types
        for (i in 1:length(sdat)) {
            if (names(sdat[i]) == "mcq") {
                x = rename_df(datalist = sdat,
                              col_names = col_names,
                              i = i)
                mcq(
                    data = x,
                    questions = questions,
                    categories = categories,
                    answers = answers,
                    question_names = question_names,
                    make_answer = mcq_answer_column,
                    output = output,
                    verbose = verbose
                )
                if(verbose)message(rep("\n====", 3), "\nDone MCQ!", "\n===\n")
            }


            if (names(sdat[i]) == "tf_q") {
                x = rename_df(datalist = sdat,
                              col_names = col_names,
                              i = i)
                tf_q(
                    data = x,
                    questions = questions,
                    question_names = question_names,
                    categories = categories,
                    answers = answers,
                    output = output,
                    verbose = verbose
                )
                if(verbose)message(rep("\n====", 3),
                    "\nDone T/F questions!",
                    "\n====\n")

            }

            if (names(sdat[i]) == "num_q") {
                x = rename_df(datalist = sdat,
                              col_names = col_names,
                              i = i)
                num_q(
                    data = x,
                    questions = questions,
                    question_names = question_names,
                    categories = categories,
                    answers = answers,
                    output = output,
                    verbose = verbose
                )
                if(verbose)message(rep("\n====", 3),
                    "\nDone Numerical questions!",
                    "\n====\n")
            }

            if (names(sdat[i]) == "short_ans") {
                x = rename_df(datalist = sdat,
                              col_names = col_names,
                              i = i)
                short_ans(
                    data = x,
                    questions = questions,
                    question_names = question_names,
                    categories = categories,
                    answers = answers,
                    output = output,
                    verbose = verbose
                )
                if(verbose)message(rep("\n====", 3),
                    "\nDone Short Answer questions!",
                    "\n====\n")

            }
        }
    }



