#!/bin/bash
# copy the playing track from remote mpd session to local machine
# This was sexier in Perl, but Net::SCP is retarded and wraps scp anyway

if [ $@ ]; then
  dir=$@;
else
  dir='.';
fi

scp -P 19216 "192.168.1.101:'/mnt/Music_1/$(mpc -h 192.168.1.101 --format %file%|head -1)'" $dir
