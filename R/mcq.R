#' @title Create GIFT File with Single & Multiple Answers MCQs From Spreadsheet
#' @description FUNCTION_DESCRIPTION
#' @param data PARAM_DESCRIPTION
#' @param questions PARAM_DESCRIPTION
#' @param answers PARAM_DESCRIPTION
#' @param categories PARAM_DESCRIPTION, Default: NULL
#' @param question_names PARAM_DESCRIPTION, Default: NULL
#' @param output PARAM_DESCRIPTION
#' @param make_answer PARAM_DESCRIPTION, Default: F
#' @details DETAILS
#' @inheritSection GIFTr Formating Your Data
#' @examples
#' \dontrun{
#' if(interactive()){
#'  #EXAMPLE1
#'  }
#' }
#' @seealso
#'  \code{\link[GIFTr]{GIFTr}}
#' @rdname mcq
#' @export
#' @importFrom glue glue
#' @importFrom stringr str_detect str_replace
#' @importFrom stats na.omit
mcq <- function(data, questions, answers, categories = NULL, question_names = NULL, output, make_answer = FALSE) {


    data <- dgift(data, questions)

    if (is.null(question_names)) {
        data <- q_name(data, questions)
        question_names <- "q_names"
    }

    options(encoding = "UTF-8")
    # total number of questions passed for mcq category
    n <- nrow(data)
    pass <- 0
    noQ <- 0
    noans <- 0
    singleans <- 0
    multipleans <- 0

    if (make_answer == T) {
        data <- make_answer(data, answercol = answers[1])
    }

    cat(glue::glue("\n\n\n", "// MCQ questions"), file = output, append = T)
    for (i in 1:n) {
        if (data[i, questions] %in% c(NA, "", " ")) {
            print(glue::glue("Error: no question found in \"{row.names(data)[i]}\" row"))
            next
        }

        # start rows for-loop
        answertemp <- na.omit(unlist(data[i, answers]))
        # holder and reset for formated text
        answertemp2 <- c()


        # count of answers
        n_ans <- sum(grepl(pattern = "^(\\*)(.*)", x = answertemp))

        # validate if there is an answer
        if (n_ans == 0) {
            noans <- noans + 1
            print(glue::glue("Error: There is no valid answer for MCQ {data[i, questions]}"))
            next
        }

        if (n_ans > 1)
            {
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
            cat(glue::glue("\n\n\n", "$CATEGORY: {data[i,categories]}"), file = output, append = T)
        }

        cat(glue::glue("\n\n\n", "::{data[i,question_names]}::", "[markdown]{data[i , questions]}"),
            file = output, append = T)

        cat(glue::glue(("{"), .open = "{{"), file = output, append = T)

        # print formated answers
        for (iv in 1:length(answertemp)) {
            cat(glue::glue("\n\n", "{answertemp2[iv]}"), file = output, append = T)
        }

        cat(glue::glue(("\n\n}")), file = output, append = T)


    }

    # end rows for-loop

    print(glue("MCQ questions Input Count =", n, "\n", "MCQ with Multiple Answers = ", multipleans,
        "\n MCQ with single answers = ", singleans, "\n Invalid questions = ", noQ, "\n Invaild Answers = ",
        noans, "\n Total MCQ Failed = ", noQ + noans))
}







