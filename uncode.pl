#!/usr/bin/perl
use vars qw($VERSION);
my $APP  = '';
$VERSION = '0.001';

use strict;
use encoding 'utf8';

my $map = {

  a => "ａ",
  b => "ｂ",
  c => "ｃ",
  d => "ｄ",
  e => "ｅ",
  f => "ｆ",
  g => "ｇ",
  h => "ｈ",
  i => "ｉ",
  j => "ｊ",
  k => "ｋ",
  l => "ｌ",
  m => "ｍ",
  n => "ｎ",
  o => "ｏ",
  p => "ｐ",
  q => "ｑ",
  r => "ｒ",
  s => "ｓ",
  t => "ｔ",
  u => "ｕ",
  v => "ｖ",
  w => "ｗ",
  x => "ｘ",
  y => "ｙ",
  z => "ｚ",

  A => "Ａ",
  B => "Ｂ",
  C => "Ｃ",
  D => "Ｄ",
  E => "Ｅ",
  F => "Ｆ",
  G => "Ｇ",
  H => "Ｈ",
  I => "Ｉ",
  J => "Ｊ",
  K => "Ｋ",
  L => "Ｌ", 
  M => "Ｍ",
  N => "Ｎ",
  O => "Ｏ",
  P => "Ｐ",
  Q => "Ｑ",
  R => "Ｒ",
  S => "Ｓ",
  T => "Ｔ",
  U => "Ｕ",
  V => "Ｖ",
  W => "Ｗ",
  X => "Ｘ",
  Y => "Ｙ",
  Z => "Ｚ",

  0 => "０", 
  1 => "１",
  2 => "２",
  3 => "３",
  4 => "４",
  5 => "５",
  6 => "６",
  7 => "７",
  8 => "８",
  9 => "９",

  '(' => '（',
  ')' => '）',
  '*' => '＊',
  '|' => '｜',
  '^' => '＾',
  '!' => '！',
  '/' => '／',
  '-' => ' －',
  '[' => '［',
  ']' => '］',

  ' ' => "＿",

};

print uncode(<>);

sub uncode {
  for(@_) {
    s/(.)/$map->{$1}/g;
  }
  return @_;
}



=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 OPTIONS

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 REPORTING BUGS

Report bugs on rt.cpan.org or to magnus@trapd00r.se

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


# vim: set ts=2 et sw=2:

