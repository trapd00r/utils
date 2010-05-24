#!/bin/sh
ls -hovA --indicator-style=file-type --color=always --group-directories-first --time=ctime --time-style=full-iso "$@"|
tr -s "[:blank:]" " "|cut -d" " -f3-|
awk '{print" \033[38;5;100m"$3"\033[0m ""\033[38;5;235m-\033[38;5;161m"$5"\033[0m\t\033[38;5;130m"$3"\033[0m" $4}'

