#!/usr/bin/perl
use strict;

my @c = map { sprintf("\e[38;5;%dm", $_) } (0..15);
my $ws = ' ';

my $color = {
  0  => sprintf("%12s", 'black'),
  8  => sprintf("%12s", 'bright black'),
  1  => sprintf("%12s", 'red'),
  9  => sprintf("%12s", 'bright red'),
  2  => sprintf("%12s", 'green'),
  10 => sprintf("%12s", 'bright green'),
  3  => sprintf("%12s", 'yellow'),
  11 => sprintf("%12s", 'bright yellow'),
  4  => sprintf("%12s", 'blue'),
  12 => sprintf("%12s", 'bright blue'),
  5  => sprintf("%12s", 'magenta'),
  13 => sprintf("%12s", 'bright magenta'),
  6  => sprintf("%12s", 'cyan'),
  14 => sprintf("%12s", 'bright cyan'),
  7  => sprintf("%12s", 'white'),
  15 => sprintf("%12s", 'bright white'),
};

for(my $i = 0; $i < 15; $i++) {
  my $j = (2 * 16) - ($i * 2);
  my $ci = $i;
  if($ci == 15) {
    $ci = 0;
  }

  printf("%s%s%s%s\e[m%s%s%s%s\e[m%s%s\n",
    $c[ $ci ],    $ws x $i,  $c[$ci + 0],
    ($color->{$i} =~ m/bright/) ? "\e[1m$color->{$i}\e[m" : $color->{$i},

    $c[$ci], $ws x $j, $c[$ci + 0],
    ($color->{$i} =~ m/bright/) ? "\e[1m$color->{$i}\e[m" : $color->{$i},
    $c[$ci], $ws x $i,
  );
}

for(my $k = 15; $k > -1; $k--) {
    my $j = (2 * 16) - ($k * 2);
    my $ci = $k;
    if($ci == 0) {
      $ci = 15;
    }
  printf("%s%s%s%s\e[m%s%s%s%s\e[m%s%s\n",
    $c[ $ci ],    $ws x $k,  $c[$ci + 0],
    ($color->{$k} =~ m/bright/) ? "\e[1m$color->{$k}\e[m" : $color->{$k},
    $c[$ci], $ws x $j, $c[$ci + 0],
    ($color->{$k} =~ m/bright/) ? "\e[1m$color->{$k}\e[m" : $color->{$k},
    $c[$ci], $ws x $k,
  );
}
