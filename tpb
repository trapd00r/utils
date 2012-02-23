#!/bin/sh

wget -nv -nc -c -E  \
  $( lynx -dump "$@" | awk '/http.+[.]torrent$/ { print $2 }' )
