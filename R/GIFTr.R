#'
#' @title Generate A GIFT File of Different Question Types From a Spreadsheet
#' @description  GIFTr function is the main function of \pkg{GIFTr} package.
#' You provide it dataframe and select \code{question_type} column
#' where a more specialized functions can process the file. See Details and Examples
#' @details \pkg{GIFTr} package is intended to reduce the time a course creator would
#' take to make input question on MOODLE without the pain of writing markup.\cr
#' \cr
#' \pkg{GIFTr} package is buid on \href{https://docs.moodle.org/37/en/GIFT_format}{MOODLE guidlines}. The idea is simple, you create a spreadsheet in a special format, call \code{GIFTr} function, get a GIFT formated file that can be imported by MOODLE and other LMS systems.
#'
#' \code{question_type} argument is unique for \code{GIFTr} function in this package and must be passed to map the questions. The current supported question types are \strong{\code{\link{mcq}{MCQ}}, \code{\link{num_q}{numeric entery}}, \code{\link{tf_q}{true or talse}}, and \code{\link{short_ans}{short answer}}}questions.You can find more details on the individual functions details. \cr\cr GIFTr supports basic markdown and GIFT syntax. See the vignette and sections below for complete documentation of formating your data.
#' @section Formating Your Data: Check the data \code{\link{GIFTrData}} and  \code{\link{GIFTrData_2}} as example for formating your questions.
#'
#' \subsection{Markdown and HTML Support}{ MOODLE itself supports basic markdown and HTML for questions formating. So when formating your data you can use HTML tags like <sub> and <sup>. Also you can use markdown  **bold** or __bold__ and  *italic* or _italic_ ...etc. However it is better a better practice to avoid using asterisk to avoid confusion with MCQ format.}
#' \subsection{Data columns}{The data passed would differ slightly according to question type, however generally you need to have \enumerate{
#' \item a column contains question. This cannot contain empty values
#' \item answer(s) column(s). This may be multiple columns if you have multiple answers. If you mix single and multiple answer it is better to write the single answer in the first column. If you have \em{only single answer MCQ and NO multiple answer MCQ}, you can set the answers without astrisk in the first column of the answers columns. More details in the vignette and below.
#'
#'
#'
#' }
#'   }
#'
#' @param data dataframe or tibble of the questions data
#' @param questions name(string) or index(integer) of the questions column
#' @param answers a vector of names(strings) or indices of answers column(s)
#' @param categories name(string) or index(integer), Default: NULL
#' of categories column if available.
#' @param question_names name(string) or index(integer) of the questions names column. If NULL, it will be the first 40 letters of the question title, Default: NULL
#' @param question_type name(string) or index(integer) of the questions column.
#' @param mcq_answer_column If TRUE, the first column of answers columns will be set as the right answer, Default: FALSE
#' @param output directory of .txt file name the questions will be exported to.
#'
#'
#' @examples
#' \dontrun{
#'  data(GIFTrData)
#'  str(GIFTrData)
#'
#'  GIFTr::GIFTr(data = GIFTrData, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_type = 9,
#'  output = 'quiz.txt') #create 'quiz.txt output'
#'
#'  #Use `question_names` Column argument
#'  GIFTr::GIFTr(data = GIFTrData, question_names = 2,
#'  questions = 3, answers = c(4:8),
#'  categories = 1, question_type = 9,
#'  output = 'quiz2.txt') #create 'quiz2.txt output'
#'  }
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
             mcq_answer_column = FALSE) {
        # remove empty rows
        data <- dgift(data, questions)
        # check valid question_types
        if (is.null(question_type)) {
            stop("`question_type` cannot be empty")
        }

        errorv <-
            data[, question_type] %in% c("mcq", "tf_q", "num_q", "short_ans")
        if (any(!errorv)) {
            print(data[which(!errorv), question_type])
            stop(
                "`question_type` column contains value that is not 'mcq',
                'tf_q',
                'num_q' or 'short_ans'"
            )
        }

        # Show statistics
        cat("Total Number of Questions passed: ", nrow(data))
        if (!is.null(categories)) {
            print(addmargins(table(data[, categories], data[, question_type])))

        }
        cat(rep("\n====", 3), "\n====\n")

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
                    output = output
                )
                cat(rep("\n====", 3), "\nDone MCQ!", "\n===\n")
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
                    output = output
                )
                cat(rep("\n====", 3),
                    "\nDone T/F questions!\n",
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
                    output = output
                )
                cat(rep("\n====", 3),
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
                    output = output
                )
                cat(rep("\n====", 3),
                    "\nDone Short Answer questions!",
                    "\n====\n")

            }
        }
    }



