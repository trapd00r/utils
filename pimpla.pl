#!/usr/bin/perl
# PIMPLA - Perl Interface for Mplayer. Just poc using fifos.
use strict;
my $fifo = "/home/scp1/.mplayer/fifo";
my %commands = ('fs'    =>  'vo_fullscreen',
                'stop'  =>  'stop',
                'pause' =>  'pause',
                'soff'  =>  'mute 1',
                'son'   =>  'mute 0',
                'fstep' =>  'frame_step',
                'osd'   =>  'osd',
               );

if(!@ARGV) {
  foreach my $choice(sort(keys(%commands))) {
    printf("%6s %s\n", $choice, $commands{$choice});
  }
}

my $cmd = shift;
&talk($commands{$cmd});

sub talk {
  my $cmd = shift;
  open(FIFO,'>',$fifo) or die $!;
  print FIFO $cmd, "\n";
  close(FIFO);
}
