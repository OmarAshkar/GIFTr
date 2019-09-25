#' @title Create GIFT File with Numeric Entery Questions From Spreadsheet
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @param questions PARAM_DESCRIPTION
#' @param answers PARAM_DESCRIPTION
#' @param categories PARAM_DESCRIPTION, Default: NULL
#' @param question_names PARAM_DESCRIPTION, Default: NULL
#' @param output PARAM_DESCRIPTION
#' @return OUTPUT_DESCRIPTION
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname num_q
#' @export
#' @importFrom glue glue
#
num_q <- function(data, questions, answers, categories, question_names = NULL, output) {

    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }

    options(encoding = "UTF-8")
    n <- nrow(data)

    noq <- 0
    noans <- 0
    pass <- 0

    oneans <- 0
    twoans <- 0



    cat(glue::glue("\n\n\n", "// Numeric Entery questions"), file = output, append = T)
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
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = T)
        }

        if (length(ans) == 1) {
            oneans <- oneans + 1
            cat(glue("\n\n\n", "::{{data[i,question_names]}}::", "[markdown]{{data[i, questions]}}{#{{ans}}}",
                .open = "{{", .close = "}}"), file = output, append = T)
        }

        # 2 answers of numerical questions
        if (length(ans) > 1) {
            twoans <- twoans + 1
            cat(glue("\n\n\n", "::{{data[i,question_names]}}::", "[markdown]{{data[i, questions]}}{# \n",
                .open = "{{", .close = "}}"), file = output, append = T)

            for (ii in 1:length(ans)) {
                cat(glue::glue("\n\n", "={ans[ii]}"), file = output, append = T)
            }

            cat(glue::glue("\n\n }"), file = output, append = T)
        }

    }  # loop end

    cat(glue::glue("total questions passed is {pass}. \n single answer: {oneans} \n two answer: {twoans} \n error in {noq + noans} \n {noq} no question has been found \n {noans} no valid answer has been found"))

}  # function end


