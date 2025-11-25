# Prepare methods

Collection of methods for preparing data conveniently named to make
preparing easier

## Usage

``` r
prep_methods()
```

## Value

list of methods

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
[`prep_nameIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_nameIdentifiers.md),
[`prep_object()`](https://viralemergence.github.io/wddsWizard/reference/prep_object.md),
[`prep_publicationYear()`](https://viralemergence.github.io/wddsWizard/reference/prep_publicationYear.md),
[`prep_relatedIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_relatedIdentifiers.md),
[`prep_rights()`](https://viralemergence.github.io/wddsWizard/reference/prep_rights.md),
[`prep_subjects()`](https://viralemergence.github.io/wddsWizard/reference/prep_subjects.md),
[`prep_titles()`](https://viralemergence.github.io/wddsWizard/reference/prep_titles.md)

## Examples

``` r
prep_methods()
#> $data
#> function (x) 
#> {
#>     prep_object(x)
#> }
#> <bytecode: 0x55f7c23b7d48>
#> <environment: namespace:wddsWizard>
#> 
#> $creators
#> function (x) 
#> {
#>     assertthat::assert_that(is.list(x), msg = "x must be a list")
#>     x_aff <- purrr::map(x, prep_affiliation)
#>     x_nid <- purrr::map(x_aff, prep_nameIdentifiers)
#>     out <- prep_array_objects(x_nid)
#>     return(out)
#> }
#> <bytecode: 0x55f7c4e3bee8>
#> <environment: namespace:wddsWizard>
#> 
#> $descriptions
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c28685f8>
#> <environment: namespace:wddsWizard>
#> 
#> $fundingReferences
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c23b7530>
#> <environment: namespace:wddsWizard>
#> 
#> $identifier
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c23b6d88>
#> <environment: namespace:wddsWizard>
#> 
#> $relatedIdentifiers
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c20bdd70>
#> <environment: namespace:wddsWizard>
#> 
#> $language
#> function (x) 
#> {
#>     prep_atomic(x)
#> }
#> <bytecode: 0x55f7c20bd5c8>
#> <environment: namespace:wddsWizard>
#> 
#> $methodology
#> function (x) 
#> {
#>     assertthat::assert_that(is.list(x), msg = "x must be a list")
#>     check_for_names <- c("eventBased", "archival") %in% names(x)
#>     assertthat::assert_that(all(check_for_names), msg = "x must have items `eventBased` and `archival`")
#>     x <- dplyr::mutate(x, eventBased = as.logical(.data$eventBased), 
#>         archival = as.logical(.data$archival))
#>     prep_object(x, unbox = TRUE)
#> }
#> <bytecode: 0x55f7c20bce20>
#> <environment: namespace:wddsWizard>
#> 
#> $publicationYear
#> function (x) 
#> {
#>     prep_atomic(x)
#> }
#> <bytecode: 0x55f7c20bf5c8>
#> <environment: namespace:wddsWizard>
#> 
#> $rights
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c20bee20>
#> <environment: namespace:wddsWizard>
#> 
#> $subjects
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c20be678>
#> <environment: namespace:wddsWizard>
#> 
#> $titles
#> function (x) 
#> {
#>     prep_array_objects(x)
#> }
#> <bytecode: 0x55f7c408da90>
#> <environment: namespace:wddsWizard>
#> 
```
