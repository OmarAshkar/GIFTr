#' @title Generate GIFT MCQs From Spreadsheet
#' @description Create GIFT file with single & multiple answers MCQs from a spreadsheet to be exported to LMS.
#' @param data dataframe or tibble of mcq questions data
#' @param questions name(string) or index(integer) of the questions column
#' @param answers  a vector of names(strings) or indices of answers column(s)
#' @param categories name(string) or index(integer) of categories column if available, Default: NULL
#' @param question_names name(string) or index(integer) of the questions names column. If NULL, it will be the first 40 letters of the question title, Default: NULL
#' @param output string of .txt file name and path where the questions will be exported to.
#' @param make_answer If TRUE, the first column of answers columns will be set as the right answer, Default: FALSE.
#' @param verbose If TRUE, the functions will print to the console the statistics of writing the output, Default: TRUE
#' @return None
#' @details \code{mcq} function takes a dataframe with multiple choices questions(mcq) and export a text file in 'MOODLE' GIFT format. The function automatically makes an mcq a single answer or multiple answers depends on asterisks present in the answers column. If you have additional column of question_type set to `mcq` you can also use \link{GIFTr} function which wraps all question generating functions.\cr\cr See Vignette and \link{GIFTrData} for demos.
#'
#' @inheritSection GIFTr Formatting Your Data
#' @section Formatting Multiple Choices Questions: \subsection{Specifying mcq answer}{You can specify answers simply using asterisk in a the start on the answer. If you choose more than one answer, the function will generate a multiple answers mcq with every answer holds partial even credit. See \link{GIFTrData} for this usage. \cr\cr If you intend to \strong{use single answer only}, you might specify `make_answer` or `mcq_answer_column` to TRUE, this will consider the first answer column to be the answer. For example, if the answers are in columns c(5,9), the answers will be listed in the first column, 5. See \link{GIFTrData_2} for this usage.}
#'
#' @examples
#' #data with asterisk and multiple answer mcq(Q2 question)
#' data(GIFTrData)
#' mcqdata <- GIFTrData[which(GIFTrData$question_type == "mcq"),]
#'
#' mcq(data = mcqdata, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_names = 2, output = file.path(tempdir(), "mcq.txt"))
#'  #No make_answer argument, question_name specified
#'  #write file "mcq.txt"in tempdir()
#'
#' #data with no atrisk and no multiple answer mcq
#' mcqdata_2 <- GIFTrData_2[which(GIFTrData_2$question_type == "mcq"),]
#'
#' mcq(data = mcqdata_2, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_names = 2, make_answer = TRUE,
#'  output = file.path(tempdir(), "mcq_1.txt")) #Answer is in column 4
#'  #write file "mcq_1.txt"in tempdir()
#'
#'
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname mcq
#' @export
#' @importFrom glue glue
#' @importFrom stringr str_detect str_replace
#' @importFrom stats na.omit
mcq <- function(data, questions, answers, categories = NULL, question_names = NULL, output, make_answer = FALSE, verbose = TRUE) {


    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }
    #encoding options
    (oldops <- options(encoding = "UTF-8"))
    on.exit(options(oldops))

    # total number of questions passed for mcq category
    n <- nrow(data)
    pass <- 0
    noQ <- 0
    noans <- 0
    singleans <- 0
    multipleans <- 0

    if (make_answer == TRUE) {
        data <- make_answer(data, answercol = answers[1])
    }

    cat(glue::glue("\n\n\n", "// MCQ questions"), file = output, append = TRUE)
    for (i in 1:n) {
        if (data[i, questions] %in% c(NA, "", " ")) {
            warning(glue::glue("Error: no question found in \"{row.names(data)[i]}\" row"))
            next
        }

        # start rows for-loop
        answertemp <- na.omit(unlist(data[i, answers]))
        # holder and reset for formatted text
        answertemp2 <- c()


        # count of answers
        n_ans <- sum(grepl(pattern = "^(\\*)(.*)", x = answertemp))

        # validate if there is an answer
        if (n_ans == 0) {
            noans <- noans + 1
            warning(glue::glue("Error: There is no valid answer for MCQ {data[i, questions]}"))
            next
        }

        if (n_ans > 1)
            {
                #prevent multiple answers if make answer is true
                if(make_answer == TRUE){
                    warning(data[i,answers])
                    stop("You can't use `make_answer` argument and have another answer marked")
                    }
                multipleans <- multipleans + 1
                # start if-statment of multiple answers Get factor of grades
                factor <- as.character(100/n_ans)

                for (ii in 1:length(answertemp)) {
                  if (str_detect(answertemp[ii], pattern = "^(\\*)(.*)")) {
                    answertemp2 <- c(answertemp2, str_replace(answertemp[ii], pattern = "^(\\*)(.*)",
                      replacement = glue("~%{factor}% ", "\\2")))
                  } else {
                    answertemp2 <- c(answertemp2, str_replace(answertemp[ii], pattern = "^(.*)", replacement = glue("~%-{factor}% ",
                      "\\1")))

                  }

                }  # End for-loop of multiple answers


            }  # End if-statment of multiple answers





        if (n_ans == 1)
            {
                singleans <- singleans + 1
                # Start else for single correct answer
                for (iii in 1:length(answertemp)) {
                  if (str_detect(answertemp[iii], pattern = "^(\\*)(.*)")) {
                    answertemp2 <- c(answertemp2, str_replace(answertemp[iii], pattern = "^(\\*)(.*)",
                      replacement = "=\\2"))
                  } else {
                    answertemp2 <- c(answertemp2, str_replace(answertemp[iii], pattern = "^(.*)",
                      replacement = glue("~", "\\1")))

                  }

                }
            }  # End of else statement one answer




        if (!is.null(categories)) {
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = TRUE)
        }

        cat(glue::glue("\n\n\n", "::{data[i,question_names]}::", "[markdown]{data[i , questions]}"),
            file = output, append = TRUE)

        cat(glue::glue(("{"), .open = "{{"), file = output, append = TRUE)

        # print formatted answers
        for (iv in 1:length(answertemp)) {
            cat(glue::glue("\n\n", "{answertemp2[iv]}"), file = output, append = TRUE)
        }

        cat(glue::glue(("\n\n}")), file = output, append = TRUE)


    }

    # end rows for-loop
    if(verbose)message(glue::glue("\n",
                       "MCQ questions input count: {n} \n",
                       "MCQ questions with single answer passed: {singleans} \n",
                       "MCQ questions with multiple answers passed: {multipleans} \n",
                       "Error found: {noQ + noans} \n",
                       "No valid question found : {noQ} \n",
                       "No valid answer found: {noans}"))
}







