#' Bind local variables to the return values of a function
#'
#' Bind return values from a function to local variables by combining the \code{bind}
#' function with the \code{\%<-\%} operator. When a function returns an object that is
#' a vector or list you will normally have to index into that result to get individual
#' components.
#'
#' Using \code{bind} you can values in a vector or list to local variables, so
#'
#' \code{bind(x, y, z) \%<-\% 1:3}
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

.unpack <- function(x) unname(unlist(x, use.names = FALSE))[1]

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

  var_names <- names(bindings$bindings)
  val_names <- names(value)
  has_names <- which(nchar(val_names) > 0)
  value_env <- list2env(as.list(value[has_names]), parent = bindings$scope)

  for (i in seq_along(bindings$bindings)) {
    name <- var_names[i]
    if (length(var_names) == 0 || nchar(name) == 0) {
      # we don't have a name so the expression should be a name and we are
      # going for a positional value
      variable <- bindings$bindings[[i]]
      if (!is.name(variable)) stop(paste0("Positional variables cannot be expressions ",
                                          deparse(variable), "\n"))
      val <- .unpack(value[i])
      assign(as.character(variable), val, envir = bindings$scope)

    } else {
      # if we have a name we also have an expression and we evaluate that in the
      # environment of the value followed by the enclosing environment and assign
      # the result to the name.
      val <- eval(bindings$bindings[[i]], value_env)
      assign(name, val, envir = bindings$scope)
    }

  }
}

