#!/bin/bash
# transfer the playing song on the remote mpd server to the local box

target="$HOME/ToTransfer/"
if [ $@ ]; then
  target="$@"
fi

base='/mnt/Music_1'
file=$(mpc -h 192.168.1.101 --format %file%|head -1)
path="'$base/$file'"
basename=$(echo $path|perl -pe 's;.+/(.+)$;$1;')
printf "\e[1m%s\e[0m => \e[31m%s\e[0m\n" $basename $target
scp -P 19216 scp1@192.168.1.101:$path $target
