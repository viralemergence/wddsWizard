test_that("extract_metadata_oa works", {

  doi <- "doi.org/10.1038/s41597-025-05332-x"

  expect_no_failure(extract_metadata_oa(doi = doi))
})



test_that("extract_metadata_oa fails bad doi", {

  doi <- "fake.doi"

  expect_error(extract_metadata_oa(doi = doi))
})

test_that("extract_metadata_oa fails numeric", {

  doi <- 123

  expect_error(extract_metadata_oa(doi = doi))
})
