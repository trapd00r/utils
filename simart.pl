#!/usr/bin/perl 
use strict;
# simart - find similar artists

use Audio::MPD;
use LWP::Simple;

my $mpd    = Audio::MPD->new;
my $artist = shift // $mpd->current->artist // undef;
my $url    = "http://ws.audioscrobbler.com/1.0/artist/$artist/similar.txt";

sub fetch_similars {
  if($artist) {
    my @fetched = split/\n/, get($url);
    print "Artists similar to $artist:\n\n";
    s/.+,//g for(@fetched);
    foreach my $sim(@fetched) {
      print $sim, "\n";
    }
  }
  else {
    print "ID3 tag ARTIST missing\n";
    exit 0;
  }
  exit 0;
}

&fetch_similars;
