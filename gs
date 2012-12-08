#!/bin/zsh
# vim: set ft=sh et sw=2:

#git last
#git whatthefuckdidido \
#  | tail -25          \
#  | perl -pe          \
#    '
#      s/^([\s]*-.*)/\e[38;5;196m$1\e[m/,
#      s/^([\s]*[+].*)/\e[38;5;70m$1\e[m/,
#      s/^/\t/
#    '
#echo
#git-awesome-status
git status --short "$@"
builtin print -P ' '${vcs_info_msg_0_}
