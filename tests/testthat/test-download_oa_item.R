test_that("download_oa_item works", {

  doi <- "doi.org/10.1038/s41597-025-05332-x"

  expect_no_failure(
    download_oa_item(entity = "works",oa_id = doi)
  )
})

test_that("download_oa_item fails - not an entity", {

  doi <- "doi.org/10.1038/s41597-025-05332-x"

  expect_error(
    download_oa_item(entity = "articles",oa_id = doi)
  )
})

test_that("download_oa_item fails - not character", {

  doi <- 55

  expect_error(
    download_oa_item(entity = "articles",oa_id = doi)
  )
})

test_that("download_oa_item fails - not dir", {

  doi <- "doi.org/10.1038/s41597-025-05332-x"

  expect_error(
    download_oa_item(entity = "articles",oa_id = doi,dir_temp = "fake_dir")
  )
})


test_that("download_oa_item fails - not number", {

  doi <- "doi.org/10.1038/s41597-025-05332-x"

  expect_error(
    download_oa_item(entity = "articles",oa_id = doi,sleep_time = "hello")
  )
})
