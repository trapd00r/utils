#!/usr/bin/perl
# svtplay.pl
# dependencies: rtmpdump,mplayer

use strict;
use LWP::Simple;

my %shows = (
  vtd => {
    name  => 'Vem tror du att du är?',
    url   => 'http://svtplay.se/t/106474/vem_tror_du_att_du_ar_',
  },
  ibis    => {
    name  => 'Ingen bor i skogen',
    url   => 'http://svtplay.se/t/132050/ingen_bor_i_skogen',
  },
  hsr     => {
    name  => 'Hemliga svenska rum',
    url   => 'http://svtplay.se/t/102776/hemliga_svenska_rum',
  },
  merlin  => {
    name  => 'Merlin',
    url   => 'http://svtplay.se/t/104065/merlin',
  },
  vml     => {
    name  => 'Världens modernaste land',
    url   => 'http://svtplay.se/t/133773/varldens_modernaste_land',
  },
  hh      => {
    name  => 'Hemma hos',
    url   => 'http://svtplay.se/t/134698/premiar__hemma_hos_caroline_af_ugglas',
  },
  et      => {
    name  => 'Engelska trädgårdar',
    url   => 'http://svtplay.se/t/104829/engelska_tradgardar',
  },
  ub      => {
    name  => 'Undercover boss',
    url   => 'http://svtplay.se/t/134508/seriestart__undercover_boss',
  },
  fotc    => {
    name  => 'Flight of the Conchords',
    url   => 'http://svtplay.se/t/103576/flight_of_the_conchords',
  },
  philo   => {
    name  => 'Philofix',
    url   => 'http://svtplay.se/t/102709/philofix',
  },
  aps     => {
    name  => 'Allsång på skansen',
    url   => 'http://svtplay.se/t/102897/allsang_pa_skansen',
  },
  fangad  => {
    name  => 'Fångad',
    url   => 'http://svtplay.se/t/134122/fangad',
  },
  it      => {
    name  => 'In treatment',
    url   => 'http://svtplay.se/t/110255/in_treatment',
  },
  rapport => {
    name  => 'Rapport',
    url   => 'http://svtplay.se/t/103261/rapport',
  },
);

my $show = shift;

if(!$show or !defined($shows{$show})) {
  usage()
}
my $mp   = 'mplayer -cache 400';
my $url  = $shows{$show}{url};

my @content = split(/\n/,get("$url")) or die();


my $rtmp = undef;
for(@content) {
  if($_ =~ s;.+(rtmp.+\.mp4).+;;) {
    $rtmp = "'$1'";
    last;
  }
}

sub usage {
  print << "USAGE";
  USAGE: $0 show

  SHOWS:
USAGE
  for my $shn(keys(%shows)) {
    printf("\033[1m\033[33m%10s\033[0m : %s\n", $shn, $shows{$shn}{name});
  }
  exit(0);
}

system("rtmpdump -r $rtmp|$mp -");
