# Provides Access to Versioned Example Data Files

Since schema versions may change during the life cycle of project, it is
important that users have access to all schema versions via this
package. This function allows you to quickly retrieve whichever version
of the example data you may need.

## Usage

``` r
wdds_example_data(version = NULL, file = NULL)
```

## Arguments

- version:

  Character or NULL. Version of the wdds deposit. Leave as NULL to see
  all versions. Default is NULL to return a character vector of
  versions.

- file:

  Character or NULL. Specific file from the wdds deposit. Leave as NULL
  to see all files in a version. Default is NULL to return all files
  associated with a given version.

## Value

Character. Either version identifiers or file paths.

## Details

This function does three things.

1.  Shows all versions of the schema in the package if version is NULL.

2.  Provides paths to all example data files associated with a version
    of the schema if version is provided and file is NULL.

3.  Provides a specific file path in a specific version of the example
    data if both file and version are provided.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
# see which versions are in the package

wdds_example_data()
#> The following versions of the standard are availble in the package:
#>         -  latest
#>         -  v_1_0_0
#>         -  v_1_0_1
#>         -  v_1_0_2
#>         -  v_1_0_3
#>         -  v_1_0_4
#> [1] "latest"  "v_1_0_0" "v_1_0_1" "v_1_0_2" "v_1_0_3" "v_1_0_4"

# see files associated with a version

wdds_example_data(version = "latest")
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/Becker_demo_dataset.xlsx
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/becker_demo_dataset.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/becker_project_metadata.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/example_project_metadata.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/minimal_example.json
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/minimal_example_disease_data.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/minimal_example_project_metadata.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/my_interesting_disease_data.csv
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/example_data/my_project_metadata.csv

# get the file path for a specific file

wdds_example_data(version = "v_1_0_2", file = "Becker_demo_dataset.xlsx")
#> [1] "/home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/v_1_0_2/example_data/Becker_demo_dataset.xlsx"
```
