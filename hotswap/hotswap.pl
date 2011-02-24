#!/usr/bin/perl
# hotswap
use strict;
use Term::ExtendedColor qw(fg);

my $config = './config.conf';
our @c;

print "> ";
while(chomp(my  $line = <STDIN>)) {
  if($line =~ /^r/) {
    delete($INC{'config.conf'});
    print Dumper \%INC;
    reload();
  }
  print "> ";
}


sub reload {
  require 'config.conf';
  for my $fg(@c) {
    print fg($fg, $fg), "\n";
  }
}
