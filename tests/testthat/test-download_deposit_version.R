test_that("download_deposit_version works", {
  skip_if_offline()
  tempdir_path <- tempdir()
  expect_no_failure(
    download_deposit_version(
      zenodo_id = "15270582",
      version = "v.1.0.3",
      latest_version = TRUE,
      dir_path = tempdir_path
    )
  )
})

test_that("download_deposit_version fails with non character", {
  tempdir_path <- tempdir()

  expect_error(
    download_deposit_version(
      zenodo_id = 1,
      version = "v1.0.1",
      latest_version = TRUE,
      dir_path = tempdir_path
    )
  )

  expect_error(
    download_deposit_version(
      zenodo_id = "15270582",
      version = 2,
      latest_version = TRUE,
      dir_path = tempdir_path
    )
  )
})


test_that("download_deposit_version fails with non logical", {
  tempdir_path <- tempdir()

  expect_error(
    download_deposit_version(
      zenodo_id = "15270582",
      version = "v.1.0.1",
      latest_version = 0,
      dir_path = tempdir_path
    )
  )
})


test_that("download_deposit_version fails with non scalar", {
  expect_error(
    download_deposit_version(
      zenodo_id = "15270582",
      version = "v.1.0.1",
      latest_version = FALSE,
      dir_path = c("test_dir.json", "hello", "data")
    )
  )
})
