test_that("create_schema_docs works", {
  file_path <- wdds_json(version = "latest",file = "wdds_schema.json")
  expect_no_failure(create_schema_docs(schema_path = file_path))
})

test_that("create_schema_docs fails with non character", {
  expect_error(create_schema_docs(schema_path = 1))
})

test_that("create_schema_docs fails with fake file", {
  expect_error(create_schema_docs(schema_path = "fake.file"))
})
