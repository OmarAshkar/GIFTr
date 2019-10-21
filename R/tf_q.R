#' @title Generate GIFT True or False Questions From Spreadsheet
#' @description Create GIFT file with true or false questions from a spreadsheet to be exported to LMS.
#' @param data dataframe or tibble of true or false questions data
#' @inheritParams num_q
#' @details \code{tf_q} function takes a dataframe with true or false questions and export a text file in 'MOODLE' GIFT format. The function automatically makes a true or false when it detect `T` or 'F' in the answers vector regardless of case. If you have additional column of question_type set to `tf_q` you can also use \link{GIFTr} function which wraps all question generating functions.\cr\cr See Vignette and \link{GIFTrData} for demos.
#'
#' @inheritSection GIFTr Formatting Your Data
#'
#' @section True or False Questions Formatting:
#' True or False answers is to be set in 1 column with letter 'T' or 'F' insensitive to the case.  \cr\cr For further illustration, check \link{GIFTrData}.
#' @return None
#' @examples
#' data(GIFTrData)
#' #data with true or false question type
#' tf_data <- GIFTrData[which(GIFTrData$question_type == "tf_q"),]
#'
#' tf_q(data = tf_data, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_names = 2, output =  file.path(tempdir(), "tfq.txt")))
#'  #write file "tfq.txt" in tempdir()
#'  }
#'
#'
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname tf_q
#' @export
#' @importFrom glue glue
#
tf_q <- function(data, questions, answers, categories, question_names = NULL, output, verbose = TRUE) {
    # Check questions validity
    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }

    #encoding options
    (oldops <- options(encoding = "UTF-8"))
    on.exit(options(oldops))

    # Total number of questions
    n <- nrow(data)
    noq <- 0
    noans <- 0
    pass <- 0
    cat(glue::glue("\n\n\n", "// T/F questions"), file = output, append = TRUE)
    # Loop all rows
    for (i in 1:n) {
        if (is.na(data[i, questions])) {
            noq <- noq + +next
        }

        answer <- tolower(na.omit(unlist(data[i, answers])))

        if (length(answer) > 1) {
            warning(glue::glue("Invalid answer in {i} row"))
            noans <- noans + 1
            next
        }

        if (!(answer %in% c("t", "f"))) {
            warning(glue::glue("Invalid answer in {i} row"))
            noans <- noans + 1
            next
        }

        pass <- pass + 1

        if (!is.na(data[i, categories])) {
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = TRUE)
        }

        cat(glue("\n\n\n", "::{}data[i,question_names]{}}::", "[markdown]{}data[i,questions]{}} {{}toupper(answer){}}}",
            .open = "{}", .close = "{}}"), file = output, append = TRUE)
    }  # loop end

    if(verbose)message(glue::glue("\n",
                       "T/F questions passed input: {n} \n",
                       "T/F questions Passed: {pass} \n",
                       "Error found: {noq + noans} \n",
                       "No question found : {noq} \n",
                       "No valid answer found: {noans}"))

}  # function end
