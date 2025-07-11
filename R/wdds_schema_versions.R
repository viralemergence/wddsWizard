### list all versions of the schema on zenodo

# https://zenodo.org/api/records/15257971/versions



### change to wdds_list_versions

#' List Versions of a deposit on Zenodo
#'
#' This function list all the versions of a deposit associated with a parent id.
#' The parent id is used to identify a set of works that are different versions
#' of the same work. The parent id is provided from the Zenodo API. If you
#' download a JSON representation of the deposit (export to json), there
#' will be an attribute in that json called parent that looks like
#' "https://zenodo.org/api/records/15020049". The 8 digit string at the end of
#' the url is the parent id.
#'
#'
#' @param parent_id String. Identifier for a Zenodo deposit with multiple versions.
#' Default is the parent id for the wdds zenodo deposit.
#'
#' @returns Data frame. The data frame contains the Zenodo id for each version of
#' the deposit, as well as the version name, and logical field called latest that
#' indicates if this is the latest version.
#'
#' @export
#'
#' @examplesIf curl::has_internet()
#'
#' list_deposit_versions()
#'
#'
#'
#'
list_deposit_versions <- function(parent_id = "15020049"){
  parent_url <- sprintf("https://zenodo.org/api/records/%s",parent_id)

  parent_json <- jsonlite::fromJSON(txt = parent_url)

  latest_id <- as.character(parent_json$id)

  versions_json <- jsonlite::fromJSON(parent_json$links$versions)

  zenodo_id <- as.character(versions_json$hits$hits$id)
  version_tag <- versions_json$hits$hits$metadata$version

  out <- data.frame(zenodo_id = zenodo_id,
                    version = version_tag,
                    latest_version = zenodo_id %in% latest_id )

  return(out)
}

#' Download deposit version
#'
#' Downloads and extracts some version of the deposit. This function is specific
#' to the structure of the wdds repo.
#'
#' @param zenodo_id String. ID for a Zenodo deposit. Should correspond to the version of a deposit.
#' @param version String. Version number/id for the deposit (e.g. v.1.1.1).
#' @param latest_version Logical. Indicates that the work is designated as the latest version.
#' @param dir_path String. Path to directory where the files should be downloaded
#'  e.g. "inst/extdata/wdds_archive" note no trailing slash on the path.
#'
#' @returns String. Path to downloaded version.
#' @export
#'
#' @examplesIf curl::has_internet()
#' # list all deposit versions
#' list_deposit_versions()
#'
#' # download the deposit
#'
#' \dontrun{
#' download_deposit_version("15270582","v.1.0.3",TRUE,"data")
#' }
#'
#'
download_deposit_version <- function(zenodo_id,version,latest_version,  dir_path){
  ## create folder in archive for version

  fs::dir_create(path = dir_path)

  ## use id to get the thing
  api_url <- sprintf("https://zenodo.org/api/records/%s",zenodo_id)

  id_json <- jsonlite::fromJSON(api_url)
  zip_file  <- fs::path_file(id_json$files$key)

  zip_path <- sprintf("%s/%s",dir_path,zip_file)
  # replace utils::download.file with curl
  utils::download.file(url = id_json$files$links$self,destfile = zip_path)
  unzip_result <- utils::unzip(zipfile = zip_path,exdir = dir_path, overwrite = TRUE)

  unzip_path <- fs::path_common(unzip_result)

  ## clean up the folder
  # remove zip
  fs::file_delete(zip_path)

  # rename unzipped
  version <- sanitize_version(version)
  version_dir_path <- sprintf("%s/%s",dir_path, version)
  fs::dir_create(path = version_dir_path)

  #move wdds_schema
  unzip_wdds_schema <- sprintf("%s/%s",unzip_path,"wdds_schema")
  version_wdds_schema <- sprintf("%s/%s",version_dir_path, "wdds_schema")
  fs::dir_copy(path = unzip_wdds_schema,new_path = version_wdds_schema,
               overwrite = TRUE)

  # move example data
  unzip_example_data <- sprintf("%s/%s",unzip_path,"example_data")
  version_example_data <- sprintf("%s/%s",version_dir_path, "example_data")
  fs::dir_copy(path = unzip_example_data,new_path = version_example_data,
               overwrite = TRUE)

  # move templates
  unzip_templates <- sprintf("%s/%s",unzip_path,"data_templates")
  version_templates <- sprintf("%s/%s",version_dir_path, "data_templates")
  if(!fs::dir_exists(unzip_templates)){
    # create directory
    fs::dir_create(unzip_templates)
    # copy files
    unzip_file_paths <- fs::dir_ls(unzip_path)
    unzip_template_paths <- fs::path_filter(path = unzip_file_paths,regexp = "template\\.")

    fs::file_move(path = unzip_template_paths, new_path =unzip_templates )

  }

  fs::dir_copy(path = unzip_templates,new_path = version_templates,
               overwrite = TRUE)

  # remove zip
  fs::dir_delete(unzip_path)

  if(latest_version){
    latest_dir_path <- sprintf("%s/%s",dir_path,"latest")
    fs::dir_create(path = latest_dir_path)
    fs::dir_copy(path = version_dir_path,new_path = latest_dir_path, overwrite = TRUE)
  }

  return(version_wdds_schema)
}

#' Batch download deposit versions
#'
#' This is `download_deposit_version` wrapped in a `purr::pmap` call.
#'
#' @param df Data frame. Has the same structure as the output of [list_deposit_versions()].
#' Default is `list_deposit_versions()` so that it downloads all versions of the deposit.
#' @param dir_path Character. Path to folder where files should be downloaded.
#'
#' @returns List of download locations.
#' @export
#'
#' @examples
#' \dontrun{
#' # download all versions
#' batch_download_deposit_versions( dir_path = "data")
#' }
#'
#'
batch_download_deposit_versions <- function(df = list_deposit_versions(), dir_path){

  df$dir_path <- dir_path

  ## map over the version and add to archive
  purrr::pmap(df,download_deposit_version)

}


#' Set the wdds version for the package
#'
#'  Used to keep the package and data standard in alignment.
#'
#' @param version Character. identifier for a version e.g. "v.1.0.2" or "latest".
#' Default is "latest".
#'
#' @returns Character. Current schema version.
#'
set_wdds_version <- function(version = "latest"){

  # sanitize version
  version <- sanitize_version(version)

  # set path
  archive_path <- sprintf("inst/extdata/wdds_archive/%s",version)

  # copy contents to right place
  fs::dir_copy(path = archive_path,
               new_path = "inst/extdata/",
               overwrite = TRUE)

  # set env variables
  the$wdds_version <- version

  return(version)

}

#' Sanitize version ids
#'
#' This function replaces periods with under scores. The different versions
#' of the data standard are stored in folders with their respective names; however,
#' having periods in folder names can cause problems on certain operating systems
#' and makes it more difficult to parse file extensions.
#'
#' @param version Character. Version identifier.
#'
#' @returns Character. Version identifier with no periods.
#' @export
#'
#' @examples
#'
#' sanitize_version("v.1.1.0")
#'
sanitize_version <- function(version){
  version_clean <- stringr::str_replace_all(string = version,pattern = "\\.",replacement = "_")
  return(version_clean)
}

### should be renamed to wdds_json_schema

#' Provides Access to Versioned Schema Files
#'
#' Since schema versions may change during the life cycle of project, it is
#' important that users have access to all schema versions via this package.
#' This function allows you to quickly retrieve whichever schema version you
#' may need.
#'
#' This function does three things:
#'
#' 1) Shows all versions of the schema in the package if both version and file are NULL.
#' 2) Provides relative paths to all schema files associated with a version of the schema if only version is provided.
#' 3) Provides a specific file path in a specific version of the schema if version and file path are provided.
#'
#'
#' @param version Character. Version of the wdds deposit. Leave as NULL to see
#' all versions. Default is NULL to return character vector of versions.
#' @param file Character. Specific file from the wdds deposit. Leave as NULL to
#' see all files in a version. Default is NULL to return character vector of relative file paths.
#'
#' @returns Character. Either version identifiers, relative file paths within a version, or a specific file path.
#' @export
#'
#' @examples
#'
#' # see which versions are in the package
#'
#' wdds_json()
#'
#' # see files associated with a version
#'
#' wdds_json(version = "latest")
#'
#' # get the file path for a specific file
#'
#' wdds_json(version = "v_1_0_2",file = "schemas/disease_data.json")
#'
#'
wdds_json <- function(version = NULL, file = NULL) {

  if (is.null(version)) {
    out <- dir(system.file("extdata/wdds_archive", package = "wddsWizard"))

    out_list <- paste("        - ",out)
    rlang::inform(message = "The following versions of the standard are availble in the package:",body = out_list)
    return(out)
  }

  version_clean <- sanitize_version(version)
  version_dir <- sprintf("%s/wdds_schema", version_clean)

  if(is.null(file)){

  full_paths  <- fs::dir_ls(system.file("extdata/wdds_archive",
                           version_dir,
                           package = "wddsWizard",
                           mustWork = TRUE),
               recurse = TRUE)

  files_only <- full_paths[fs::is_file(full_paths)]

  version_dir_slash <- sprintf("%s/",version_dir)

  out <- stringr::str_split(files_only,version_dir_slash) |>
    purrr::map_chr(~.x[[2]])

  return(out)
  }

  file_path <- sprintf("%s/%s",version_dir, file)

  out  <- system.file("extdata/wdds_archive",
                                 file_path,
                                 package = "wddsWizard",
                                 mustWork = TRUE)

  return(out)
}

#' Provides Access to Versioned Example Data Files
#'
#' Since schema versions may change during the life cycle of project, it is
#' important that users have access to all schema versions via this package.
#' This function allows you to quickly retrieve whichever version of the
#' example data you may need.
#'
#' This function does three things.
#'
#' 1) Shows all versions of the schema in the package if version is NULL.
#' 2) Provides paths to all example data files associated with a version of the schema if version is provided and file is NULL.
#' 3) Provides a specific file path in a specific version of the example data if both file and version are provided.
#'
#'
#' @param version Character. Version of the wdds deposit. Leave as NULL to see
#' all versions. Default is NULL to return a character vector of versions.
#' @param file Character. Specific file from the wdds deposit. Leave as NULL to
#' see all files in a version. Default is NULL to return all files associated with a
#' given version.
#'
#' @returns Character. Either version identifiers or file paths.
#' @export
#'
#' @examples
#'
#' # see which versions are in the package
#'
#' wdds_example_data()
#'
#' # see files associated with a version
#'
#' wdds_example_data(version = "latest")
#'
#' # get the file path for a specific file
#'
#' wdds_example_data(version = "v_1_0_2",file = "Becker_demo_dataset.xlsx")
#'
#'
wdds_example_data <- function(version = NULL, file = NULL) {

  if (is.null(version)) {
    out <- dir(system.file("extdata/wdds_archive", package = "wddsWizard"))

    out_list <- paste("        - ",out)
    rlang::inform(message = "The following versions of the standard are availble in the package:",body = out_list)
    return(out)
  }

  version_clean <- sanitize_version(version)
  version_dir <- sprintf("%s/example_data", version_clean)

  if(is.null(file)){

    out  <- fs::dir_ls(system.file("extdata/wdds_archive",
                                   version_dir,
                                   package = "wddsWizard",
                                   mustWork = TRUE),
                       recurse = TRUE)

    return(out)
  }

  file_path <- sprintf("%s/%s",version_dir, file)

  out  <- system.file("extdata/wdds_archive",
                      file_path,
                      package = "wddsWizard",
                      mustWork = TRUE)

  return(out)
}


#' Provides Access to Versioned Data Template Files
#'
#' Since schema versions may change during the life cycle of project, it is
#' important that users have access to all schema versions via this package.
#' This function allows you to quickly retrieve whichever version of the data
#' templates you may need.
#'
#' This function does three things.
#'
#' 1) Shows all versions of the schema in the package if version is `NULL`
#' 2) Provides paths to all example data files associated with a version of the schema if version is not `NULL` and file is `NULL`
#' 3) Provides a specific file path in a specific version of the example data if both version and file are specified.
#'
#'
#' @param version Character. Version of the wdds deposit. Leave as NULL to see
#' all versions.
#' @param file Character. Specific file from the wdds deposit. Leave as NULL to
#' see all files in a version.
#'
#' @returns Character. Either version identifiers or file paths.
#' @export
#'
#' @examples
#'
#' # see which versions are in the package
#'
#' wdds_data_templates()
#'
#' # see files associated with a version
#'
#' wdds_data_templates(version = "latest")
#'
#' # get the file path for a specific file
#'
#' wdds_data_templates(version = "v_1_0_2",file = "disease_data_template.csv")
#'
#'
wdds_data_templates <- function(version = NULL, file = NULL) {

  if (is.null(version)) {
    out <- dir(system.file("extdata/wdds_archive", package = "wddsWizard"))

    out_list <- paste("        - ",out)
    rlang::inform(message = "The following versions of the standard are availble in the package:",body = out_list)
    return(out)
  }

  version_clean <- sanitize_version(version)
  version_dir <- sprintf("%s/data_templates", version_clean)

  if(is.null(file)){

    out  <- fs::dir_ls(system.file("extdata/wdds_archive",
                                   version_dir,
                                   package = "wddsWizard",
                                   mustWork = TRUE),
                       recurse = TRUE)

    return(out)
  }

  file_path <- sprintf("%s/%s",version_dir, file)

  out  <- system.file("extdata/wdds_archive",
                      file_path,
                      package = "wddsWizard",
                      mustWork = TRUE)

  return(out)
}

