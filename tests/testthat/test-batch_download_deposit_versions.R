test_that("batch_download_deposit_versions works", {
  skip_if_offline()
  expect_no_failure(batch_download_deposit_versions(dir_path = "data"))
})

test_that("batch_download_deposit_versions fails with non data frame", {
  expect_error(
    batch_download_deposit_versions(
      df = "hello",
      dir_path = "data"
    )
  )
})
