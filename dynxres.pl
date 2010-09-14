#!/usr/bin/perl
use strict;
use feature 'say';
use Getopt::Long;

my $DEBUG = 1;

our($opt_r_step, $opt_g_step, $opt_b_step) = (10) x 3;
our $opt_hex = '000000';
our $opt_include_ansi = 17;  # Start from 17
our $opt_include_grey = 231; # End at 231
our $opt_ansi_only    = 0;

GetOptions(
  'hex:s'     => \$opt_hex,
  'red:i'     => \$opt_r_step,
  'g|green:i' => \$opt_g_step,
  'blue:i'    => \$opt_b_step,
  'ansi'      => \$opt_include_ansi,
  'grey'      => \$opt_include_grey,
  'ansi-only' => \$opt_ansi_only,
);

say "R Step: $opt_r_step";
say "G Step: $opt_g_step";
say "B Step: $opt_b_step";
say "ANSI: $opt_include_ansi";
say "GREY: $opt_include_grey";

set_shade(make_shade());

sub set_shade {
  my @colors = @_;

  my $i = $opt_include_ansi;

  #open(OLD_STDOUT, '>&', STDOUT) or die("Can not dupe STDOUT: $!");
  for my $color(@colors) {
    my ($r, $g, $b) = $color =~ /(..)(..)(..)/;
    printf("\e]4;$i;rgb:$r/$g/$b\e\\");
    $i++;
  }
}

sub make_shade {
  my @tint = ();
  my ($r, $g, $b) = $opt_hex =~ /(..)(..)(..)/; #FIXME

  $opt_include_ansi == 0   if($opt_include_ansi == 1); # Include ANSI
  $opt_include_grey == 255 if($opt_include_grey == 1); # Include greyscale

  for my $color($opt_include_ansi .. $opt_include_grey) {

    $r = (($r + $opt_r_step) < (255 - ($opt_r_step + $r)))
      ? ($r + $opt_r_step)
      : (255 - ($opt_r_step++))
      ;

    $g = (($g + $opt_g_step) < (255 - ($opt_g_step + $g)))
      ? ($g + $opt_g_step)
      : (255 - ($opt_g_step++))
      ;

    $b = (($b + $opt_b_step) < (255 - ($opt_b_step + $b)))
      ? ($b + $opt_b_step)
      : (255 - ($opt_b_step++))
      ;

    my $hex_r = sprintf("%02x", $r);
    my $hex_g = sprintf("%02x", $g);
    my $hex_b = sprintf("%02x", $b);

    do {
      say "\e[1m$hex_r$hex_g$hex_b\e[0m";
      say "\e[38;5;160m0xR\e[0m: $hex_r";
      say "\e[38;5;148m0xG\e[0m: $hex_g";
      say "\e[38;5;033m0xB\e[0m: $hex_b";
    } if($DEBUG);

    push(@tint, $hex_r . $hex_g . $hex_b);

  }
  return(@tint);
}
