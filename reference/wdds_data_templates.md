# Provides Access to Versioned Data Template Files

Since schema versions may change during the life cycle of project, it is
important that users have access to all schema versions via this
package. This function allows you to quickly retrieve whichever version
of the data templates you may need.

## Usage

``` r
wdds_data_templates(version = NULL, file = NULL)
```

## Arguments

- version:

  Character. Version of the wdds deposit. Leave as NULL to see all
  versions.

- file:

  Character. Specific file from the wdds deposit. Leave as NULL to see
  all files in a version.

## Value

Character. Either version identifiers or file paths.

## Details

This function does three things.

1.  Shows all versions of the schema in the package if version is `NULL`

2.  Provides paths to all example data files associated with a version
    of the schema if version is not `NULL` and file is `NULL`

3.  Provides a specific file path in a specific version of the example
    data if both version and file are specified.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
# see which versions are in the package

wdds_data_templates()
#> The following versions of the standard are availble in the package:
#>         -  latest
#>         -  v_1_0_0
#>         -  v_1_0_1
#>         -  v_1_0_2
#>         -  v_1_0_3
#>         -  v_1_0_4
#> [1] "latest"  "v_1_0_0" "v_1_0_1" "v_1_0_2" "v_1_0_3" "v_1_0_4"

# see files associated with a version

wdds_data_templates(version = "latest")
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/data_templates/disease_data_template.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/data_templates/disease_data_template.xlsx
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/data_templates/project_metadata_template.csv

# get the file path for a specific file

wdds_data_templates(version = "v_1_0_2", file = "disease_data_template.csv")
#> [1] "/home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/v_1_0_2/data_templates/disease_data_template.csv"
```
