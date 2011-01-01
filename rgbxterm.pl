#!/usr/bin/perl
use strict;
use Term::ExtendedColor;
use Term::ExtendedColor::Xresources;

sub all {
  my $c = get_xterm_colors( [0 .. 255] );

  my $end = int(256/16);

  my @o;
  for my $index(sort{$a <=> $b} (keys(%{ $c }))) {
    print fg('bold', sprintf("%3d ", $index)),
      fg($index, $c->{$index}->{rgb}), "\n";
  }
}
