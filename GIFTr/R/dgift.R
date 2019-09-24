dgift <- function(data, questions) {
    # remove empty rows
    data <- data[!apply(is.na(data) | data == "", 1, all), ]
     if (any(data[, questions] %in% c(NA, "" , " "))) {
          stop("Invalid questions Column contain empty cells")
     }
    return(data)
}

make_answer <- function(data, answercol) {
    # check if there is any empty cell
    if (any(data[, answercol] %in%  c(NA, "" , " "))) {
        stop("The column of Answers Selected contains Empty Cells")
    }
    data[, answercol] <- glue::glue("* {data[,answercol] }")
    data
}

rename_df <- function(datalist, col_names , i){
    data <- as.data.frame(datalist[i])
    names(data) <- col_names
    return(data)
}


q_name <- function(data , questions){
    data$q_names = glue::glue("{substr(data[,questions] , start = 1 , stop = 40)}...")
    return(data$q_names)
}
