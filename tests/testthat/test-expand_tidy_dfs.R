test_that("expand_tidy_dfs works", {

  creators_tidy <- data.frame("Name" = paste(letters[1:10],LETTERS[1:10]),
                              "Given Name" = letters[1:10],
                              "Family Name" = LETTERS[1:10],
                              "Name Identifier" = sample(1:100,10,FALSE),
                              "Affiliation" = letters[11:20],
                              "Affiliation Identifier" = 11:20,
                              check.names =FALSE)


  expect_no_failure(expand_tidy_dfs(creators_tidy, group_prefix = "Creators"))
})


test_that("expand_tidy_dfs fails", {

  creators_tidy <- data.frame("Name" = paste(letters[1:10],LETTERS[1:10]),
                              "Given Name" = letters[1:10],
                              "Family Name" = LETTERS[1:10],
                              "Name Identifier" = sample(1:100,10,FALSE),
                              "Affiliation" = letters[11:20],
                              "Affiliation Identifier" = 11:20,
                              check.names =FALSE)


  expect_error(expand_tidy_dfs(creators_tidy,group_prefix = 1:10))

})
