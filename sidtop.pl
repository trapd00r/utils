#!/usr/bin/perl
# <3 dunz0r
use strict;
use LWP::Simple;
use Data::Dumper;


sub fav {
  my %top100 = ();
  for(split(/\n/, get("http://www.c64.org/HVSC/DOCUMENTS/Creators.txt"))) {
    m;\s*([0-9]+)+.+(/MUSICIANS/.+\.sid);;
    $top100{$1} = $2;
  }
  return(\%top100);
}

sub play {
  my $sids = fav();
  for my $n(sort {$b <=> $a} (keys(%$sids))) {
    printf("\e[1m%3d\e[0m %s\n", $n, $sids->{$n})
      unless($n == 0);

  }
  print "\e[1m Top100 sid tracks, descending\e[0m\n";
  print "Pick a song kkthx: \e[1m";
  chomp(my $choice = <STDIN>);
  print "\e[0m\n";
  my $song = get("http://www.c64.org/HVSC/$sids->{$choice}");

  open(my $fh, '>', "/tmp/$$.sid") or die($!);
  print $fh $song;
  close($fh);

  system("sidplay2", "/tmp/$$.sid");
}

play();

