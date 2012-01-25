#!/usr/bin/perl
use strict;
use utf8;
use open qw(:utf8 :std);

use charnames qw(:full);

my $pattern = shift // '.+';

for my $u(0x000 .. 0x10ffff) {
  my $charname = charnames::viacode($u);
  printf("%s %s %s\n", $u, chr($u), $charname) if $charname =~ m/$pattern/i;
}
