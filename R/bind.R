#' Bind local variables to the return values of a function
#'
#' Bind return values from a function to local variables by combining the \code{bind}
#' function with the \code{\%<-\%} operator. When a function returns an object that is
#' a vector or list you will normally have to index into that result to get individual
#' components.
#'
#' Using \code{bind} you can values in a vector or list to local variables, so
#'
#' \code{bind(a, b, c) \%<-\% 1:3}
#'
#' binds \code{a}, \code{b}, and \code{c} to values 1, 2, and 3, respectively.
#'
#' @param ...  List of variables to bind.
#' @return     An object containing the variable to be bound. This should be used
#'             in combination with the \code{\%<-\%} operator to bind values to
#'             parameters.
#'
#' @examples
#' f <- function(x, y) c(x, y)
#' bind(a, b) %<-% f(1, 2)
#'
#' g <- function(x, y) list(x, y)
#' bind(a, b) %<-% g(1, 2)
#'
#' @export
bind <- function(...) {
  bindings <- eval(substitute(alist(...))) # get the arguments passed to `bind`.
  scope <- parent.frame() # this is where we will put new variables...
  structure(list(bindings = bindings, scope = scope), class = "bindings")
}

.unpack <- function(x) UseMethod(".unpack")
.unpack.default <-  function(x) x
.unpack.list <- function(x) x[[1]]

#' Bind a `bind` object to values.
#'
#' Used to bind variables in the local scope to values, typically returned from
#' a function. A `bind` object is created using the \code{\link{bind}} function and
#' assigned to with this operator. Assigning this way will bind the parameters
#' specified in the \code{\link{bind}} call to the values on the right-hand-side
#' of the assignment.
#'
#' @param bindings   A bindings object returned by the \code{\link{bind}} function.
#' @param value      Values in a list/vector to be bound to the variables.
#'
#' @usage bindings \%<-\% value
#'
#' @examples
#' f <- function(x, y) c(x, y)
#' bind(a, b) %<-% f(1, 2)
#'
#' g <- function(x, y) list(x, y)
#' bind(a, b) %<-% g(1, 2)
#'
#' @seealso \code{\link{bind}}
#'
#' @export
`%<-%` <- function(bindings, value) {
  if (length(bindings$bindings) > length(value))
    stop("More variables than values to bind.")

  for (i in seq_along(bindings$bindings)) {
    variable <- bindings$bindings[[i]]
    val <- .unpack(value[i])
    assign(as.character(variable), val, envir = bindings$scope)
  }
}

