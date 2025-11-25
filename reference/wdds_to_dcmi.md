# WDDS to the Dublin Core Metadata Initiative

Converts WDDS project metadata to Zenodo flavored DCMI metadata.

## Usage

``` r
wdds_to_dcmi(
  metadata_to_translate,
  translation_map = wddsWizard::wdds_to_dcmi_map
)
```

## Arguments

- metadata_to_translate:

  List. Metadata that conforms to the WDDS data standard but is not
  prepped for JSON. See `prep_from_metadata_template`

- translation_map:

  List. A list that describes how to translate from WDDS to DCMI.

## Value

List. Translated metadata with appropriate names.

## See also

Other Standards Mapping:
[`na_to_blank()`](https://viralemergence.github.io/wddsWizard/reference/na_to_blank.md),
[`translate_to_dcmi()`](https://viralemergence.github.io/wddsWizard/reference/translate_to_dcmi.md),
[`wdds_to_pharos()`](https://viralemergence.github.io/wddsWizard/reference/wdds_to_pharos.md)

## Examples

``` r
project_metadata <- wdds_example_data(version = "latest",
                                    file = "example_project_metadata.csv")|>
    read.csv()

test_pmd <- project_metadata |>
  prep_from_metadata_template(json_prep = FALSE)

test_pmd$rights$rights <- "CC0-1.0"

dcmi_metadata <- wdds_to_dcmi(metadata_to_translate = test_pmd,
                              translation_map =  wddsWizard::wdds_to_dcmi_map)

```
