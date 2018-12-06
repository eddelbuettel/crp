## crp

Archived copies of the CRAN Repo Policy

### Status

This small project started out as simple monitoring of the single webpage
http://cran.r-project.org/web/packages/policies.html which was done with 
a few lines of R detecting whether or not the page changed. If so, the new
version was logged, and an email and a tweet were sent.  This is what I made
public on 23 Oct 2013.

Gábor Csárdi sent me an email mentioning the actual SVN repo of the CRAN web
site. The repo contains the actual source, so on 24 Oct 2013 I added a new
shell script to retrieve all versions still in the SVN repo (going back Dec
2011). I will update the monitoring script to simply use SVN as well.

So for now, the best view of the evolution may be the history of the texi
source, eg via

   https://github.com/eddelbuettel/crp/commits/master/texi

### Twitter Updates

You can follow [@CRANPolicyWatch](https://twitter.com/CRANPolicyWatch) on
Twitter to receive a tweet whenever a change in the CRAN Repo Policy is
detected and reported.

### Author

The scripts in this repo were written by Dirk Eddelbuettel

### License

GPL (>= 2)
