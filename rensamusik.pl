#!/usr/bin/perl
# rensamusik

use strict;
my $DEBUG = 0;

my $base = shift // '/mnt/Music_';
my @ignores = qw(
  00-Random
);

for my $n(1,3,4,5,6,7) {
  my $next;

  ($n == 7) ? $next = 1 : $next = $n + 1;
  $next = 3 if $next == 2;
  $next = 1 if $next > 7;

  for my $nn(1,3,4,5,6,7) {
    for my $c('A' .. 'Z', 'VA', 'FLAC', 'Not_Scene') {
      printf("\e[1m\e[38;5;148m%s \e[38;5;196m%s\e[0m\n",
        "$base$nn/$c  =>  ", "/mnt/Music_$next/$c") if($DEBUG);
      system("diff -i $base$nn/$c /mnt/Music_$next/$c|grep -v Only|grep -v @ignores|awk '{print \$3}'");
    }
  }
}
