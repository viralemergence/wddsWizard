test_that("function works", {
  expect_snapshot(generate_metadata_csv(file_path = "test.csv",
                                        event_based = TRUE,
                                        archival = FALSE,
                                        num_creators = 10,
                                        num_titles = 1,
                                        identifier = "https://doi.org/10.1080/example.doi",
                                        identifier_type = "doi",
                                        num_subjects = 5,
                                        publication_year = "2025",
                                        rights = "cc-by",
                                        language = "en",
                                        num_descriptions = 1,
                                        num_fundingReferences = 4,
                                        num_related_identifiers= 5,
                                        write_output = FALSE))

})

test_that("fails when file path is invalid", {
  expect_error(generate_metadata_csv(file_path = "test.xls",
                                     event_based = TRUE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when event_based is not logical", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = 100,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when archival is not logical", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = "hello",
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when num_creators is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 1:10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when num_creators is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10.001,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_titles is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1:10,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_titles is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1.10,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when identifier is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = c("https://doi.org/10.1080/example.doi","https://doi.org/10.1080/example.doi"),
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when identifier is not character", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = 42,
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when identifier_type is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = rep("doi",2),
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when identifier_type is not string", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = 2,
                                     num_subjects = 5,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_subjects is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = rep(5,3),
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_subjects is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5.3,
                                     publication_year = "2025",
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when publication_year is not character", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = 2025,
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})



test_that("fails when publication_year is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when rights is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = rep("cc-by",3),
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when rights is not string", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = 3,
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})


test_that("fails when language is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = rep("en",3),
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when language is not string", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = 3,
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_descriptions is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1.5,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})

test_that("fails when num_descriptions is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1:5,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5))
})



test_that("fails when num_fundingReferences is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4:10,
                                     num_related_identifiers= 5))
})

test_that("fails when num_fundingReferences is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4.10,
                                     num_related_identifiers= 5))
})


test_that("fails when num_fundingReferences is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4:10,
                                     num_related_identifiers= 5))
})



test_that("fails when num_related_identifiers is not scalar", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5:9))
})



test_that("fails when num_related_identifiers is not integer", {
  expect_error(generate_metadata_csv(file_path = "test.csv",
                                     event_based = FALSE,
                                     archival = FALSE,
                                     num_creators = 10,
                                     num_titles = 1,
                                     identifier = "https://doi.org/10.1080/example.doi",
                                     identifier_type = "doi",
                                     num_subjects = 5,
                                     publication_year = rep("2025",3),
                                     rights = "cc-by",
                                     language = "en",
                                     num_descriptions = 1,
                                     num_fundingReferences = 4,
                                     num_related_identifiers= 5.9))
})
