# Paste Reduce

A paste function that can be used with
[`purrr::reduce`](https://purrr.tidyverse.org/reference/reduce.html) to
build up nested documentation items

## Usage

``` r
paste_reduce(x, y, sep = "\n")
```

## Arguments

- x:

  Character

- y:

  Character

- sep:

  Character. Default is a line break `"\n"`

## Value

Character

## See also

Other Schema Docs:
[`create_object_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_object_docs.md),
[`create_schema_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_schema_docs.md),
[`get_ref()`](https://viralemergence.github.io/wddsWizard/reference/get_ref.md),
[`get_required_fields()`](https://viralemergence.github.io/wddsWizard/reference/get_required_fields.md),
[`increase_docs_depth()`](https://viralemergence.github.io/wddsWizard/reference/increase_docs_depth.md),
[`paste_reduce_ul()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce_ul.md)

## Examples

``` r
text_a <- "hello"
text_b <- "world"
paste_reduce(text_a, text_b)
#> [1] "hello\nworld"
```
