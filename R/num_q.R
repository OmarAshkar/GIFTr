#' @title Generate GIFT Numeric Questions From Spreadsheet
#' @description Create GIFT file with numeric entry questions from a spreadsheet to be exported to LMS.
#' @param data dataframe or tibble of numerical entry questions data
#' @param questions name(string) or index(integer) of the questions column
#' @param answers  a vector of names(strings) or indices of answers column(s)
#' @param categories name(string) or index(integer) of categories column if available, Default: NULL
#' @param question_names name(string) or index(integer) of the questions names column. If NULL, it will be the first 40 letters of the question title, Default: NULL
#' @param output string of .txt file name and path where the questions will be exported to.
#' @param verbose If TRUE, the functions will print to the console the statistics of writing the output, Default: TRUE
#' @details  \code{num_q} function takes a dataframe with numeric entry questions and export a text file in 'MOODLE' GIFT format. The function automatically makes an numeric entry question either single or multiple according to your data format(check numeric questions formatting below). If you have additional column of question_type set to `num_q` you can also use \link{GIFTr} function which wraps all question generating functions.\cr\cr See Vignette and \link{GIFTrData} for demos.
#' @inheritSection GIFTr Formatting Your Data
#' @section Numeric Entry Questions Formatting:
#' Numeric Answer can be in single column or multiple columns. You can also format it as range or
#' interval limit for the answer and partial credit. For further illustration, check the vignette.
#' \subsection{Numeric Range and Intervals}{If you want the answer to be between 1 and 2, you can
#' enter you data as `1..2`. If you want to set an acceptance limit, for example your answer is
#' `158` and you want to set limit plus or minus 2, you can write it as `158:2`. Check the
#' \link{GIFTrData} for examples.}
#' \subsection{Multiple Numeric Answers with partial credits}{You enter multiple numeric answers
#' with the same concepts above, but if you did not enter the credits for an answer, 'MOODLE' will
#' consider it `100\%`. So you have to specify the credit at the start of an answer.
#' For example `122` and `\%50\%122:5`.}
#' @return None
#' @examples
#' data(GIFTrData)
#' #data with numeric entry questions
#' numq_data <- GIFTrData[which(GIFTrData$question_type == "num_q"),]
#'
#' num_q(data = numq_data, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_names = 2, output = file.path(tempdir(), "numq.txt"))
#'  #write file "numq.txt" in tempdir()
#'
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname num_q
#' @export
#' @importFrom glue glue
#
num_q <- function(data, questions, answers, categories, question_names = NULL, output, verbose = TRUE) {

    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }

    #encoding options
    (oldops <- options(encoding = "UTF-8"))
    on.exit(options(oldops))

    n <- nrow(data)
    noq <- 0
    noans <- 0
    pass <- 0

    oneans <- 0
    twoans <- 0



    cat(glue::glue("\n\n\n", "// Numeric Entry questions"), file = output, append = TRUE)
    for (i in 1:n) {
        # check question validity
        if (is.na(data[i, questions])) {
            noq <- noq + 1
            next
        }
        # create answer vector
        ans <- na.omit(unlist(data[i, answers]))

        # check and edit answer vector
        if (length(ans) < 1) {
            noans <- noans + 1
            # skip this row
            next
        }

        pass <- pass + 1

        # print categories
        if (!is.na(data[i, categories])) {
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = TRUE)
        }

        if (length(ans) == 1) {
            oneans <- oneans + 1
            cat(glue("\n\n\n", "::{{data[i,question_names]}}::", "[markdown]{{data[i, questions]}}{#{{ans}}}",
                .open = "{{", .close = "}}"), file = output, append = TRUE)
        }

        # 2 answers of numerical questions
        if (length(ans) > 1) {
            twoans <- twoans + 1
            cat(glue("\n\n\n", "::{{data[i,question_names]}}::", "[markdown]{{data[i, questions]}}{# \n",
                .open = "{{", .close = "}}"), file = output, append = TRUE)

            for (ii in 1:length(ans)) {
                cat(glue::glue("\n\n", "={ans[ii]}"), file = output, append = TRUE)
            }

            cat(glue::glue("\n\n }"), file = output, append = TRUE)
        }

    }  # loop end

    if(verbose)message(glue::glue("\n",
                       "Numerical questions input count: {pass} \n",
                       "Numerical questions with single answer passed: {oneans} \n",
                       "Numerical questions questions with multiple answers passed: {twoans} \n",
                       "Error found: {noq + noans} \n",
                       "No valid question found : {noq} \n",
                       "No valid answer found: {noans}"))

}  # function end


