#source("R\\dgift.R")


num_q <- function(data, questions, answers, categories,  question_names = NULL, output,
    ...) {

    data <- dgift(data, questions)

    if(is.null(question_names)){
        question_names <- q_name(data , questions)
    }

    options(encoding = "UTF-8")
    n <- nrow(data)

    noq <- 0
    noans <- 0
    pass <- 0

    oneans <- 0
    twoans <- 0



    cat(glue::glue("//{Numeric Entery questions}"), file = output, append = T)
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
            cat(glue("\n\n\n" ,"::{{question_names[i]}}::" , "[markdown]{{data[i, questions]}}{#{{ans}}}", .open = "{{",
                .close = "}}"), file = output, append = T)
        }

        # 2 answers of numerical questions
        if (length(ans) > 1) {
            twoans <- twoans + 1
            cat(glue("\n\n", "::{{question_names[i]}}::" , "[markdown]{{data[i, questions]}}{# \n", .open = "{{", .close = "}}"),
                file = output, append = T)

            for (ii in 1:length(ans)) {
                cat(glue::glue("={ans[ii]}"), file = output, append = T)
            }

            cat(glue::glue("\n }"), file = output, append = T)
        }

    }  # loop end

    cat(glue::glue("total questions passed is {pass}. \n single answer: {oneans} \n two answer: {twoans} \n error in {noq + noans} \n {noq} no question has been found \n {noans} no valid answer has been found"))

}  # function end


