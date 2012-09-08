#!/bin/sh
# vim: set ft=sh et sw=2:

git last
printf '\e[m\n'
git whatthefuckdidido \
  | tail -25          \
  | perl -pe          \
    '
      s/^([\s]*-.*)/\e[38;5;196m$1\e[m/,
      s/^([\s]*[+].*)/\e[38;5;70m$1\e[m/,
      s/^/\t/
    '
echo
git-awesome-status
