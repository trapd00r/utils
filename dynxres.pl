#!/usr/bin/perl
use strict;
use feature 'say';
use Getopt::Long;

my $hex = shift // '000000';

our($opt_r_step, $opt_g_step, $opt_b_step) = (15) x 3;

GetOptions(
  'r:i'   => \$opt_r_step,
  'g:i'   => \$opt_g_step,
  'b:i'   => \$opt_b_step,
  'all:i' => sub {shift; ($opt_r_step,$opt_g_step,$opt_b_step) = (shift) x 3;},
);

print "R Step: $opt_r_step\n";
print "G Step: $opt_g_step\n";
print "B Step: $opt_b_step\n";

my($r, $g, $b) = $hex =~ /(..)(..)(..)/;
$r = hex($r);
$g = hex($g);
$b = hex($b);
my @tint;
for my $ansi(0..15) {

  $r = (($r + $opt_r_step) < (255 - ($opt_r_step + $r)))
    ? ($r + $opt_r_step)
    : (255 - ($opt_r_step++));

  $g = (($g + $opt_g_step) < (255 - ($opt_g_step + $g)))
    ? ($g + $opt_g_step)
    : (255 - ($opt_g_step++));

  $b = (($b + $opt_b_step) <= (255 - ($opt_b_step + $b)))
    ? ($b + $opt_b_step)
    : (255 - ($opt_b_step++));

  print "R: $r\n";
  print "G: $g\n";
  print "B: $b\n";

  printf("%x\n", $r);
  printf("%x\n", $g);
  printf("%x\n", $b);


  my $hex_r = sprintf("%02x", $r);
  my $hex_g = sprintf("%02x", $g);
  my $hex_b = sprintf("%02x", $b);
  push(@tint, "$hex_r$hex_g$hex_b");
}

use Data::Dumper;
print Dumper \@tint;

my $i = 0;
for(@tint) {
  system("printf \"URxvt.india.color$i: #$_\n\"|xrdb -merge");
  $i++;
}

