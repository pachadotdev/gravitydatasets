.onAttach <- function(...) {
  packageStartupMessage("GRAVITY DATASETS\nThe package documentation and usage examples can be found at https://pacha.dev/gravitydatasets/.\nVisit https://buymeacoffee.com/pacha if you wish to donate to contribute to the development of this software.\nThis library needs 6.4 GB of free disk space to store the database locally.")
  if (interactive() && Sys.getenv("RSTUDIO") == "1" && !in_chk()) {
    gravitydatasets_pane()
  }
  if (interactive()) gravitydatasets_status()
}
