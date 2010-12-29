#!/usr/bin/perl
package Trapd00r::Linux;
use vars qw($VERSION);
$VERSION = '0.01';

our(@ISA, @EXPORT);
BEGIN {
  require Exporter;
  @ISA = qw(Exporter);
  @EXPORT = qw(temp
               irc_msgs
               im_msgs
               np
               get_remote_load
               get_mem
               get_proc
               len_mod
            );
}

use strict;
use LWP::Simple;
use Audio::MPD;

sub get_mem { # FIXME
  open(my $fh, '<', '/proc/meminfo') or warn($!);
  my ($total,$free,$buffers,$cached) = undef;
  while(<$fh>) {
    if(/^MemTotal:\s+([0-9]+)\s+/) {
      $total = to_mb($1);
    }
    elsif(/^MemFree:\s+([0-9]+)\s+/) {
      $free = to_mb($1);
    }
    elsif(/^Buffers:\s+([0-9]+)\s+/) {
      $buffers = to_mb($1);
    }
    elsif(/^Cached:\s+([0-9]+)/) {
      $cached = to_mb($1);
    }
  }
  my $avail = $free + ($buffers + $cached);
  my $used  = $total - $avail;

  my $mem = $used / $total;
  $mem =~ s/..(..).+/$1/; # :D

  if($mem  >= 5 and $mem <= 10) {
    $used = "^fg(#15e100)$used^fg()";
  }
  elsif($mem  >= 11 and $mem <= 15) {
    $used = "^fg(#5ee100)$used^fg()";
  }
  elsif($mem  >= 16 and $mem <= 20) {
    $used = "^fg(#8ce100)$used^fg()";
  }
  elsif($mem  >= 21 and $mem <= 25) {
    $used = "^fg(#bee100)$used^fg()";
  }
  elsif($mem  >= 26 and $mem <= 30) {
    $used = "^fg(#eid300)$used^fg()";
  }
  elsif($mem  >= 31 and $mem <= 40) {
    $used = "^fg(#e1a100)$used^fg()";
  }
  elsif($mem  >= 41 and $mem <= 50) {
    $used = "^fg(#e17c00)$used^fg()";
  }
  elsif($mem  >= 51 and $mem <= 60) {
    $used = "^fg(#e15800)$used^fg()";
  }
  elsif($mem  >= 61 and $mem <= 70) {
    $used = "^fg(#e13400)$used^fg()";
  }
  elsif($mem  >= 71 and $mem <= 80) {
    $used = "^fg(#e11800)$used^fg()";
  }
  elsif($mem  >= 81 and $mem <= 90) {
    $used = "^fg(#e10013)$used^fg()";
  }
  else {
    $used = "^fg(#ff0000)$used^fg()";
  }
  my $out = sprintf("^fg(#959595)Mem^fg(): %s^fg(#b8e4dd)MB^fg()/^fg(#a7a7a7)%s^fg(#b8e4dd)MB^fg()",
    $used,  $total);

  return $out;
}

sub to_mb {
  my $kb = shift;
  return(sprintf("%d",$kb/1024));
}

sub get_proc {
  opendir(my $dh, '/proc') or warn($!);
  my @processes = grep{/^[0-9]+/} readdir($dh); # PIDs
  return("^fg(#959595)Proc^fg():^fg(#ff0000) " . scalar(@processes));
}

sub get_remote_load {
  my($remote, $user, $port) = @_;

  my %remotes = (
    'dvdc'   => '192.168.1.100',
    'shiva'  => '192.168.1.101',
    'india'  => '192.168.1.102',
    #'n900'   => '192.168.1.112',
    #'wrt'    => '192.168.1.1',
  );

  my $up;
  if($remote ne 'shiva') {
    #print "ssh -p $port $user\@$remotes{$remote} 'uptime'";
    open(my $ssh,
      "ssh -p $port $user\@$remotes{$remote} 'uptime'|")
        or die;# return "$remote down";
    $up = <$ssh>;
  }
  else {
    $up = `uptime`;
  }
  chomp($up);

  my($one, $five, $fifthteen) = $up =~ m/average: (.+),(.+),(.+)/;

  for($one, $five, $fifthteen) {
    s/\s+//;
    $_ = load($_);
  }
  return sprintf("%s, %s, %s", $one, $five, $fifthteen);
}

sub load {
  chomp(my $load = shift);
  if($load < 0.10) {
    $load = "^fg(#33b02e)$load^fg()";
  }
  if($load >= 0.10 and $load <= 0.20) {
    $load = "^fg(#28f809)$load^fg()";
  }
  elsif($load >= 0.21 and $load <= 0.30) {
    $load = "^fg(#f2b30e)$load^fg()";
  }
  elsif($load >= 0.31 and $load <= 0.40) {
    $load = "^fg(#f8d509)$load^fg()";
  }
  elsif($load >= 0.41 and $load <= 0.50) {
    $load = "^fg(#f8b009)$load^fg()";
  }
  elsif($load >= 0.51 and $load <= 0.60) {
    $load = "^fg(#f88e09)$load^fg()";
  }
  elsif($load >= 0.61 and $load <= 0.70) {
    $load = "^fg(#f87209)$load^fg()";
  }
  elsif($load >= 0.71 and $load <= 0.80) {
    $load = "^fg(#f85e09)$load^fg()";
  }
  elsif($load >= 0.81 and $load <= 0.90) {
    $load = "^fg(#f84709)$load^fg()";
  }
  elsif($load >= 0.91 and $load <= 1.00) {
    $load = "^fg(#f82409)$load^fg()";
  }
  elsif($load >= 1.01 and $load <= 1.10) {
    $load = "^fg(#f81609)$load^fg()";
  }
  elsif($load >= 1.11 and $load <= 1.20) {
    $load = "^fg(#ff0003)$load^fg()";
  }
  else {
    $load = "^fg(#ff0000)$load^fg()";
  }
  return($load);
}



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
    return $str;
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
