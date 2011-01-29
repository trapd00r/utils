#!/usr/bin/perl
use strict;
# fimpc.. using fifos to control mpd using mpc. PoC.

sub readFifo {
  my $FIFO = shift;
  while(1) {
    unless(-p $FIFO) {
      unlink $FIFO;
      system('mknod', $FIFO, 'p');
    }
    open(FIFOR, "< $FIFO") or die "Cannot read $FIFO: $!\n";
    while(<FIFOR>) {
      my $cmd = $_;
      system("mpc $cmd");
    }
  }
}

&readFifo('/tmp/tompc');
