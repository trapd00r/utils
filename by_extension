#!/usr/bin/perl
# Fetch filetype information based on extensions
use strict;
use LWP::Simple;
use Storable;
use Data::Dumper;
$Data::Dumper::Terse     = 1;
$Data::Dumper::Indent    = 1;
$Data::Dumper::Useqq     = 1;
$Data::Dumper::Deparse   = 1;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;

my $url = 'http://www.cryer.co.uk/file-types/';

$|++;
my %extensions;

if(-f './filetypes') {
  %extensions = %{ retrieve('./filetypes') };
}

#   <li><a href="bkp.htm">.bkp</a> - backup file</li>

else {
  for('a' .. 'z') {
    my $c = get("$url/$_/index.htm");
    for my $l(split(/<li>/, $c)) {
      if($l =~ m/<a href=".+">[.](.+)<\/a> - (.+)<\/li>/) {
        $extensions{$1} = $2;
      }
    }
  }
  store(\%extensions, './filetypes');
}

for my $e(sort(keys(%extensions))) {
  printf("% 7s: %s\n", $e, $extensions{$e});
}
