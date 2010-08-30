#!/usr/bin/perl
use strict;

my $colors = $ENV{LS_COLORS};

my $i=0;
my $end;
for(split(/:/,$colors)) {
  if($i % 22 == 0) {
    $end = "\n";
  }
  else {
    $end = " ";
  }
  my ($ft,$color) = $_ =~ /\*\.(.+)=(.+)/;
  print "\e[$color" . 'm' . "$ft\e[0m$end";
  $i++;
}
