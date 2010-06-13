#!/bin/sh
ls -hovA --indicator-style=file-type --color=always --group-directories-first --time=ctime --time-style=full-iso "$@"|
tr -s "[:blank:]" " "|
awk {'print "\033[38;5;241m[\033[38;5;240m"$1 "\033[38;5;241m]\033[38;5;241m "$5 "\033[38;5;255m " $8 "\033[0m"'}

#:vim: set nowrap:
