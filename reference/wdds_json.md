# Provides Access to Versioned Schema Files

Since schema versions may change during the life cycle of project, it is
important that users have access to all schema versions via this
package. This function allows you to quickly retrieve whichever schema
version you may need.

## Usage

``` r
wdds_json(version = NULL, file = NULL)
```

## Arguments

- version:

  Character or NULL. Version of the wdds deposit. Leave as NULL to see
  all versions. Default is NULL to return character vector of versions.

- file:

  Character or NULL. Specific file from the wdds deposit. Leave as NULL
  to see all files in a version. Default is NULL to return character
  vector of relative file paths.

## Value

Character. Either version identifiers, relative file paths within a
version, or a specific file path.

## Details

This function does three things:

1.  Shows all versions of the schema in the package if both version and
    file are NULL.

2.  Provides relative paths to all schema files associated with a
    version of the schema if only version is provided.

3.  Provides a specific file path in a specific version of the schema if
    version and file path are provided.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`list_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/list_deposit_versions.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md)

## Examples

``` r
# see which versions are in the package

wdds_json()
#> The following versions of the standard are availble in the package:
#>         -  latest
#>         -  v_1_0_0
#>         -  v_1_0_1
#>         -  v_1_0_2
#>         -  v_1_0_3
#>         -  v_1_0_4
#> [1] "latest"  "v_1_0_0" "v_1_0_1" "v_1_0_2" "v_1_0_3" "v_1_0_4"

# see files associated with a version

wdds_json(version = "latest")
#> /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/wdds_schema/schemas/datacite/datacite-v4.5.json 
#>                                                                                  "schemas/datacite/datacite-v4.5.json" 
#>           /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/wdds_schema/schemas/disease_data.json 
#>                                                                                            "schemas/disease_data.json" 
#>       /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/wdds_schema/schemas/project_metadata.json 
#>                                                                                        "schemas/project_metadata.json" 
#>                    /home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/latest/wdds_schema/wdds_schema.json 
#>                                                                                                     "wdds_schema.json" 

# get the file path for a specific file

wdds_json(version = "v_1_0_2", file = "schemas/disease_data.json")
#> [1] "/home/runner/work/_temp/Library/wddsWizard/extdata/wdds_archive/v_1_0_2/wdds_schema/schemas/disease_data.json"
```
