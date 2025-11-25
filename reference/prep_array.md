# Prep array

Prep array

## Usage

``` r
prep_array(x)
```

## Arguments

- x:

  a list object.

## Value

unnamed vector

## See also

Other JSON Prep:
[`clean_field_names()`](https://viralemergence.github.io/wddsWizard/reference/clean_field_names.md),
[`get_entity()`](https://viralemergence.github.io/wddsWizard/reference/get_entity.md),
[`prep_affiliation()`](https://viralemergence.github.io/wddsWizard/reference/prep_affiliation.md),
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
[`prep_object()`](https://viralemergence.github.io/wddsWizard/reference/prep_object.md),
[`prep_publicationYear()`](https://viralemergence.github.io/wddsWizard/reference/prep_publicationYear.md),
[`prep_relatedIdentifiers()`](https://viralemergence.github.io/wddsWizard/reference/prep_relatedIdentifiers.md),
[`prep_rights()`](https://viralemergence.github.io/wddsWizard/reference/prep_rights.md),
[`prep_subjects()`](https://viralemergence.github.io/wddsWizard/reference/prep_subjects.md),
[`prep_titles()`](https://viralemergence.github.io/wddsWizard/reference/prep_titles.md)

## Examples

``` r
# this form can arise because of the csv template
nested_list <- list(list("formats" = list("formats" = "csv",
"formats" = "fasta")))

prep_array(nested_list)
#> [1] "csv"   "fasta"
```
