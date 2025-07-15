test_that("sanitize_version works", {
  expect_no_failure(sanitize_version("v.1.1.0"))
})

test_that("sanitize_version fails if not character", {
  expect_error(sanitize_version(1.10))
})
