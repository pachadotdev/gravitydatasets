library(archive)

fout <- "dev/fout/"

zip <- paste0(fout, "files-for-db.zip")

if (!file.exists(zip)) {
  archive_write_dir(zip, fout)
}
