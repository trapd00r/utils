#!/usr/bin/perl

use strict;

# The command line arguments are:

#   xtfix 004000         set bgcol to greenish
#   xtfix 000000 555555  set bgcol to a random color between the two given values
#   xtfix -r             reset the terminal (useful after 'cat /bin/sh' :-)
#   xtfix -f4            choose font size (3-6 are ok)

# Default args (subtle random shade, reset, font 4):

my $args = "@ARGV" || "080808 202020 -r -f4";

# Basic color map, feel free to edit:

my @cols = qw(000000 cc6666
        33cc66 cc9933
        3366cc cc33cc
        33cccc cccccc
        666666 ff6666
        66ff66 ffff66
        6699ff ff66ff
        1c1c1c 2c2c2c
        3a3a3a 121212
        111111 131313
        33ffff ffffff);


# Full reset

print "\033c" if $args =~ s/-r//;

# Select font

print "\033]50;#$1\007" if $args =~ s/-f(\d)//;

# Parse the 'black' value

my @ofs = map hex, $args =~ /([0-9a-f]{2})/gi;
if(@ofs>3) {
    $ofs[$_] = $ofs[$_] + rand($ofs[$_+3]-$ofs[$_])
  for 0..2;
}

for my $i(0..15) {
    my $c = $cols[$i];
    my $Z;
    $c =~ s{..}{
  my $a = hex $&;
  my $b = $ofs[$Z++];
  sprintf("%02x", $a + $b - ($a*$b)/255);
    }ge;
    printf "\033[%d;3%dm(%d)", $i/8, $i&7, $i if $args =~ /show/;
    print "\033]4;$i;#$c\007";
    print "\033]11;#$c\007" if !$i;   # 0 is also 'background color'
    print "\033]10;#$c\007" if $i==7; # 7 is also 'plain foreground color'
}


