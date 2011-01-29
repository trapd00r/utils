#!/usr/bin/perl
# google_dmenu.pl
# thanks to Gazj for the original bash version
use strict;

my $dmenu = 'dmenu -i -b -nb #1c1c1c -nf #d7005f -sb #252525';
my $d_cmd = `$dmenu -p search`;

system("firefox -new-window http://google.com/search?q=$d_cmd")
  unless !$d_cmd;
