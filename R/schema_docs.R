# "Want to recursively move through  a list in order to create a markdown document
#
# should start at a node in level 1, then transverse that whole path, creating
# a nested markdown text string.
# "
#
# "starting at some leaf x, work backwards through the tree until you cannot."
#
#
#
# purrr::accumulate(schema_list,.f = collapse_section, .dir = "backward")
#
# nested_list <- list("a" = list("b" = list(d = "end")))
#
# nested_list |>purrr::accumulate(schema_list,.f = collapse_section, .dir = "backward")
#
# format_title <- function(schema_list){
#   sprintf("## %s",schema_list$title)
# }
#
# format_description <- function(schema_list){
#   sprtinf("Description: %s",schema_list$description)
# }
#
# format_property <- function(schema_list){
#   schema_list$properties$data$description
#   schema_list$properties$data$type
#   schema_list$properties$data$properties
#   schema_list$properties$data$properties
# }
#
#
# collapse_section <- function(out,details){
#
#   if(is.list(details)){
#     current <- purrr::reduce(details,collapse_section)
#   } else {
#     current = details
#   }
#
#   out <- paste("<details><summary>",out, "</summary> *",current,"</details>",collapse = "")
#   return(out)
# }
#
# debugonce(collapse_section)
# collapse_section(out = x, details = x$data)
#
# x <- list("data" = list( "some"))
#
# x |> purrr::accumulate(.f = collapse_section,.dir = "backward")
#
# letters[1:3]|> purrr::reduce(.f = collapse_section)
#
# wdds_schema$properties$data$properties$sampleID$items$type
