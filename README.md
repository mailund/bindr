[![Build Status](https://travis-ci.org/mailund/bindr.svg?branch=master)](https://travis-ci.org/mailund/bindr) 
[![Coverage Status](https://img.shields.io/codecov/c/github/mailund/bindr/master.svg)](https://codecov.io/github/mailund/bindr?branch=master)
[![License](http://img.shields.io/badge/license-GPL%20%28%3E=%203%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-3.0.html) <!-- [![CRAN](http://www.r-pkg.org/badges/version/bindr)](https://cran.rstudio.com/web/packages/bindr/index.html) 
[![Downloads](http://cranlogs.r-pkg.org/badges/bindr?color=brightgreen)](http://www.r-pkg.org/pkg/units) -->


```r
f <- function(x, y) c(x, y)
g <- function(x, y) list(x, y)

bind(a, b) %<-% f(1, 2)
bind(a, b) %<-% g(1, 2)
```

