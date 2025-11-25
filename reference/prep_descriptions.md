# Prepare descriptions

Wrapper for `prep_array_objects`.

## Usage

``` r
prep_descriptions(x)
```

## Arguments

- x:

  Data frame/Tibble containing description items

## Value

List with x marked as unbox (do not make an array)

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
x <- wddsWizard::becker_project_metadata$descriptions

prep_descriptions(x) |> jsonlite::toJSON()
#> [{"description":"Bats can harbor many pathogens without showing disease. However, the mechanisms by which bats resolve these infections or limit pathology remain unclear. To illuminate the bat immune response to coronaviruses, viruses with high public health significance, we will use serum proteomics to assess broad differences in immune proteins of uninfected and infected vampire bats (Desmodus rotundus). In contrast to global profiling techniques of blood such as transcriptomics, proteomics provides a unique perspective into immunology, as the serum proteome includes proteins from not only blood but also those secreted from proximal tissues. Here, we expand our recent work on the serum proteome of wild vampire bats (Desmodus rotundus) to better understand CoV pathogenesis. Across 19 bats sampled in 2019 in northern Belize with available sera, we detected CoVs in oral or rectal swabs from four individuals. We used data independent acquisition-based mass spectrometry to profile and compare the undepleted serum proteome of these 19 bats. These results will provide much needed insight into changes in the bat serum proteome in response to coronavirus infection.","descriptionType":"Abstract"}] 
```
