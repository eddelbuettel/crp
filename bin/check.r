#!/usr/bin/r

tmpfile <- tempfile(pattern = "crp", fileext = ".html")
polurl  <- "https://cran.r-project.org/web/packages/policies.html"
report  <- file.path("~", "git", "crp")
setwd(report)

download.file(url=polurl, destfile=tmpfile, quiet=TRUE, cacheOK=FALSE)
pols <- readLines(tmpfile)
ind <- which(grepl("Version \\$Revision: \\d+ \\$", pols))

rev <- unique(as.numeric(gsub(".*Version \\$Revision: (\\d+) \\$.*", "\\1", pols[ind], perl=TRUE)))

prvfile <- file.path("html", paste0("policies.r", rev, ".html"))
if (file.exists(prvfile)) {
    q()                                 # nothing new here, our work is done
}

## copy html file into archive
file.copy(tmpfile, prvfile)
basehtmlfile <- file.path("html", "policies.html")
file.copy(tmpfile, basehtmlfile, overwrite=TRUE)

## create txt file
txtfile <- file.path("txt", paste0("policies.r", rev, ".txt"))
cmd <- sprintf("links -dump %s > %s", prvfile, txtfile)
system(cmd)
basetxtfile <- file.path("txt", "policies.txt")
file.copy(txtfile, basetxtfile, overwrite=TRUE)

## --
## also update svn
system("cd ~/svn/cranpolicy && svn up && cd -")
## and copy
setwd(report)
texifile <- "texi/CRAN_policies.texi"
file.copy("~/svn/cranpolicy/CRAN_policies.texi", texifile, overwrite=TRUE, copy.date=TRUE)
## and commit
#cmd <- sprintf("git add texi/CRAN_policies.texi; git commit -m'new rev%d of texi'; git push", rev)
#system(cmd)
## --


## commit html and txt file
cmd <- sprintf("git add %s %s %s %s %s; git commit -m'new rev%d'; git push",
               prvfile, basehtmlfile, txtfile, basetxtfile, texifile, rev)
system(cmd)

  ## 535  links -dump html/policies.r2935.html > txt/policies.r2935.txt
  ## 536  git status
  ## 537  git add html/policies.r2935.html txt/policies.r2935.txt
  ## 538  git status
  ## 539  git commit -m'new rev2935'
  ## 540  git push

## tweet using bti with info in config file
#con <- pipe("bti/bti --config bti/bti.conf", "w")
#cat(sprintf("New CRAN Repository Policy rev%d posted, history at %s #rstats",
#            rev, "https://github.com/eddelbuettel/crp/tree/master/txt"),
#    file=con)
#close(con)
## toot using toot with prior oauthi
con <- pipe("toot post --using CRANPolicyWatch@fosstodon.org --quiet", "w")
cat(sprintf("New CRAN Repository Policy rev%d posted, history at %s #rstats",
            rev, "https://github.com/eddelbuettel/crp/tree/master/txt"),
    file=con)
close(con)

## send me a mail too
cmd <- sprintf("echo '' | mailx -s 'New CRAN Repo Policy revision %d found' edd@debian.org", rev)
system(cmd)


