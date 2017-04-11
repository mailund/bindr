context("Bindings")

test_that("we can return complex objects", {
  f <- function() {
    fit <- glm(qsec ~ ., data=mtcars)
    return(list(fit, mtcars, nrow(mtcars)))
  }

  bind(model, df, size) %<-% f()
  expect_is(model, "lm")
  expect_is(model, "glm")
  expect_is(df, "data.frame")
  expect_equal(size, 32)      # mtcars sample is known to be 32 rows
})

test_that("we can bind values by position", {
  f <- function(x, y) c(x, y)
  g <- function(x, y) list(x, y)

  bind(a, b) %<-% f(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a, b) %<-% g(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

})

test_that("we get an error if we try to bind too many variables", {
  expect_error(bind(a, b, c) %<-% 1:2)
})

test_that("we can bind values through expressions", {
  f <- function(x, y) c(x = x, y = y)
  g <- function(x, y) list(x = x, y = y)

  bind(a = x, b = y) %<-% f(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a = x, b = y) %<-% g(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a, b = y) %<-% f(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a, b = y) %<-% g(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a = x, b) %<-% f(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a = x, b) %<-% g(1, 2)
  expect_equal(a, 1)
  expect_equal(b, 2)
  rm(a) ; rm(b)

  bind(a = 2*x, b = 3*y) %<-% f(1, 2)
  expect_equal(a, 2*1)
  expect_equal(b, 3*2)
  rm(a) ; rm(b)

  bind(a = 2*x, b = 3*y) %<-% g(1, 2)
  expect_equal(a, 2*1)
  expect_equal(b, 3*2)
  rm(a) ; rm(b)

  bind(b = 2*x, a = 3*y) %<-% f(1, 2)
  expect_equal(a, 3*2)
  expect_equal(b, 2*1)
  rm(a) ; rm(b)

  bind(b = 2*x, a = 3*y) %<-% g(1, 2)
  expect_equal(b, 2*1)
  expect_equal(a, 3*2)
  rm(a) ; rm(b)

})

test_that("we get an error if we try to bind an expression", {
  expect_error(bind(2*a, b) %<-% 1:2)
})
