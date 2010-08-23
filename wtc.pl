#!/usr/bin/perl
# wtc - get random retarded commit msgs
use strict;
use LWP::Simple;

for(get('http://whatthecommit.com/')) {
  if(m;<p>(.+)\n</p>;) {
    print $1,"\n";
  }
}
