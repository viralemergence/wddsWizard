# Prepare funding references

creates an array of objects

## Usage

``` r
prep_fundingReferences(x)
```

## Arguments

- x:

  list of tibbles/data frames or a tibble/data frame

## Value

list of single row unboxed data frames

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
wddsWizard::becker_project_metadata$fundingReferences |>
  prep_fundingReferences()
#> [[1]]
#>                      funderName                     funderIdentifier
#> [x] National Geographic Society http://dx.doi.org/10.13039/100006733
#>       awardNumber
#> [x] NGS-55503R-19
#> 
#> [[2]]
#>             funderName                     funderIdentifier
#> [x] Indiana University http://dx.doi.org/10.13039/100006733
#> 
#> [[3]]
#>                funderName                     funderIdentifier
#> [x] College of Charleston http://dx.doi.org/10.13039/100009789
#> 
```
