#!/usr/bin/perl
# scpan
use strict;
use LWP::Simple;
use HTML::FormatText::Lynx;
use Term::ExtendedColor qw(fg);

my $base_url = 'http://search.cpan.org/search?query=';
my $search = shift // 'woldrich';

my $html = get("$base_url$search&mode=all&n=100");
my @result = split(/\n/, HTML::FormatText::Lynx->format_string($html));

for(@result) {
  last if /^References/;
  s/^\[\d+\](\S+::\S+)+/fg('bold', fg('blue4', $1))/e;

  print "$_\n";

}

