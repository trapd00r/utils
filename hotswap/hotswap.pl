#!/usr/bin/perl
# hotswap
use strict;
use Term::ExtendedColor;

my $config = './config.conf';
our @c;

while(chomp(my  $line = <STDIN>)) {
  print "\n";
  print "> ";
  if($line =~ /^r/) {
    delete($INC{'config.conf'});
    print Dumper \%INC;
    reload();
  }
}


sub reload {
  require 'config.conf';
  for my $fg(@c) {
    print fg($fg, $fg), "\n";
  }
}
