#!/bin/zsh
# vim: ft=sh tw=80 sw=2:
if [[ -x  =ls++ && $HURRY -lt 1 ]] && [[ $TERM != 'linux' ]]; then
  ls++ "$@"
elif [[ -x  =vdir ]]; then
  vdir -bBGhHnNvXw $(($COLUMNS * 0.92 )) \
    --quoting-style=shell --group-directories-first --format=vertical \
    --dereference-command-line-symlink-to-dir \
    --block-size=1k --show-control-chars  --author \
    --color     --indicator-style=none
elif [[ -x  =gls ]]; then
  gls -hlv --group-directories-first --color--time=ctime --time-style=+%s
elif [[ -x  =ls ]] && [[ =ls != $0 ]]; then
  ls -hlv --group-directories-first --color--time=ctime --time-style=+%s
else
  perl -e '
    $\=$/;
    print for map {
      -d $_ "\e[34m$_\e[1m/\e[m" : -x $_ ? "\e[33m$_\e[m" : $_ }
    sort { lc $b cmp lc $a }
    glob("*")
  '
fi
