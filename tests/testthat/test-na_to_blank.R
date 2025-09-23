test_that("na_to_blank works", {

  df <- data.frame(hello = 1:3,world = c("a","b",NA))

  expect_no_failure(
    na_to_blank(df)
  )

  df_no_blanks <- data.frame(hello = 1:3,world = c("a","b","d"))

  expect_no_failure(
    na_to_blank(df_no_blanks)
  )

})


test_that("na_to_blank fails", {

  vec_with_na <-  c("a","b",NA)

  expect_error(
    na_to_blank(vec_with_na)
  )

})
