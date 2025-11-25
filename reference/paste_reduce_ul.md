# Paste Reduce unordered list item

A paste function that can be used with
[`purrr::reduce`](https://purrr.tidyverse.org/reference/reduce.html) to
build up nested documentation items

## Usage

``` r
paste_reduce_ul(x, y, sep = "\n - ")
```

## Arguments

- x:

  Character

- y:

  Character

- sep:

  Character. Default is a line break followed by a dash `"\n - "` to
  create an unordered list in markdown.

## Value

Character

## See also

Other Schema Docs:
[`create_object_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_object_docs.md),
[`create_schema_docs()`](https://viralemergence.github.io/wddsWizard/reference/create_schema_docs.md),
[`get_ref()`](https://viralemergence.github.io/wddsWizard/reference/get_ref.md),
[`get_required_fields()`](https://viralemergence.github.io/wddsWizard/reference/get_required_fields.md),
[`increase_docs_depth()`](https://viralemergence.github.io/wddsWizard/reference/increase_docs_depth.md),
[`paste_reduce()`](https://viralemergence.github.io/wddsWizard/reference/paste_reduce.md)

## Examples

``` r
text_a <- "hello"
text_b <- "world"
paste_reduce_ul(text_a, text_b)
#> [1] "hello\n - world"
```
