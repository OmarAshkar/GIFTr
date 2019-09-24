#source("R\\dgift.R")

#' Title
#'
#' @param data
#' @param questions
#' @param answers
#' @param categories
#' @param question_names
#' @param output
#' @param ...
#'
#' @return
#' @export
#'
#' @importFrom glue glue
#' @importFrom stats na.omit
#' @examples
tf_q <- function(data, questions, answers, categories, question_names = NULL, output,
    ...) {
    # Check questions validity
    data <- dgift(data, questions)

    if(is.null(question_names)){
        question_names <- q_name(data , questions)
    }

    # Force encoding
    options(encoding = "UTF-8")
    # Total number of questions
    n <- nrow(data)
    noq <- 0
    noans <- 0
    pass <- 0
    cat(glue::glue("//{T/F questions}"), file = output, append = T)
    # Loop all rows
    for (i in 1:n) {
        if (is.na(data[i, questions])) {
            noq <- noq + +next
        }

        answer <- tolower(na.omit(unlist(data[i, answers])))

        if (length(answer) > 1) {
            print(glue::glue("Invalid answer in {i} row"))
            noans <- noans + 1
            next
        }

        if (!(answer %in% c("t", "f"))) {
            print(glue::glue("Invalid answer in {i} row"))
            noans <- noans + 1
            next
        }

        pass <- pass + 1

        if (!is.na(data[i, categories])) {
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = T)
        }

        cat(glue("\n\n\n","::{}question_names[i]{}}::", "[markdown]{}data[i,questions]{}} {{}toupper(answer){}}}", .open = "{}", .close = "{}}"),
            file = output, append = T)
    }  # loop end

    print(glue::glue("\n T/F questions passed input: {n} \n T/F questions Passed: {pass} \n Error found: {noq + noans} \n No question found : {noq} \n No valid answer found: {noans}"))

}  # function end
