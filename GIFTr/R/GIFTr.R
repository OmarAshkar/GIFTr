# source("R\\mcq.R")
# source("R\\tf_q.R")
# source("R\\num_q.R")
# source("R\\short_ans.R")


#' Generate a GIFT file contains all supported question types
#'
#' @param data dataframe of questions
#' @param questions name(string) or index(integer) of the questions column
#' @param answers a vector of names(strings) or indices of answers column(s)
#' @param categories Default is NULL. name(string) or index(integer) of the questions column.
#' @param question_names Default is NULL. name(string) or index(integer) of the questions column. If NULL, it will be the first 40 letters of the question title.
#' @param question_Type name(string) or index(integer) of the questions column
#' @param output directory of file name the questions will be exported to.
#'
#' @return NULL
#' @export
#'
#' @examples
#'
GIFTr <- function(data, questions, answers, categories = NULL, question_names = NULL, question_Type, output) {
    # split by question type
    sdat <- split(data, f = data[, question_Type])
    col_names <- names(data)

    # Loop question types
    for (i in 1:length(sdat)) {

        if (names(sdat[i]) == "mcq") {
            x = rename_df(datalist = sdat, col_names = col_names, i = i)
            mcq(data = x , questions = questions, categories = categories,
                answers = answers, output = output)
            cat(rep("\n====", 3), "Done MCQ!\n")
        }


        if (names(sdat[i]) == "tf_q") {
            x = rename_df(datalist = sdat, col_names = col_names, i = i)
            tf_q(data = x, questions = questions, categories = categories,
                answers = answers, output = output)
            cat(rep("\n====", 3), "Done T/F questions!\n")

        }

        if (names(sdat[i]) == "num_q") {
            x = rename_df(datalist = sdat, col_names = col_names, i = i)
            num_q(data = x, questions = questions, categories = categories,
                answers = answers, output = output)
            cat(rep("\n====", 3), "Done Numerical questions!\n")
        }

        if (names(sdat[i]) == "short_ans") {
            x = rename_df(datalist = sdat, col_names = col_names, i = i)
            short_ans(data = x, questions = questions, categories = categories,
                answers = answers, output = output)
            cat(rep("\n====", 3), "Done Short Answer questions!\n")

        }
    }
}




