sql_action <- function() {
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      exists("documentNew", asNamespace("rstudioapi"))) {
    contents <- paste(
      "-- !preview conn=gravitydatasets::gravitydatasets_connect()",
      "",
      "SELECT * FROM gravitydatasets WHERE year = 2010",
      "",
      sep = "\n"
    )

    rstudioapi::documentNew(
      text = contents, type = "sql",
      position = rstudioapi::document_position(2, 40),
      execute = FALSE
    )
  }
}

gravitydatasets_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer) && interactive()) {
    observer$connectionOpened(
      type = "Gravity Datasets",
      host = "gravitydatasets",
      displayName = "Gravity Datasets",
      icon = system.file("img", "edit-sql.png", package = "gravitydatasets"),
      connectCode = "gravitydatasets::gravitydatasets_pane()",
      disconnect = gravitydatasets::gravitydatasets_disconnect,
      listObjectTypes = function() {
        list(
          table = list(contains = "data")
        )
      },
      listObjects = function(type = "datasets") {
        tbls <- DBI::dbListTables(gravitydatasets_connect())
        data.frame(
          name = tbls,
          type = rep("table", length(tbls)),
          stringsAsFactors = FALSE
        )
      },
      listColumns = function(table) {
        res <- DBI::dbGetQuery(gravitydatasets_connect(),
                               paste("SELECT * FROM", table, "LIMIT 1"))
        data.frame(
          name = names(res), type = vapply(res, function(x) class(x)[1],
                                           character(1)),
          stringsAsFactors = FALSE
        )
      },
      previewObject = function(rowLimit, table) {
        DBI::dbGetQuery(gravitydatasets_connect(),
                        paste("SELECT * FROM", table, "LIMIT", rowLimit))
      },
      actions = list(
        Status = list(
          icon = system.file("img", "edit-sql.png", package = "gravitydatasets"),
          callback = gravitydatasets_status
        ),
        SQL = list(
          icon = system.file("img", "edit-sql.png", package = "gravitydatasets"),
          callback = sql_action
        )
      ),
      connectionObject = gravitydatasets_connect()
    )
  }
}

update_gravitydatasets_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionUpdated("Gravity Datasets", "gravitydatasets", "")
  }
}
