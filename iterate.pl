#!/usr/bin/perl
use strict;

my $count = shift or die();
my $cmd = sub { system(@ARGV) };

for(my $i=0; $i < $count; ++$i) {
  print "run ".$i+1;
  $cmd->();
}
