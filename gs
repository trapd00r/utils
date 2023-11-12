#!/usr/bin/perl
# abstract: git status with $LS_COLORS
use strict;
use warnings FATAL => 'all';
use feature 'say';

use File::LsColor qw(ls_color);
use Term::ExtendedColor qw(fg);

use Term::hr {
  char      => '=',   # character to use
  fg        => '137',  # foreground color, fg = default fg color
  bg        => 'bg',  # background color, bg = default bg color
  bold      => 0,     # no bold attribute
  crlf      => 1,     # add a newline to the returned hr
  italic    => 0,     # no italic attribute
  post      => 0,     # post whitespace
  pre       => 0,     # pre whitespace
  reverse   => 0,     # reverse video attribute
  underline => 0,     # underline attribute
  width     => 54,    # total width of the hr
};


my @status = split('\n', `git status --short --show-stash --column=column`);

exit unless scalar @status;

print hr();
for my $line (@status) {
  my ($status, $file) = split(' ', $line, 2);
  printf "%s %s\n", status_color($status), ls_color($file);
}

print hr();

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
