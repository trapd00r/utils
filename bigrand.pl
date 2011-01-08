#!/usr/bin/perl
# bigrand
use strict;

print "num> ";
while(my $num = <STDIN>) {
  chomp($num);
  $num = ord($num) unless $num =~ /^\d+$/;
  my @rand = map { int(rand(101)) } 0 .. 20;
  print "$_\n" for sort( grep{ $num < $_ } @rand);
  print "num> ";
}
