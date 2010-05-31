#!/bin/sh
ls -hovA --indicator-style=file-type --color=always --group-directories-first --time=ctime --time-style=full-iso "$@"|
tr -s "[:blank:]" " "|
awk {'print "\033[38;5;144m"$1 "\033[38;5;47m " $5 " " $6'}
