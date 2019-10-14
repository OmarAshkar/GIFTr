#' @title Questions Data with asterisk and multiple answer mcq
#' @description DATASET_DESCRIPTION
#' @docType data
#' @usage data(GIFTrData)
#' @format A data frame with 10 rows and 9 variables:
#' \describe{
#'   \item{\code{categories}}{character categories of questions to be
#'   imported to 'MOODLE' to hierarchical order}
#'   \item{\code{names}}{character names of the questions}
#'   \item{\code{question}}{character question text}
#'   \item{\code{A}}{character first answer option}
#'   \item{\code{B}}{character second answer option}
#'   \item{\code{C}}{character third answer option}
#'   \item{\code{D}}{character fourth answer option}
#'   \item{\code{E}}{character fifth answer option}
#'   \item{\code{question_type}}{character question type value should be either `mcq`, `num_q`, `tf_q`, `short_ans` }
#'}
#' @details This data is a demo on a typical structure of data passed in \pkg{'GIFTr'} package.
#' This data mcq question contains asterisk in the first 2 questions,
#' one with single answer and the other is multiple answers question.
#'
#' @section Formatting Tips:
#' \subsection{markdown}{Markdown is supported in GIFT format and example for it's usage in first and second question text.}
#' \subsection{HTML}{Simple HTML syntax is supported as in question 10}
#' \subsection{LATEX}{LATEX is supported in GIFT but you have to escape any curly brackets as in question 11}
#' \subsection{Partial Credits}{Partial Credits for a question can be specified if like in question 9, you could also use them in short answer question. If you have a short answer question or numeric question with no specified credits, this answer will take "100\%" credit}
#' \subsection{Answer Feedback}{Every answer can by accompanied with feedback using # as in questions 1 and 9}
#' @seealso \link{GIFTrData_2} \link{GIFTr} \link{mcq}
"GIFTrData"

#' @title Questions Data without asterisk
#' @description This data is a manipulated copy of \link{GIFTrData} data with removal of the multiple answers mcq and removal of asterisk from the single answer mcq.
#' @docType data
#' @usage data(GIFTrData_2)
#' @format A data frame with 10 rows and 9 variables:
#' \describe{
#'   \item{\code{categories}}{character categories of questions to be
#'   imported to 'MOODLE' to hierarchical order}
#'   \item{\code{names}}{character names of the questions}
#'   \item{\code{question}}{character question text}
#'   \item{\code{A}}{character first answer option, this column must be the answer column for mcq}
#'   \item{\code{B}}{character second answer option}
#'   \item{\code{C}}{character third answer option}
#'   \item{\code{D}}{character fourth answer option}
#'   \item{\code{E}}{character fifth answer option}
#'   \item{\code{question_type}}{character question type value should be either `mcq`, `num_q`, `tf_q`, `short_ans` }
#'}
#' @details This data is an altered form of \link{GIFTrData}. Check it usage in \link{mcq}. For further details on the data structure, check \link{GIFTr} documentation.
#' @seealso \link{GIFTrData} \link{GIFTr} \link{mcq}
"GIFTrData_2"

