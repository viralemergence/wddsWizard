# Convert WDDS disease data to PHAROS data

As of 11 September 2025, WDDS and the PHAROS data model are not fully
aligned. This function converts data that conforms to WDDS into the
PHAROS data model. See `wdds_to_pharos_map` for the data model
crosswalk.

## Usage

``` r
wdds_to_pharos(wdds_disease_data)
```

## Arguments

- wdds_disease_data:

  Data frame. A Disease Data set that conforms to the wdds data
  standard.

## Value

Data frame. A tabular data set that conforms to the PHAROS data model.

## See also

Other Standards Mapping:
[`na_to_blank()`](https://viralemergence.github.io/wddsWizard/reference/na_to_blank.md),
[`translate_to_dcmi()`](https://viralemergence.github.io/wddsWizard/reference/translate_to_dcmi.md),
[`wdds_to_dcmi()`](https://viralemergence.github.io/wddsWizard/reference/wdds_to_dcmi.md)

## Examples

``` r
wdds_to_pharos(wdds_disease_data = wddsWizard::minimal_disease_data)
#> `sampleCollectionMethod` does not map perfectly to `Collection method or tissue`. Please review those entries.
#> # A tibble: 3 × 13
#>   `Animal ID` `Collection day` `Collection month` `Collection year`
#>   <chr>       <chr>            <chr>              <chr>            
#> 1 d           1                12                 1                
#> 2 e           1                10                 2024             
#> 3 f           1                1                  2025             
#> # ℹ 9 more variables: `Detection method` <chr>, `Detection outcome` <chr>,
#> #   `Detection target` <chr>, `Host species` <chr>, Latitude <chr>,
#> #   Longitude <chr>, Pathogen <chr>, `Collection method or tissue` <chr>,
#> #   `Sample ID` <chr>

# data must be written to CSV then uploaded to PHAROS
```
