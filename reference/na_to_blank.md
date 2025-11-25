# Convert NA's to blanks

Converts all columns to character then converts all NA's to blanks.

## Usage

``` r
na_to_blank(df)
```

## Arguments

- df:

  data frame. A data frame where NAs should be coverted to blanks.
  Cannot be a tibble with nested columns.

## Value

data frame. All columns will be character and all NA's will be replaced
with "".

## See also

Other Standards Mapping:
[`translate_to_dcmi()`](https://viralemergence.github.io/wddsWizard/reference/translate_to_dcmi.md),
[`wdds_to_dcmi()`](https://viralemergence.github.io/wddsWizard/reference/wdds_to_dcmi.md),
[`wdds_to_pharos()`](https://viralemergence.github.io/wddsWizard/reference/wdds_to_pharos.md)

## Examples

``` r
data.frame(a = 1:10, b = c(1:9,NA)) |>
  na_to_blank()
#> # A tibble: 10 × 2
#>    a     b    
#>    <chr> <chr>
#>  1 1     "1"  
#>  2 2     "2"  
#>  3 3     "3"  
#>  4 4     "4"  
#>  5 5     "5"  
#>  6 6     "6"  
#>  7 7     "7"  
#>  8 8     "8"  
#>  9 9     "9"  
#> 10 10    ""   
```
