dgift <- function(data, questions) {
    # remove empty rows
    data <- data[!apply(is.na(data) | data == "", 1, all),]
    if (any(data[, questions] %in% c(NA, "", " "))) {
        stop("Invalid questions Column contain empty cells")
    }
    return(data)
}

make_answer <- function(data, answercol) {
    # check if there is any empty cell
    if (any(data[, answercol] %in% c(NA, "", " "))) {
        stop("The column of Answers Selected contains Empty Cells")
    }
    data[, answercol] <- glue::glue("* {data[,answercol] }")
    data
}

rename_df <- function(datalist, col_names, i) {
    data <- as.data.frame(datalist[i])
    names(data) <- col_names
    return(data)
}


q_name <- function(data, questions) {
    data$q_names = glue::glue("{substr(data[,questions] , start = 1 , stop = 40)}...")
    return(data)
}

#' @importFrom stats addmargins
singular_input <- function(questions,
                           categories,
                           question_names,
                           question_type) {
    l <-
        as.list(c(questions, categories, question_names, question_type))
    llen <- lapply(l , FUN = length)
    lapply(llen, function(x)
        if (x > 1)
            stop(
                "'questions', 'categories', 'question_names' and 'question_type' Length cannot be bigger than 1" ,
            ))
    #check questions
    if (llen[1] == 0) {
        stop("`questions` input is invalid")
    }


}
