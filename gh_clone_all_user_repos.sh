#!/bin/sh
# abstract: clone all repos from $GITHUB_USER

CNTX='users'; NAME=$GITHUB_USER

# 189 repos as of  2018-12-18 15:34:34 

for PAGE in {1..3}; do 
  curl -s "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
    grep -e 'git_url*' |
    cut -d \" -f 4  |
    xargs -L1 git clone
  done
