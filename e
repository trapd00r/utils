#!/bin/sh
# vim:ft=zsh:
# abstract: grep eminem release

# % e mock
# /mnt/music8/+TAGGED/E/Eminem/+other/Eminem │2005│ Mockingbird [MP3]
# -  16M, 3 file(s)
# /mnt/music8/+TAGGED/E/Eminem/+singles/Eminem │2003│ Mockingbird [CD Single] [Single, MP3]
# -  19M, 3 file(s)
# /mnt/music8/+TAGGED/E/Eminem/+singles/Eminem │2004│ Mockingbird [Vinyl, MP3]
# -  23M, 5 file(s)
# /mnt/music8/+TAGGED/E/Eminem/+singles/Eminem │2005│ Mockingbird [Single, CD, MP3]
# -  59M, 6 file(s)



find '/mnt/music8/+TAGGED/E/Eminem' \
  -maxdepth 3 \
  -type d     \
  -iname "*${1}*" \
  -exec tree -h --du {} \; \
    | grep -v ── \
    | perl -pe 's/^\n$/\033[38;5;240;1;3m-\033[m/' \
    | perl -pe 's/([0-9.]+)(.)\s+used in \d directories, (\d+) files?/\033[1m$1$2\033[m, \033[38;5;214;1;4m$3\033[m file(s)/' \
    | ls_color
