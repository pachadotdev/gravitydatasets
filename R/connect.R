gravitydatasets_path <- function() {
  sys_gravitydatasets_path <- Sys.getenv("gravitydatasets_DIR")
  sys_gravitydatasets_path <- gsub("\\\\", "/", sys_gravitydatasets_path)
  if (sys_gravitydatasets_path == "") {
    return(gsub("\\\\", "/", tools::R_user_dir("gravitydatasets")))
  } else {
    return(gsub("\\\\", "/", sys_gravitydatasets_path))
  }
}

gravitydatasets_check_status <- function() {
  if (!gravitydatasets_status(FALSE)) {
    stop("The gravitydatasets database is empty or damaged.
         Download it with gravitydatasets_download().")
  }
}

#' Connect to the gravitydatasets database
#'
#' Returns a local database connection. This corresponds to a DBI-compatible
#' DuckDB database.
#'
#' @param dir Database location on disk. Defaults to the `gravitydatasets`
#' directory inside the R user folder or the `gravitydatasets_DIR` environment variable
#' if specified.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  DBI::dbListTables(gravitydatasets_connect())
#'
#'  DBI::dbGetQuery(
#'   gravitydatasets_connect(),
#'   'SELECT * FROM gravitydatasets WHERE year = 2010'
#'  )
#' }
gravitydatasets_connect <- function(dir = gravitydatasets_path()) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_file <- paste0(dir, "/gravitydatasets_duckdb_v", gsub("\\.", "", duckdb_version), ".sql")

  db <- mget("gravitydatasets_connect", envir = gravitydatasets_cache, ifnotfound = NA)[[1]]

  if (inherits(db, "DBIConnection")) {
    if (DBI::dbIsValid(db)) {
      return(db)
    }
  }

  try(dir.create(dir, showWarnings = FALSE, recursive = TRUE))

  drv <- duckdb::duckdb(db_file, read_only = FALSE)

  tryCatch({
    con <- DBI::dbConnect(drv)
  },
  error = function(e) {
    if (grepl("Failed to open database", e)) {
      stop(
        "The local gravitydatasets database is being used by another process. Try
        closing other R sessions or disconnecting the database using
        gravitydatasets_disconnect() in the other sessions.",
        call. = FALSE
      )
    } else {
      stop(e)
    }
  },
  finally = NULL
  )

  assign("gravitydatasets_connect", con, envir = gravitydatasets_cache)
  con
}

#' Disconnect the gravitydatasets database
#'
#' An auxiliary function to disconnect from the database.
#'
#' @examples
#' gravitydatasets_disconnect()
#' @export
#'
gravitydatasets_disconnect <- function() {
  gravitydatasets_disconnect_()
}

gravitydatasets_disconnect_ <- function(environment = gravitydatasets_cache) {
  db <- mget("gravitydatasets_connect", envir = gravitydatasets_cache, ifnotfound = NA)[[1]]
  if (inherits(db, "DBIConnection")) {
    DBI::dbDisconnect(db, shutdown = TRUE)
  }
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed("Gravity Datasets", "gravitydatasets")
  }
}

gravitydatasets_status <- function(msg = TRUE) {
  expected_tables <- sort(gravitydatasets_tables())
  existing_tables <- sort(DBI::dbListTables(gravitydatasets_connect()))

  if (isTRUE(all.equal(expected_tables, existing_tables))) {
    status_msg <- crayon::green(paste(cli::symbol$tick,
                                      "The local gravitydatasets database is OK."))
    out <- TRUE
  } else {
    status_msg <- crayon::red(paste(cli::symbol$cross,
                                    "The local gravitydatasets database is empty, damaged or not compatible with your duckdb version. Download it with gravitydatasets_download()."))
    out <- FALSE
  }
  if (msg) msg(status_msg)
  invisible(out)
}

gravitydatasets_tables <- function() {
  c(
    paste0("cepii_", c("country_information", "gdp_source", "gravity", "legal_origin", "main_city_source", "pop_source", "rta_coverage", "rta_type")),
    paste0("usitc_", c("country_names", "gravity", "industry_names", "region_names", "sector_names", "trade")),
    paste0("wto_", c("country_names", "trade")),
    "metadata"
  )
}

gravitydatasets_cache <- new.env()
reg.finalizer(gravitydatasets_cache, gravitydatasets_disconnect_, onexit = TRUE)
