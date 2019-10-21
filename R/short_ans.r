#' @title Generate 'GIFT' Short Answer From Spreadsheet
#' @description Create 'GIFT' file with short answer questions from a spreadsheet to be exported to LMS.
#' @param data dataframe or tibble of short answer questions data
#' @inheritParams num_q
#' @details \code{short_ans} function takes a dataframe with short answer questions and export a text file in 'MOODLE' GIFT format. The function automatically makes a short answer question either single or multiple with or without different credit weight according to your data format(check short answer questions formatting below). If you have additional column of question_type set to `short_ans` you can also use \link{GIFTr} function which wraps all question generating functions.\cr\cr See Vignette and \link{GIFTrData} for demos.
#'
#' @inheritSection GIFTr Formatting Your Data
#'
#' @section Short Answer Questions Formatting:
#' Short answer question answers can be in single column or multiple columns. If an answer has not credit it will be given 100\% credit automatically. For example if the answer is 'statistics', it will be equivalent to '\%100\%statistics'. While '\%80\%Data Science' answer will take 80\% of the credit  \cr\cr For further illustration, check \link{GIFTrData}.
#' @return None
#' @examples
#' data(GIFTrData)
#' #data with short answer question type
#' shortans_data <- GIFTrData[which(GIFTrData$question_type == "short_ans"),]
#'
#' short_ans(data = shortans_data, questions = 3,
#'  answers = c(4:8), categories = 1,
#'  question_names = 2, output = file.path(tempdir(), "shortq.txt"))
#'  #write file "shortq.txt" in tempdir()
#'
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname short_ans
#' @export
#' @importFrom glue glue
#
short_ans <- function(data, questions, answers, categories, question_names = NULL, output, verbose = TRUE) {


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
    vans <- 0
    noans <- 0
    pass <- 0

    cat(glue::glue("\n\n\n", "//Short Answer questions"), file = output, append = TRUE)
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
            next
        }

        pass <- pass + 1

        # print categories
        if (!is.na(data[i, categories])) {
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = TRUE)
        }


        if (length(ans) >= 1) {
            vans <- vans + 1
            cat(glue::glue("\n\n\n", "::{{data[i, question_names]}}::", "[markdown]{{data[i, questions]}}{",
                .open = "{{", .close = "}}"), file = output, append = TRUE)

            for (ii in 1:length(ans)) {
                cat(glue::glue("={ans[ii]}"), file = output, append = TRUE)
            }

            cat(glue::glue("\n }"), file = output, append = TRUE)
        }

    }  # loop end


    if(verbose)message(glue::glue("total short answer questions passed is {pass}. \n Valid answer: {vans} \n error in {noq + noans} \n {noq} no question has been found \n {noans} no valid answer has been found"))

}  # function end




