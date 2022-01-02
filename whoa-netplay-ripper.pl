#!/usr/bin/perl
# vim: ft=perl:fdm=marker:fmr=#<,#>:fen:et:sw=2:
# abstract: download all netplays from whoa.nu
use strict;
use warnings FATAL => 'all';
use vars     qw($VERSION);
use autodie  qw(:all);

use utf8;
use open qw(:std :utf8);

my $APP  = 'whoa-netplay-ripper';
$VERSION = '0.001';

use Data::Dumper;

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

use Mojo::UserAgent;

my $ua = Mojo::UserAgent->new->max_redirects(3);

$|++;
my $save_urls_to_file = "$ENV{HOME}/netplays.txt";
open(my $fh, '>>', $save_urls_to_file) or die $!;

my $netplay_main_url = 'http://blog.whoa.nu/netplay-arkivet/';
my @netplays;
for my $href(@{ $ua->get($netplay_main_url)->result->dom->find('a')->map(attr => 'href')->to_array }) {
	if(defined $href  and $href !~ m{^[.]{2}[/]}) {
		push(@netplays, $href);
	}
  else {
    next unless defined $href;
    $href =~ s{^[.]{2}[/]}{http://blog.whoa.nu/};
    grab_dl_link($href);
  }
}

sub grab_dl_link {
  my $netplay_url = shift;
  my $downloader = Mojo::UserAgent->new;
  for my $u($downloader->get($netplay_url)->result->dom->find('a')->map(attr => 'href')) {
    for my $vafan(@{$u}) {
      if(defined $vafan and $vafan =~ m{[.]zip}i) {
        print STDOUT "$vafan\n";
        print $fh "$vafan\n";
      }
    }
  }
}

