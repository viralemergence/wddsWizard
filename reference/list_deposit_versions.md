# List Versions of a deposit on Zenodo

This function list all the versions of a deposit associated with a
parent id. The parent id is used to identify a set of works that are
different versions of the same work. The parent id is provided from the
Zenodo API. If you download a JSON representation of the deposit (export
to json), there will be an attribute in that json called parent that
looks like "https://zenodo.org/api/records/15020049". The 8 digit string
at the end of the url is the parent id.

## Usage

``` r
list_deposit_versions(parent_id = "15020049")
```

## Arguments

- parent_id:

  String. Identifier for a Zenodo deposit with multiple versions.
  Default is the parent id for the wdds zenodo deposit.

## Value

Data frame. The data frame contains the Zenodo id for each version of
the deposit, as well as the version name, and logical field called
latest that indicates if this is the latest version.

## See also

Other WDDS deposit:
[`batch_download_deposit_versions()`](https://viralemergence.github.io/wddsWizard/reference/batch_download_deposit_versions.md),
[`download_deposit_version()`](https://viralemergence.github.io/wddsWizard/reference/download_deposit_version.md),
[`sanitize_version()`](https://viralemergence.github.io/wddsWizard/reference/sanitize_version.md),
[`set_wdds_version()`](https://viralemergence.github.io/wddsWizard/reference/set_wdds_version.md),
[`wdds_data_templates()`](https://viralemergence.github.io/wddsWizard/reference/wdds_data_templates.md),
[`wdds_example_data()`](https://viralemergence.github.io/wddsWizard/reference/wdds_example_data.md),
[`wdds_json()`](https://viralemergence.github.io/wddsWizard/reference/wdds_json.md)

## Examples

``` r
list_deposit_versions()
#>   zenodo_id version latest_version
#> 1  17717011 v.1.0.5           TRUE
#> 2  17095076 v.1.0.4          FALSE
#> 3  15270582 v.1.0.3          FALSE
#> 4  15257971 v.1.0.2          FALSE
#> 5  15133410 v.1.0.1          FALSE
#> 6  15020050 v.1.0.0          FALSE
```
