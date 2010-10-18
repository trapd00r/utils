#!/usr/bin/perl
# xbmc-tv
use strict;
use File::Path 'make_path';
use File::Copy;

my $basedir = '/mnt/TV_1';
my $log      = "$ENV{HOME}/.mvtv.log";

for(glob('/mnt/TV_1/.new/*')) {
  if(m/(.+)\.S[0-9]+.+/) {
    my $show = $1;
    $show =~ s;.+/(.+);$1;;

    my ($full_ep) = $_ =~ m;.+/(.+)$;;

    if(!-d "$basedir/$show") {
      if(make_path("$basedir/$show", 1, 0777)) {
        print localtime(time) . "\tmake_path: $basedir/$show\n";
      }
      else {
        print localtime(time) . "\tERROR: $!\n";
      }
    }
    if(move("$_", "$basedir/$show/$full_ep")) {
      print localtime(time) . "\t$_ => $basedir/$show/$full_ep\n";
    }
    else {
      print localtime(time) . "\t$!\n";
    }
  }
}
