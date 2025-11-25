# Expand tidy dataframes to project metadata template format

Creates a JSON-like structure in the csv that can be processed using
established workflows in this package.

## Usage

``` r
expand_tidy_dfs(tidy_df, group_prefix)
```

## Arguments

- tidy_df:

  data frame. Each row corresponds to a complete entry.

- group_prefix:

  character. A repeatable metadata property in the project metadata
  section of WDDS. See
  https://viralemergence.github.io/wddsWizard/articles/schema_overview.html#project_metadata

## Value

Data frame. The data frame contains the fields Group, Variable, and
Value.

## See also

Other Project Metadata:
[`download_oa_item()`](https://viralemergence.github.io/wddsWizard/reference/download_oa_item.md),
[`extract_metadata_from_doi()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_from_doi.md),
[`extract_metadata_oa()`](https://viralemergence.github.io/wddsWizard/reference/extract_metadata_oa.md),
[`generate_metadata_csv()`](https://viralemergence.github.io/wddsWizard/reference/generate_metadata_csv.md),
[`generate_repeat_dfs()`](https://viralemergence.github.io/wddsWizard/reference/generate_repeat_dfs.md),
[`make_simple_df()`](https://viralemergence.github.io/wddsWizard/reference/make_simple_df.md)

## Examples

``` r
# a nice tidy dataset
creators_tidy <- data.frame("Name" = paste(letters[1:10],LETTERS[1:10]),
         "Given Name" = letters[1:10],
         "Family Name" = LETTERS[1:10],
         "Name Identifier" = sample(1:100,10,FALSE),
         "Affiliation" = letters[11:20],
         "Affiliation Identifier" = 11:20,
         check.names =FALSE)

# an expanded dataset that matches the template format.
creators_tidy |>
 expand_tidy_dfs(group_prefix = "Creators")
#>          Group               Variable Value
#> 1   Creators 1                   Name   a A
#> 2                          Given Name     a
#> 3                         Family Name     A
#> 4                     Name Identifier    73
#> 5                         Affiliation     k
#> 6              Affiliation Identifier    11
#> 7   Creators 2                   Name   b B
#> 8                          Given Name     b
#> 9                         Family Name     B
#> 10                    Name Identifier    69
#> 11                        Affiliation     l
#> 12             Affiliation Identifier    12
#> 13  Creators 3                   Name   c C
#> 14                         Given Name     c
#> 15                        Family Name     C
#> 16                    Name Identifier     5
#> 17                        Affiliation     m
#> 18             Affiliation Identifier    13
#> 19  Creators 4                   Name   d D
#> 20                         Given Name     d
#> 21                        Family Name     D
#> 22                    Name Identifier    24
#> 23                        Affiliation     n
#> 24             Affiliation Identifier    14
#> 25  Creators 5                   Name   e E
#> 26                         Given Name     e
#> 27                        Family Name     E
#> 28                    Name Identifier    79
#> 29                        Affiliation     o
#> 30             Affiliation Identifier    15
#> 31  Creators 6                   Name   f F
#> 32                         Given Name     f
#> 33                        Family Name     F
#> 34                    Name Identifier    77
#> 35                        Affiliation     p
#> 36             Affiliation Identifier    16
#> 37  Creators 7                   Name   g G
#> 38                         Given Name     g
#> 39                        Family Name     G
#> 40                    Name Identifier     2
#> 41                        Affiliation     q
#> 42             Affiliation Identifier    17
#> 43  Creators 8                   Name   h H
#> 44                         Given Name     h
#> 45                        Family Name     H
#> 46                    Name Identifier    62
#> 47                        Affiliation     r
#> 48             Affiliation Identifier    18
#> 49  Creators 9                   Name   i I
#> 50                         Given Name     i
#> 51                        Family Name     I
#> 52                    Name Identifier    55
#> 53                        Affiliation     s
#> 54             Affiliation Identifier    19
#> 55 Creators 10                   Name   j J
#> 56                         Given Name     j
#> 57                        Family Name     J
#> 58                    Name Identifier    43
#> 59                        Affiliation     t
#> 60             Affiliation Identifier    20


```
