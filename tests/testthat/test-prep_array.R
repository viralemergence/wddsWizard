test_that("prep array works", {

  nested_list <- list(list("formats" = list("formats" = "csv",
  "formats" = "fasta")))

  expect_no_failure(prep_array(nested_list))
})


test_that("prep array fails", {
  hello <- c("hello","world")
  expect_error(  prep_array(hello))
})
