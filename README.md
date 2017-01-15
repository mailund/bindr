[![Build Status](https://travis-ci.org/mailund/bindr.svg?branch=master)](https://travis-ci.org/mailund/bindr) 
[![Coverage Status](https://img.shields.io/codecov/c/github/mailund/bindr/master.svg)](https://codecov.io/github/mailund/bindr?branch=master)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%203%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html) [![CRAN](http://www.r-pkg.org/badges/version/bindr)](https://cran.rstudio.com/web/packages/bindr/index.html) 
[![Downloads](http://cranlogs.r-pkg.org/badges/bindr?color=brightgreen)](http://www.r-pkg.org/pkg/bindr)

When a function returns multiple non-primitive types these are usually returned wrapped in a list. You then need to index into the list to extract the values. Using the `bind` function in this package, together with the `%<-%` operator, you can instead bind such values to local variables. The simplest usage is to just give `bind` the variables you want to bind to values and then assign them using `%<-%`:


```r
f <- function(x, y) c(x, y)
g <- function(x, y) list(x, y)

bind(a, b) %<-% f(1, 2)
bind(a, b) %<-% g(1, 2)
```

Values are just bound to local variables in the same order as they are given by the expression on the right-hand-side of `%<-%`. If there are more values than variables, the remaining values are just discarded. For example, 

```r
bind(a) %<-% f(1, 2)
```

just binds `a` to 1 and ignores `2`.

It is also possible to specify expressions in a binding. To do this, you must provide a variable to be assigned to, as for the positional variables, and an expression. This expression is evaluated in the context of the value the bind expression receives from the right-hand side of `%<-%` and the scope where the `bind` function is called. For example

```r
bind(a = 2*x, b = 3*y) %<-% list(x = 2, y = 4)
```

will leave `a` bound to 4 (`2*2`) and `b` bound to 12 (`3*4`), and 

```r
a <- 2
bind(b = a*x + 3*y) %<-% list(x = 2, y = 4)
```

will leave `b` assigned to 16.

If you combine positional and expression specifications the positional arguments will *always* match the position in the call to `bind`. So in the code below, both `a` and `b` will be assigned the value 4

```r
bind(a = y, b) %<-% list(x = 2, y = 4)
```

