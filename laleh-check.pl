#!/usr/bin/perl
# laleh-check.pl
# check if string is present in Laleh's lyrics
# 'candle' is present in Closer
# 'and' is present in Call on Me
# 'and' is present in Closer
my $DEBUG = 0;

use strict;
use Audio::MPD;
use feature 'say';
use Data::Dumper;
use Lyrics::Fetcher::LyricWiki;
use utf8;

my $laleh_string = shift // 'bitch';

my $pass = `smokingkills`;

my $mpd = Audio::MPD->new(
  host  => '192.168.1.101',
  port  => 6600,
  pass  => $pass,
);

my %laleh;
my @songs = ();
push(@songs, $_->title) for($mpd->collection->songs_by_artist('Laleh'));

s/(\w+)/\u\L$1/g for @songs;

$laleh{$_} = Lyrics::Fetcher::LyricWiki->fetch('Laleh', $_) for @songs;

print Dumper \%laleh if($DEBUG);

for my $s(keys(%laleh)) {
  if($laleh{$s} =~ /$laleh_string/gi) {
    say "'$laleh_string' is present in $s";
  }
}
