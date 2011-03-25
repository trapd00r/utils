#!/usr/bin/perl

use strict;
use warnings;

use File::Find::Rule;
use Regexp::Common qw(URI);

my $dir = shift // '.';

my @f = grep{!/(?:blib|[.]git|cover_db)/} File::Find::Rule->file()
                                                 ->in($dir);
for my $file(@f) {
  my $seen = 0;
  open(my $fh, '<', $file) or die($!);
  while(<$fh>) {
    if($_ =~ m/($RE{URI}{HTTP})/) {
      $seen++;
      printf(" \e[3m%s\e[m\n", $file) unless($seen >= 2);
      printf("\e[38;5;85m% 4d\e[m: %s\n", $., $1); 
    }
  }
}
