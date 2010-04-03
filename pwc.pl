#!/usr/bin/perl 
use strict;
# pwc - perl weather client
use Getopt::Long;
use Weather::Google;

our $irc;
GetOptions(
  'irc'   => \$irc,
);

my @towns = @ARGV;

if(!@ARGV) {
  print "Specify town(s).\n";
}

# In case we need more then one 
my @gobjects;

my %data;
foreach my $town(@towns) {
  push @{$data{$town}}, Weather::Google->new($town)->current(
                                                             'temp_c',
                                                             'condition',
                                                             'humidity',
                                                             'wind_condition',
                                                             );
}
my $town;
my @data;
foreach $town(sort keys %data) {
  @data = @{$data{$town}};
  foreach my $line (@data) {
      if(!defined($line)) {
          $line = "undef";
      }
  }
  # I'm lazy
  if(!$irc) {
      print "\033[31;1m",ucfirst($town),"\033[0m\n";
      print "Celsius: $data[0]°C\n";
      print "Condition: $data[1]\n";
      print "$data[2]\n";
      print "$data[3]\n";
  }
  else {
      # skummeslövsstrand
      # The idea was to use %${lenght}s, but if that should work I'll have to
      # figure out the longest string in @ARGV, which is simple, but I doubt
      # that I'll get the formatting good anyway - therefore I leave it like
      # this for now.
      printf("%0s %0s %0s %0s %0s\n", '·',ucfirst($town).':', "$data[0]°C",
             "[$data[1]]","| $data[3]");
  }
}
