\ls -hAlv --group-directories-first --color=always --indicator-style=file-type "$@"|awk '{print "\033[48;5;232m\033[38;5;32m\033[31;1m\033[38;5;236m"$1 "\033[0m\033[48;5;232m\033[38;5;244m▕\033[0m " $9 $10 $11}'|perl -pe 's/->/\033[38;5;148m \033[1m▪▶ \033[0m/'|perl -pe 's/.+total.+//'|perl -pe 's/^\s+//'

# vim: set textwidth=0 nowrap:

