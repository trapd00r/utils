#!/usr/bin/perl
use strict;
# pnfo
# NFO files are ASCII-art with the cp437 codepage
# Lucida ConsoleP has support for all the cp437 chars

my $term = "urxvt -fn xft:'Lucida ConsoleP'  -fg '#ffffff' -uc +sb";
my $viewer = "vimpager-nfo";

my $dir = shift // '.';
my @nfos = grep{/\.nfo$/} glob("$dir/*");

system("$term -e $viewer @nfos") == 0 or die "Whoops! $!";

