.onAttach <- function(...) {
  msg(cli::rule(crayon::bold("Gravity Datasets")))
  msg(" ")
  msg("The package documentation and usage examples can be found at https://pacha.dev/gravitydatasets/.")
  msg("Visit https://buymeacoffee.com/pacha if you wish to donate to contribute to the development of this software.")
  msg("This library needs 6.5 GB of free disk space to create the database locally. Once the database is created, it occupies 1.1. GB of disk space.")
  msg(" ")
  if (interactive() && Sys.getenv("RSTUDIO") == "1"  && !in_chk()) {
    gravitydatasets_pane()
  }
  if (interactive()) gravitydatasets_status()
}
