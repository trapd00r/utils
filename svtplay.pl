#!/usr/bin/perl
# svtplay.pl
# dependencies: rtmpdump,mplayer

use strict;
use LWP::Simple;
use XML::Simple;
use Data::Dumper;

my $baserss =
'http://feeds.svtplay.se/v1/video/list/96238?expression=full&mode=plain';


my $foo = XMLin(get($baserss));

my %shows = ();
my $i = 0;
for(keys(%{$foo})) {
  for($foo->{channel}{item}) {
    for(@{$_}) {
      print Dumper $_;
      $shows{$i++} = {
        name  => $_->{title},
        uri   => $_->{link},
        pub   => $_->{pubDate},
      };
    }
  }
}


my $show = shift;

if(!$show || !defined($shows{$show})) {
  usage()
}
my $mp   = 'mplayer -cache 400';
my $url  = $shows{$show}->{uri};

my @content = split(/\n/,get("$url")) or die();


my $rtmp = undef;
for(@content) {
  if($_ =~ s;.+(rtmp.+mp4-d-v1\.mp4).+;;) {
    $rtmp = "'$1'";
    last;
  }
  elsif($_ =~ s;.+(rtmp.+mp4-c-v1\.mp4).+;;) {
    $rtmp = "'$1'";
    last;
  }
}
print ">>>> $rtmp <<<<\n\n";

sub usage {
  print << "USAGE";
  USAGE: $0 show

  \033[1mSHOWS\033[0m:
USAGE

  for my $i(sort{$a <=> $b}(keys(%shows))) {
    printf("[\033[1m%02d\033[0m] \033[30;1m%s\033[0m \033[33m%s\033[0m \n",$i,
      $shows{$i}{pub}, $shows{$i}{name});
  }
  exit(0);
}
system("rtmpdump -r $rtmp|$mp -");
