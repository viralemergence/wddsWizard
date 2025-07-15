test_that("prep_object works", {
  # df
  df <- data.frame("a" = "hello")
  expect_no_failure(
    prep_object(df)
  )

  # list
  named_list <- list("a" = "hello")
  expect_no_failure(
    prep_object(named_list)
  )

  # vector
  named_vector <- c("a" = "hello")
  expect_no_failure(
    prep_object(named_vector)
  )
})

test_that("prep_object fails with unnamed object", {
  # top level items must be named
  x <- list(1, list(a = 1))

  expect_error(
    prep_object(x)
  )
})
