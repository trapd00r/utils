#!/bin/zsh
# abstract: send now playing artist to mtree

album="$(mpc current --format %album%)"
=mtree -d "$(mpc current --format %artist%)" | perl -pe "s/$album/\033[38;5;208m$album/"
