#!/usr/bin/perl
use strict;
use Audio::MPD;

my $mpd = Audio::MPD->new;

my $basedir  = '/mnt/Music_1';
my $current  = $mpd->current->file;
my $file = "$basedir/$current";

my ($basename) = $current =~ m;.+/(.+)$;;


system("scp -P 19216 '$file' scp1\@192.168.1.100:http/psy/dump");
system("echo http://psy.trapd00r.se/dump/$basename");
system("echo http://psy.trapd00r.se/dump/$basename|xclip");
