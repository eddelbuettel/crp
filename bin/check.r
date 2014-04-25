#!/usr/bin/r

tmpfile <- tempfile(pattern = "crp", fileext = ".html")
polurl  <- "http://cran.r-project.org/web/packages/policies.html"
report  <- file.path("~", "git", "crp")
setwd(report)

download.file(url=polurl, destfile=tmpfile, quiet=TRUE, cacheOK=FALSE)
pols <- readLines(tmpfile)
ind <- which(grepl("Version \\$Revision: \\d+ \\$$", pols))

rev <- as.numeric(gsub(".*Version \\$Revision: (\\d+) \\$$", "\\1", pols[ind], perl=TRUE))

prvfile <- file.path("html", paste0("policies.r", rev, ".html"))
if (file.exists(prvfile)) {
    q()                                 # nothing new here, our work is done
}

## copy html file into archive
file.copy(tmpfile, prvfile)

## create txt file
txtfile <- file.path("html", paste0("policies.r", rev, ".txt"))
cmd <- sprintf("links -dump %s > %s", prvfile, txtfile)
system(cmd)

## commit html and txt file
cmd <- sprintf("git add %s %s; git commit -m'new rev%d'; git push", prvfile, txtfile, rev)
system(cmd)

  ## 535  links -dump html/policies.r2935.html > txt/policies.r2935.txt
  ## 536  git status
  ## 537  git add html/policies.r2935.html txt/policies.r2935.txt
  ## 538  git status
  ## 539  git commit -m'new rev2935'
  ## 540  git push

## tweet using bti with info in config file
con <- pipe("bti/bti --config bti/bti.conf", "w")
cat(sprintf("New CRAN Repository Policy rev%d posted, history at %s #rstats",
            rev, "https://github.com/eddelbuettel/crp/tree/master/txt"),
    file=con)
close(con)

## send me a mail too
cmd <- sprintf("mailx -s 'New CRAN Repo Policy revision %d found' edd@debian.org", rev)
system(cmd)

## also update svn
system("cd ~/svn/cranpolicy && svn up && cd -")
## and copy
file.copy("~/svn/cranpolicy/CRAN_policies.texi", "texi/CRAN_policies.texi", overwrite=TRUE, copy.date=TRUE)
## and commit
cmd <- sprintf("git add texi/CRAN_policies.texi; git commit -m'new rev%d of texi'; git push", rev)

