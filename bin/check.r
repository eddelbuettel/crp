#!/usr/bin/r

tmpfile <- "/tmp/crp.html"
polurl  <- "http://cran.r-project.org/web/packages/policies.html"
report  <- file.path("~", "git", "crp")

download.file(url=polurl, destfile=tmpfile, quiet=TRUE, cacheOK=FALSE)
pols <- readLines(tmpfile)
ind <- which(grepl("Version \\$Revision: \\d+ \\$$", pols))

rev <- as.numeric(gsub(".*Version \\$Revision: (\\d+) \\$$", "\\1", pols[ind], perl=TRUE))

prvfile <- file.path(report, "html", paste0("policies.r", rev, ".html"))
if (file.exists(prvfile)) {
    q()                                 # nothing new here, our work is done
}

## need to expand this part -- blog/tweet/mail/...
file.copy(tmpfile, prvfile)
cmd <- sprintf("mailx -s 'New CRAN Repo Policy revision %d found' edd@debian.org", rev)
system(cmd)
