#' Download the USITC Gravity Database to your computer
#'
#' This command downloads the entire database as a single zip file that is
#' unzipped to create the local database. If you do not want to download the
#' database on your home computer, run usethis::edit_r_environ() to create the
#' environment variable gravitydatasets_DIR with the path.
#'
#' @param ver The version to download. By default it is the latest version
#' available on GitHub. All versions can be viewed at
#' <https://github.com/pachadotdev/gravitydatasets/releases>.
#'
#' @param local_file The path to a local zip file. If this is provided, the
#' function will not download the file from GitHub and will instead use the
#' local file.
#' 
#' @return NULL
#' @export
#'
#' @importFrom archive archive_extract
#' 
#' @examples
#' \dontrun{ gravitydatasets_download() }
gravitydatasets_download <- function(ver = NULL, local_file = NULL) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_pattern <- paste0("v", gsub("\\.", "", duckdb_version), ".sql$")

  duckdb_current_files <- list.files(gravitydatasets_path(), db_pattern, full.names = T)

  if (length(duckdb_current_files) > 0 &&
      # avoid listing initial empty duckdb files
      all(file.size(duckdb_current_files) > 5000000000)) {
    msg("A gravitydatasets database already exists for your version of DuckDB.")
    msg("If you really want to download the database again, run gravitydatasets_delete() and then download it again.")
    return(invisible())
  }

  destdir <- tempdir()
  dir <- gravitydatasets_path()

  suppressWarnings(try(dir.create(dir, recursive = TRUE)))

  suppressWarnings(try(gravitydatasets_disconnect()))

  msg("Deleting any old versions of the database...\n")
  gravitydatasets_delete(ask = FALSE)

  if (!is.null(local_file)) {
    msg("Using local file to create the database...")

    zfile <- local_file
  } else {
    msg("Downloading the database from GitHub...")

    zfile <- get_gh_release_file("pachadotdev/gravitydatasets",
                                tag_name = ver,
                                dir = destdir
    )
    ver <- attr(zfile, "ver")
  }

  msg("Unzipping the necessary files...")
  # TODO: use archive
  archive::archive_extract(zfile, dir = destdir)
  unlink(zfile)

  finp_tsv <- list.files(destdir, full.names = TRUE, pattern = "tsv")

  invisible(create_schema())

  for (x in seq_along(finp_tsv)) {
    tout <- gsub(".*/", "", gsub("\\.tsv", "", finp_tsv[x]))

    msg(sprintf("Creating %s table...", tout))

    con <- gravitydatasets_connect()

    suppressMessages(
      DBI::dbExecute(
        con,
        paste0(
          "COPY ", tout, " FROM '",
          finp_tsv[x],
          "' ( DELIMITER '\t', HEADER 1, NULL '' )"
        )
      )
    )

    DBI::dbDisconnect(con, shutdown = TRUE)

    unlink(finp_tsv[x])
    invisible(gc())
  }

  metadata <- data.frame(duckdb_version = utils::packageVersion("duckdb"),
                         modification_date = Sys.time())
  metadata$duckdb_version <- as.character(metadata$duckdb_version)
  metadata$modification_date <- as.character(metadata$modification_date)

  con <- gravitydatasets_connect()
  suppressMessages(DBI::dbWriteTable(con, "metadata", metadata, append = T, temporary = F))
  DBI::dbDisconnect(con, shutdown = TRUE)

  update_gravitydatasets_pane()
  gravitydatasets_pane()
  gravitydatasets_status()
}

#' Download tsv files from GitHub
#' @noRd
get_gh_release_file <- function(repo, tag_name = NULL, dir = tempdir(),
                                overwrite = TRUE) {
  releases <- httr::GET(
    paste0("https://api.github.com/repos/", repo, "/releases")
  )
  httr::stop_for_status(releases, "finding versions")

  releases <- httr::content(releases)

  if (is.null(tag_name)) {
    release_obj <- releases[1]
  } else {
    release_obj <- purrr::keep(releases, function(x) x$tag_name == tag_name)
  }

  if (!length(release_obj)) stop("No available version \"",
                                 tag_name, "\"")

  if (release_obj[[1]]$prerelease) {
    msg("This data has not yet been validated.")
  }

  download_url <- release_obj[[1]]$assets[[1]]$url
  filename <- basename(release_obj[[1]]$assets[[1]]$browser_download_url)
  out_path <- normalizePath(file.path(dir, filename), mustWork = FALSE)
  response <- httr::GET(
    download_url,
    httr::accept("application/octet-stream"),
    httr::write_disk(path = out_path, overwrite = overwrite),
    httr::progress()
  )
  httr::stop_for_status(response, "downloading data")

  attr(out_path, "ver") <- release_obj[[1]]$tag_name
  return(out_path)
}

