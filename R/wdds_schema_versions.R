### list all versions of the schema on zenodo

# https://zenodo.org/api/records/15257971/versions



list_schema_versions <- function(parent_id = "15020049"){
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

get_schema_version <- function(zenodo_id,version,latest_version){
  ## create folder in archive for version
  dir_path <- "inst/extdata/wdds_archive"
  fs::dir_create(path = dir_path)

  ## use id to get the thing
  api_url <- sprintf("https://zenodo.org/api/records/%s",zenodo_id)

  id_json <- jsonlite::fromJSON(api_url)
  zip_file  <- fs::path_file(id_json$files$key)

  zip_path <- sprintf("%s/%s",dir_path,zip_file)
  download.file(url = id_json$files$links$self,destfile = zip_path)
  unzip_result <- unzip(zipfile = zip_path,exdir = dir_path, overwrite = TRUE)

  unzip_path <- fs::path_common(unzip_result)

  ## clean up the folder
  # remove zip
  fs::file_delete(zip_path)

  # rename unzipped
  version <- sanitize_version(version)
  version_dir_path <- sprintf("inst/extdata/wdds_archive/%s",version)
  fs::dir_create(path = version_dir_path)

  #move wdds_schema
  unzip_wdds_schema <- sprintf("%s/%s",unzip_path,"wdds_schema")
  version_wdds_schema <- sprintf("%s/%s",version_dir_path, "wdds_schema")


  fs::dir_copy(path = unzip_wdds_schema,new_path = version_wdds_schema,overwrite = TRUE)

  # remove zip
  fs::dir_delete(unzip_path)

  if(latest_version){
    latest_dir_path <- sprintf("inst/extdata/wdds_archive/%s","latest")
    fs::dir_create(path = latest_dir_path)
    latest_wdds_schema <- sprintf("%s/%s",latest_dir_path, "wdds_schema")
    fs::dir_copy(path = version_wdds_schema,new_path = latest_wdds_schema, overwrite = TRUE)
  }

  return(version_wdds_schema)
}

update_schema_versions <- function(df = list_schema_versions()){

  ## map over the version and add to archive
  purrr::pmap(df,get_schema_version)


}


set_schema_version <- function(version = "latest"){

  # sanitize version
  version <- sanitize_version(version)

  # set path
  archive_path <- sprintf("inst/extdata/wdds_archive/%s/wdds_schema",version)

  # copy contents to right place
  fs::dir_copy(path = archive_path,
               new_path = "inst/extdata/wdds_schema/",
               overwrite = TRUE)

  # set env variables e.g. the$current_schema... I think no


}

sanitize_version <- function(version){
  version_clean <- stringr::str_replace_all(string = version,pattern = "\\.",replacement = "_")
  return(version_clean)
}

