#!/bin/sh
# rename files in subdirs to the name of the subdir_originalfilename
for f in */* ;do fp=$(dirname "$f"); fl=$(basename "$f"); mv -v "$fp/$fl" "$fp/$fp"_"$fl"; done
