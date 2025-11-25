# Project Metadata

The Wildlife Disease Data Standard is composed of two components -
disease data and project metadata. Project metadata is a key component
of WDDS because it makes it easier for others (including your future
self) to find and re-use your data.

In this vignette we will ingest project metadata from a CSV, restructure
the data, and then create a json object.

``` r
library(wddsWizard)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(stringr)
```

### Required fields

The following fields are required to be in the data.

| Field             | Descriptions                                                                                                                                                                        |
|:------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| methodology       | A broad categorization of how data were collected.                                                                                                                                  |
| creators          | The full names of the creators. Should be in the format familyName, givenName.                                                                                                      |
| titles            | A name or title by which a resource is known.                                                                                                                                       |
| publicationYear   | The year when the data was or will be made publicly available.                                                                                                                      |
| language          | The primary language of the resource.                                                                                                                                               |
| descriptions      | All additional information that does not fit in any of the other categories. May be used for technical information or detailed information associated with a scientific instrument. |
| fundingReferences | Name and other identifying information of a funding provider.                                                                                                                       |

### Load in the CSV and clean it up

Our example data requires some light cleaning to make transforming it
into csv easier.

``` r
project_metadata <- wdds_example_data(version = "latest", file = "example_project_metadata.csv") |> read.csv()

## turn empty strings into NAs in the group field
project_metadata <- project_metadata |>
  dplyr::mutate(Group = dplyr::case_when(
    Group != "" ~ Group,
    TRUE ~ NA
  ))

## use `fill` to complete the items column and `mutate` to make groups a little
## more ergonomic

project_metadata_filled <- tidyr::fill(data = project_metadata, Group)
```

### Restructure data

The validation schema is expecting JSON, so we have to restructure the
data into a list that can be converted to JSON.

For Creators, Resources, and Funding References, its possible to have
multiple entities in each group. In our example data, there are two
creators and three funding references. So we need to pull out the
`entity_id`s for the creators and funding references then clean up the
`Group` field so it can be used a general category for Creators,
Resources, and Funding References.

``` r
# get ids for components of a group.
project_metadata_ids <- project_metadata_filled |>
  dplyr::mutate(
    entity_id = stringr::str_extract(string = Group, pattern = "[0-9]{1,}"),
    # make sure that there are no NA entity IDs
    entity_id = dplyr::case_when(
      is.na(entity_id) ~ "1",
      TRUE ~ entity_id
    )
  ) |>
  # drop entity ids from group field and convert to camel case
  dplyr::mutate(
    Group = stringr::str_replace_all(string = Group, pattern = " [0-9]{1,}", replacement = ""),
    Group = snakecase::to_lower_camel_case(Group)
  )

## split dataframe by Group for further processing

project_metadata_list <- split(project_metadata_ids, project_metadata_ids$Group)


# The `get_entity` function creates standard entities that will be easier to transform json

project_metadata_list_entities <- purrr::map(project_metadata_list, function(x) {
  
  x_typed <- dplyr::left_join(x, wddsWizard::schema_properties, by = c("Group" = "name")) |>
        dplyr::mutate(to_split = dplyr::case_when(
          is_array ~ TRUE,
          TRUE ~ FALSE
        ))

      if (all(!x_typed$to_split)) {
        out <- get_entity(x)
        return(out)
      }
  # 
  # if (all(x$entity_id == "1")) {
  #   out <- get_entity(x)
  #   return(out)
  # }

  x_list <- split(x, x$entity_id)
  names(x_list) <- NULL
  out <- purrr::map(x_list, get_entity)
  return(out)
})
#> Warning in dplyr::left_join(x, wddsWizard::schema_properties, by = c(Group = "name")): Detected an unexpected many-to-many relationship between `x` and `y`.
#> ℹ Row 1 of `x` matches multiple rows in `y`.
#> ℹ Row 51 of `y` matches multiple rows in `x`.
#> ℹ If a many-to-many relationship is expected, set `relationship =
#>   "many-to-many"` to silence this warning.
```

### Make the json!

In a simpler world - you could just run the following code and it would
work.

``` r
## if only, if only the mockingbird sings
jsonlite::toJSON(project_metadata_list_entities, pretty = TRUE, dataframe = "columns")
```

BUT because datacite’s structures are more complex, we need to do some
prep. Luckily, there are a host of prep functions that already exist in
this package! These mostly tag list items with
[`jsonlite::unbox`](https://jeroen.r-universe.dev/jsonlite/reference/unbox.html)
and/or wrap things in lists so that when converted to json, they match
the data standard’s expected formats.

``` r
project_metadata_json <- prep_for_json(project_metadata_list_entities) |>
  jsonlite::toJSON(pretty = TRUE)
```

### Validate Project metadata

We can validate the entire project metadata object by using the
`project_metadata.json` schema.

``` r
schema <- wdds_json(version = "latest", file = "schemas/project_metadata.json")

project_validator <- jsonvalidate::json_validator(schema, engine = "ajv")

project_validation <- project_validator(project_metadata_json, verbose = TRUE)

## check for errors!

errors <- attributes(project_validation)

if (!project_validation) {
  errors$errors
} else {
  print("Valid project metadata!😁")
}
#> [1] "Valid project metadata!😁"
```

## What if we just use the project metadata template?

Great question!

If you use the project metadata template, then you can do the following.

``` r
project_metadata <- wdds_example_data(version = "latest", file = "example_project_metadata.csv") |> read.csv()

project_metadata_prepped <- prep_from_metadata_template(project_metadata) |>
  jsonlite::toJSON(pretty = TRUE)
```
