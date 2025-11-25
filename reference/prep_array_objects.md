# Prepare an array of objects

wraps a data frame in a list and or unboxes list items that are 1 row
dataframes. This will result in an array of objects being created.

## Usage

``` r
prep_array_objects(x, unbox = TRUE)
```

## Arguments

- x:

  list of data frames or a data frame

- unbox:

  logical. Should the things be unboxed?

## Value

list of single row unboxed data frames

## See also

Other JSON Prep:
[`clean_field_names()`](https://viralemergence.github.io/wddsWizard/reference/clean_field_names.md),
[`get_entity()`](https://viralemergence.github.io/wddsWizard/reference/get_entity.md),
[`prep_affiliation()`](https://viralemergence.github.io/wddsWizard/reference/prep_affiliation.md),
[`prep_array()`](https://viralemergence.github.io/wddsWizard/reference/prep_array.md),
[`prep_atomic()`](https://viralemergence.github.io/wddsWizard/reference/prep_atomic.md),
[`prep_creators()`](https://viralemergence.github.io/wddsWizard/reference/prep_creators.md),
[`prep_data()`](https://viralemergence.github.io/wddsWizard/reference/prep_data.md),
[`prep_descriptions()`](https://viralemergence.github.io/wddsWizard/reference/prep_descriptions.md),
[`prep_for_json()`](https://viralemergence.github.io/wddsWizard/reference/prep_for_json.md),
[`prep_from_metadata_template()`](https://viralemergence.github.io/wddsWizard/reference/prep_from_metadata_template.md),
[`prep_fundingReferences()`](https://viralemergence.github.io/wddsWizard/reference/prep_fundingReferences.md),
[`prep_identifier()`](https://viralemergence.github.io/wddsWizard/reference/prep_identifier.md),
[`prep_language()`](https://viralemergence.github.io/wddsWizard/reference/prep_language.md),
[`prep_methodology()`](https://viralemergence.github.io/wddsWizard/reference/prep_methodology.md),
[`prep_methods()`](https://viralemergence.github.io/wddsWizard/reference/prep_methods.md),
[`prep_nameIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_nameIdentifiers.md),
[`prep_object()`](https://viralemergence.github.io/wddsWizard/reference/prep_object.md),
[`prep_publicationYear()`](https://viralemergence.github.io/wddsWizard/reference/prep_publicationYear.md),
[`prep_relatedIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_relatedIdentifiers.md),
[`prep_rights()`](https://viralemergence.github.io/wddsWizard/reference/prep_rights.md),
[`prep_subjects()`](https://viralemergence.github.io/wddsWizard/reference/prep_subjects.md),
[`prep_titles()`](https://viralemergence.github.io/wddsWizard/reference/prep_titles.md)

## Examples

``` r
# note that you cannot unbox data frames with more than 1 row

x <- list(
  tibble::tibble(age = 1, group = letters[1]),
  tibble::tibble(age = 2, group = letters[2])
)

# running jsonlite::toJSON on an unmodified object results in
# extra square brackets - an array of arrays of objects
jsonlite::toJSON(x, pretty = TRUE)
#> [
#>   [
#>     {
#>       "age": 1,
#>       "group": "a"
#>     }
#>   ],
#>   [
#>     {
#>       "age": 2,
#>       "group": "b"
#>     }
#>   ]
#> ] 

# with the prepped data we get an array of objects
x_prepped <- prep_array_objects(x)

x_prepped |>
  jsonlite::toJSON(pretty = TRUE)
#> [
#>   {
#>       "age": 1,
#>       "group": "a"
#>     },
#>   {
#>       "age": 2,
#>       "group": "b"
#>     }
#> ] 
```
