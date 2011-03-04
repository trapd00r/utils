#!/usr/bin/perl
use strict;

use File::Find::Rule;

my @pm = File::Find::Rule->file()
                         ->name('*.pm')
                         ->in(@INC);

for(@INC) {
  next if /^..?$/;
  system("du -hs $_");
}

printf("\n%d modules installed\n", scalar(@pm));
