#!/usr/bin/perl
package Trapd00r::Linux;
use vars qw($VERSION);
$VERSION = '0.01';

our(@ISA, @EXPORT);
BEGIN {
  require Exporter;
  @ISA = qw(Exporter);
  @EXPORT = qw(temp irc_msgs im_msgs np);

}

use strict;
use LWP::Simple;
use Audio::MPD;


sub np {
  my $mpd = Audio::MPD->new(
    host  => $ENV{MPD_HOST},
    port  => $ENV{MPD_PORT},
  );

  my %current;

  $current{artist} = len_mod($mpd->current->artist, 20, '...'),
  $current{album}  = len_mod($mpd->current->album, 25, '...'),
  $current{title}  = len_mod($mpd->current->title, 20, '...'),
  $current{year}   = $mpd->current->date // 1900,

  return \%current;
}

sub len_mod {
  my($str, $max, $replace) = @_;

  if(length($str) > $max) {
    my $len = ($max - 3);
    $str = sprintf("%.${len}s$replace", $str);
    return $str
  }
  return  $str;
}

sub irc_msgs {
  open(my $irc, '-|',
    "ssh -p 19216 scp1\@192.168.1.100 'cat irclogs/global_highlights.log'",
  ) or die($!);
  chomp(my @hl = grep{!/&bitlbee/} <$irc>);

  return (wantarray()) ? @hl : $hl[-1];
}

sub im_msgs {
  open(my $im, '-|',
    "ssh -p 19216 scp1\@192.168.1.100 'cat irclogs/global_highlights.log'",
  ) or die($!);
  chomp(my @hl = grep{/&bitlbee/} <$im>);

  return (wantarray()) ? @hl : $hl[-1];
}

sub temp  {
  my $url  = 'http://temperatur.nu/termo/norrkoping/temp.txt';
  my $temp = 'N/A';

  chomp($temp = get($url)) or die;
  return $temp;
}

1;
