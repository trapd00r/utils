#!/usr/bin/perl
use strict;
# convert
use Getopt::Long;

usage() unless(@ARGV);

our ($opt_d2b, $opt_d2o, $opt_d2h, $opt_hd, $opt_od, $opt_bd, @to_ascii);
GetOptions('db'   =>  \$opt_d2b,
           'do'   =>  \$opt_d2o,
           'dh'   =>  \$opt_d2h,
           'hd'   =>  \$opt_hd,
           'od'   =>  \$opt_od,
           'bd'   =>  \$opt_bd,
           );

my $int = shift;
print convert($int), "\n";

sub convert { 
  my $int = shift;
  return sprintf("%b",$int, $int) if $opt_d2b;
  return sprintf("%o",$int, $int) if $opt_d2o;
  return sprintf("%x",$int, $int) if $opt_d2h;
  return hex($int) if $opt_hd;
  return oct($int) if $opt_od;
  return oct("0b$int") if $opt_bd;
}

sub usage {
  print << "USAGE";
  USAGE: $0 [OPTIONS] integer
    OPTIONS:
      -db decimal to binary
      -do decimal to octal
      -dh decimal to hexadecimal
      -hd hexadecimal to decimal
      -od octal to decimal
      -bd binary to decimal

USAGE
exit(0);
}
