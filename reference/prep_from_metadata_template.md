# Prepare metadata created from the metadata template for conversion to JSON

A convenience function for those who used the metadata template to
create their project metadata data.

## Usage

``` r
prep_from_metadata_template(
  project_metadata,
  prep_methods_list = prep_methods(),
  schema_properties = wddsWizard::schema_properties,
  json_prep = TRUE
)
```

## Arguments

- project_metadata:

  Data frame. Should correspond to the structure of the
  project_metadata_template.csv

- prep_methods_list:

  list. Named list of methods where each items is a function to applied
  to corresponding items in x.Default is
  [`prep_methods()`](https://viralemergence.github.io/wddsWizard/reference/prep_methods.md).

- schema_properties:

  Data frame. A data frame of schema properties and their types.

- json_prep:

  Logical. Should the metadata be prepped for JSON?

## Value

Named list ready to be converted to json

## Details

Does some light data formatting to make conversion to json easier.

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
if (FALSE) { # \dontrun{
# create
wddsWizard::use_template("project_metadata_template.csv",
  folder = "data",
  file_name = "my_project_metadata.csv"
)
project_metadata <- read.csv("data/my_project_metadata.csv")

prepped_project_metadata <- wddsWizard::prep_from_metadata_template(project_metadata)

project_metadat_json <- jsonlite::toJSON(prepped_project_metadata, pretty = TRUE)
} # }
```
