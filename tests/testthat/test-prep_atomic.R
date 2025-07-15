test_that("prep atomic works", {
  expect_no_failure(prep_atomic("hello"))
})

test_that("prep atomic fails where with multi-row multi-col df", {
  expect_error(prep_atomic(data.frame(a = 1:4, b = 1:4)))
})

test_that("prep atomic fails where with not vector", {
  expect_error(expect_failure(prep_atomic(list(1))))
})

test_that("prep atomic fails where with multi-item vector", {
  expect_error(expect_failure(prep_atomic(1:10)))
})
