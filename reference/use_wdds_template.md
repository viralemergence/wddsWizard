# Use a wildlife disease data standard template

This function allows you to easily copy and open a template from the
package.

## Usage

``` r
use_wdds_template(
  template_file = NULL,
  folder = fs::path_wd(),
  file_name = NULL,
  open = rlang::is_interactive(),
  overwrite = FALSE
)
```

## Arguments

- template_file:

  character. File name for a template. Defaults to `NULL` to return all
  template files.

- folder:

  character. Where should the template be copied to? Default is the
  current working directory.

- file_name:

  character. What should the copied file be called? Default is to use
  whatever value is supplied to template_file.

- open:

  logical. Should the file be opened? Defaults to TRUE if interactive.

- overwrite:

  logical. Should a file with the same name in the destination folder be
  overwritten? Default is FALSE to avoid accidentally overwriting data.

## Value

Character. If no template_file value is provided, lists all template
files in the package. If a file is created, it returns the file path for
that new file.

## See also

Other Templates:
[`list_wdds_templates()`](https://viralemergence.github.io/wddsWizard/reference/list_wdds_templates.md)

## Examples

``` r
# return available templates
use_wdds_template()
#> ℹ Provide a value to `template_file` to use the template
#> [1] "disease_data_template.csv"     "disease_data_template.xlsx"   
#> [3] "project_metadata_template.csv"

if (FALSE) { # \dontrun{

# makes a copy of the disease data template in the current working directory
use_wdds_template("disease_data_template.csv")
} # }
```
