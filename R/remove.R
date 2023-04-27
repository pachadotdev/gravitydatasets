#' Delete the gravitydatasets database from your computer
#'
#' Deletes the `gravitydatasets` directory and all of its contents, including
#' all versions of the gravitydatasets database created with any DuckDB version.
#'
#' @param ask If so, a menu will be displayed to confirm the action to
#' delete any existing gravitydatasets database. By default it is true.
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{ gravitydatasets_delete() }
gravitydatasets_delete <- function(ask = TRUE) {
  if (isTRUE(ask)) {
    answer <- utils::menu(c("Agree", "Cancel"),
                   title = "This will eliminate all gravitydatasets databases",
                   graphics = FALSE)
    if (answer == 2) {
       return(invisible())
    }
  }

  suppressWarnings(gravitydatasets_disconnect())
  try(unlink(gravitydatasets_path(), recursive = TRUE))
  update_gravitydatasets_pane()
  return(invisible())
}
