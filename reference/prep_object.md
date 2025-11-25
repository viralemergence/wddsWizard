# Prepare an object

Converts a named vector, list, or data frame to a list, and optionally
unboxes it, so that its recorded as an object.

## Usage

``` r
prep_object(x, unbox = FALSE)
```

## Arguments

- x:

  named vector, list, or data frame

- unbox:

  logical Should items be unboxed (not arrays)? Default is FALSE meaning
  items will remain as arrays when converted to json.

## Value

List of formatted objects

## Details

Note that unboxing will only work on items where you have 1:1 key value
pair. So if you have a dataframe with multiple rows or a list with
multiple values at a given position, it won't work.

## See also

Other JSON Prep:
[`clean_field_names()`](https://viralemergence.github.io/wddsWizard/reference/clean_field_names.md),
[`get_entity()`](https://viralemergence.github.io/wddsWizard/reference/get_entity.md),
[`prep_affiliation()`](https://viralemergence.github.io/wddsWizard/reference/prep_affiliation.md),
[`prep_array()`](https://viralemergence.github.io/wddsWizard/reference/prep_array.md),
[`prep_array_objects()`](https://viralemergence.github.io/wddsWizard/reference/prep_array_objects.md),
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
[`prep_publicationYear()`](https://viralemergence.github.io/wddsWizard/reference/prep_publicationYear.md),
[`prep_relatedIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_relatedIdentifiers.md),
[`prep_rights()`](https://viralemergence.github.io/wddsWizard/reference/prep_rights.md),
[`prep_subjects()`](https://viralemergence.github.io/wddsWizard/reference/prep_subjects.md),
[`prep_titles()`](https://viralemergence.github.io/wddsWizard/reference/prep_titles.md)

## Examples

``` r
cars_small <- datasets::cars[1:10, ]

# creates an array of objects where each
# row is an object
cars_small |>
  jsonlite::toJSON(pretty = TRUE)
#> [
#>   {
#>     "speed": 4,
#>     "dist": 2
#>   },
#>   {
#>     "speed": 4,
#>     "dist": 10
#>   },
#>   {
#>     "speed": 7,
#>     "dist": 4
#>   },
#>   {
#>     "speed": 7,
#>     "dist": 22
#>   },
#>   {
#>     "speed": 8,
#>     "dist": 16
#>   },
#>   {
#>     "speed": 9,
#>     "dist": 10
#>   },
#>   {
#>     "speed": 10,
#>     "dist": 18
#>   },
#>   {
#>     "speed": 10,
#>     "dist": 26
#>   },
#>   {
#>     "speed": 10,
#>     "dist": 34
#>   },
#>   {
#>     "speed": 11,
#>     "dist": 17
#>   }
#> ] 

# creates an object with 2 arrays
prep_object(cars_small) |>
  jsonlite::toJSON(pretty = TRUE)
#> {
#>   "speed": [4, 4, 7, 7, 8, 9, 10, 10, 10, 11],
#>   "dist": [2, 10, 4, 22, 16, 10, 18, 26, 34, 17]
#> } 

# this makes no difference
x <- list("hello" = 1:10, "world" = "Earth")

prep_object(x) |>
  jsonlite::toJSON(pretty = TRUE)
#> {
#>   "hello": [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
#>   "world": ["Earth"]
#> } 
```
