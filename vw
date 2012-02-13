#!/bin/sh
# format text properly and send it to vim

/bin/cat "$@" \
  | perl -MText::Autoformat -ne 'print autoformat($_, { left => 0, right => 72 })' \
  | /usr/bin/vim -R -c ':set ft=_txt.txt' -
