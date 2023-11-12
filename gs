#!/usr/bin/perl
# abstract: git status with $LS_COLORS
use strict;
use warnings FATAL => 'all';
use feature 'say';

use File::LsColor qw(ls_color);
use Term::ExtendedColor qw(fg);

my @status = split('\n', `git status --short --show-stash --column=column`);

for my $line (@status) {
  my ($status, $file) = split(' ', $line, 2);
  printf "%s %s\n", status_color($status), ls_color($file);
}



sub status_color {
  my $status = shift;

  my %colors = (
    '??' => '240',
    'A' => '38;5;166;1',
    'M' => '38;5;178;1',
    'D' => '197',
    'R' => '197',
    'C' => '197',
    'U' => '197',
    ' ' => '100',
  );

  return sprintf "%s", fg($colors{$status}, sprintf("% 2s", $status));
}
