#!/bin/bash
# push to all remote repos

for repo in $(git remote); do
  printf "\e[1m\e[34m%10s\e[0m" $repo &&
    git push $repo
done
