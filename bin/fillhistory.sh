#!/bin/bash
#
# With thanks to Gábor Csárdi who pointed me to the after all
# not-so-hidden SVN repo for the CRAN website
#
# Someone may as well volunteer to mirror the full svn repo in github,
# this won't be me -- now that I know of the SVN repo I have what I need.
#
# Dirk Eddelbuettel, 24 Oct 2013

policyversions=$(cd ~/svn/cranpolicy && svn log CRAN_policies.texi | grep -e "^r[0-9]\+" | sed -e 's/^r//' | cut -d' ' -f1 | sort -n)

for p in ${policyversions}; do 
    cd ~/svn/cranpolicy 
    svn up -r${p} CRAN_policies.texi 
    cp CRAN_policies.texi ~/git/crp/texi

    cd ~/git/crp/texi
    git commit CRAN_policies.texi -m"Revision ${p}"
done






