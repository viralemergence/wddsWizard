test_that("use_template works", {
  tempdir_path <- tempdir()
  expect_no_failure(use_template(
    template_file = "disease_data_template.csv",
    folder = tempdir_path,
    overwrite = TRUE
  ))
})


test_that("use_template fails if dir doesnt exist", {
  expect_error(use_template(
    template_file = "disease_data_template.csv",
    folder = "fakeFolder"
  ))
})

test_that("use_template fails if file name is not character or null", {
  tempdir_path <- tempdir()
  expect_error(use_template(
    template_file = "disease_data_template.csv",
    folder = tempdir_path,
    file_name = TRUE,
    overwrite = TRUE
  ))
})

test_that("use_template fails if file open is not logical", {
  tempdir_path <- tempdir()
  expect_error(use_template(
    template_file = "disease_data_template.csv",
    folder = tempdir_path,
    open = "hello",
    overwrite = TRUE
  ))
})

test_that("use_template fails if file overwrite is not logical", {
  tempdir_path <- tempdir()
  expect_error(use_template(
    template_file = "disease_data_template.csv",
    folder = tempdir_path,
    overwrite = NULL
  ))
})
