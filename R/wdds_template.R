#' File paths for wdds templates
#'
#' Displays file paths for Wildlife Disease Data Standard templates
#'
#'  If path is null, displays all files in the templates folder.
#'
#' @param template_file character. file name for a template. Default is `NULL`
#' to return template files
#' @family Templates
#' @returns file paths or, if path = NULL, a list of file names
#'
wdds_template <- function(template_file = NULL) {
  assertthat::assert_that(is.null(template_file) | is.character(template_file), msg = "template_file must be null or character.")

  if (is.null(template_file)) {
    cli::cli_alert_info("Provide a value to `template_file` to use the template")
    dir(system.file("extdata/data_templates", package = "wddsWizard"))
  } else {
    system.file("extdata/data_templates", template_file, package = "wddsWizard", mustWork = TRUE)
  }
}

#' Use a wildlife disease data standard template
#'
#' This function allows you to easily copy and open a template from the package.
#'
#' @param template_file character. File name for a template. Defaults to `NULL` to return all template files.
#' @param folder character. Where should the template be copied to? Default is the current working directory.
#' @param file_name character. What should the copied file be called? Default is to use whatever value is supplied to template_file.
#' @param open logical. Should the file be opened? Defaults to TRUE if interactive.
#' @param overwrite logical. Should a file with the same name in the destination folder be overwritten? Default is FALSE to avoid accidentally overwriting data.
#'
#' @returns Character. If no template_file value is provided, lists all template files in the package. If a file is created, it returns the file path for that new file.
#' @export
#' @family Templates
#' @examples
#'
#' # return available templates
#' use_template()
#'
#' \dontrun{
#'
#' # makes a copy of the disease data template in the current working directory
#' use_template("disease_data_template.csv")
#' }
#'
use_template <- function(template_file = NULL, folder = fs::path_wd(), file_name = NULL, open = rlang::is_interactive(), overwrite = FALSE) {
  template_path <- wdds_template(template_file)

  # give me the file names
  if (length(template_path) > 1) {
    return(template_path)
  }

  assertthat::assert_that(fs::is_dir(folder), msg = "folder must be a directory that exists")
  assertthat::assert_that(is.null(file_name) | is.character(file_name), msg = "file_name must be null or character.")
  assertthat::assert_that(is.logical(open), msg = "open must be logical")
  assertthat::assert_that(is.logical(overwrite), msg = "overwrite must be logical")



  # if the folder doesnt exist, make it
  if (!fs::dir_exists(folder)) {
    msg <- sprintf("creating folder %s", folder)
    cli::cli_alert_info(msg)
    fs::dir_create(path = folder, recurse = TRUE)
  }

  # use template name if no file given
  if (is.null(file_name)) {
    file_name <- fs::path_file(template_path)
    msg <- sprintf("creating file called %s", file_name)
    cli::cli_alert_info(msg)
  }

  new_file <- fs::path(folder, file_name)

  # path is not null
  fs::file_copy(template_path, new_file, overwrite = overwrite)

  if (open) {
    cmd <- sprintf("open %s", new_file)
    system(cmd)
  }

  return(new_file)
}
