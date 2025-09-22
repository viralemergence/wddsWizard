test_that("extract_metadata_from_doi works", {
  doi <-"doi.org/10.1038/s41597-025-05332-x"
  expect_no_failure(extract_metadata_from_doi(doi = doi,write_output=FALSE))
})

test_that("extract_metadata_from_doi fails", {

  doi <-"doi.org/10.1038/s41597-025-05332-x"
  expect_error(extract_metadata_from_doi(doi = doi,write_output=c(TRUE,FALSE)))

  expect_error(extract_metadata_from_doi(doi = c(doi,doi),write_output=FALSE))

  expect_error(extract_metadata_from_doi(doi = doi,
                                         file_path = c("test.csv","test.csv"),
                                         write_output=TRUE))

  })


