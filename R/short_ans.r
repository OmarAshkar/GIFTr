#' @title Create GIFT File with Short Answer Questions From Spreadsheet
#' @description FUNCTION_DESCRIPTION
#' @inheritParams num_q
#' @details DETAILS
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname short_ans
#' @export
#' @importFrom glue glue
#
short_ans <- function(data, questions, answers, categories, question_names = NULL, output) {


    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }

    options(encoding = "UTF-8")
    n <- nrow(data)

    noq <- 0
    vans <- 0
    noans <- 0
    pass <- 0

    cat(glue::glue("\n\n\n", "//Short Answer questions"), file = output, append = T)
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
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = T)
        }


        if (length(ans) >= 1) {
            vans <- vans + 1
            cat(glue::glue("\n\n\n", "::{{data[i, question_names]}}::", "[markdown]{{data[i, questions]}}{",
                .open = "{{", .close = "}}"), file = output, append = T)

            for (ii in 1:length(ans)) {
                cat(glue::glue("={ans[ii]}"), file = output, append = T)
            }

            cat(glue::glue("\n }"), file = output, append = T)
        }




    }  # loop end



    cat(glue::glue("total questions passed is {pass}. \n Valid answer: {vans} \n error in {noq + noans} \n {noq} no question has been found \n {noans} no valid answer has been found"))

}  # function end




