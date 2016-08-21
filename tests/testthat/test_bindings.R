context("Bindings")

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

test_that("we can bind values through expressoins", {
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

})
