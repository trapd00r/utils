#!/usr/bin/perl
# parselscolors
use strict;

my $lscolors = "$ENV{LS_COLORS}";

my @ft = split(/=/, $lscolors);

my %colors = ();
my $symlink;

for my $ft(@ft) {
  if($ft =~ m/([0-9]+;[0-9]+;[0-9]+):\*?(.+)/) {
  my $clr = $1;
  my $file = $2;
  $colors{$file} = $clr;
}
 
  if($ft =~ m/(target|follow)/) {
    next;
  }
}

for my $f(sort(keys(%colors))) {
  printf("\033[$colors{$f}m %25s\033[0m %s\n",
    "$f", $colors{$f});
}
printf(" %25s %s\n",'symlink',$symlink); # bah, lazy
