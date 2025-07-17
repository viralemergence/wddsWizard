test_that("list_deposit_versions works", {
  skip_if_offline()
  expect_no_failure(list_deposit_versions())
})

test_that("list_deposit_versions fails with non character", {
  expect_error(list_deposit_versions(parent_id = 1))
})
