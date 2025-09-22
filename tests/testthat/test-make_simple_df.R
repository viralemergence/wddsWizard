test_that("make_simple_df works", {
  expect_no_failure(make_simple_df(property = "language", value = "fr"))
  expect_no_failure(make_simple_df(property = "language", value = 10))
})

test_that("make_simple_df fails string", {
  expect_error(make_simple_df(property = 1, value = "fr"))
})


test_that("make_simple_df fails scalar", {
  expect_error(make_simple_df(property = "language", value = 1:10))
})
