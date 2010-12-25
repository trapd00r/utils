#!/usr/bin/perl
package Trapd00r::Linux;
use vars qw($VERSION);
$VERSION = '0.01';

our(@ISA, @EXPORT);
BEGIN {
  require Exporter;
  @ISA = qw(Exporter);
  @EXPORT = qw(temp irc_msgs);

}

use strict;
use warnings;
use LWP::Simple;

sub irc_msgs {
  open(my $irc, '-|',
    "ssh -p 19216 scp1\@192.168.1.100 'cat irclogs/global_highlights.log'",
  ) or die($!);
  chomp(my @hl = <$irc>);

  return (wantarray()) ? @hl : $hl[-1];
}

sub temp  {
  my $url  = 'http://temperatur.nu/termo/norrkoping/temp.txt';
  my $temp = 'N/A';

  chomp($temp = get($url)) or die;
  return $temp;
}

1;
