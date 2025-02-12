## code to prepare `becker_project_metadata` dataset goes here

library(dplyr)
library(stringr)
library(snakecase)


project_metadata <- read.csv(here::here("inst/extdata/example_data/example_project_metadata.csv"))

## turn empty strings into NAs in the group field
project_metadata <- project_metadata |>
  dplyr::mutate(Group = dplyr::case_when(
    Group != "" ~ Group,
    TRUE ~ NA
  ))

project_metadata_filled <- tidyr::fill(data = project_metadata,Group)

# get ids for components of a group.
project_metadata_ids <- project_metadata_filled |>
  dplyr::mutate(
    entity_id = stringr::str_extract(string = Group,pattern = "[0-9]"),
    # make sure that there are no NA entity IDs
    entity_id = dplyr::case_when(
      is.na(entity_id) ~ "1",
      TRUE ~ entity_id
    )
  ) |>
  # drop entity ids from group field and convert to camel case
  dplyr::mutate(Group = stringr::str_replace_all(string = Group,pattern = " [0-9]", replacement = ""),
                Group = snakecase::to_lower_camel_case(Group))

## split dataframe by Group for further processing

project_metadata_list  <- split(project_metadata_ids,project_metadata_ids$Group)

# The `get_entity` function creates standard entities that will be easier to transform json

becker_project_metadata <- purrr::map(project_metadata_list,function(x){
  if(all(x$entity_id == "1")){
    out <- get_entity(x)
    return(out)
  }

  x_list <- split(x,x$entity_id)
  names(x_list) <- NULL
  out <-purrr::map(x_list, get_entity)
  return(out)
})


usethis::use_data(becker_project_metadata, overwrite = TRUE)
