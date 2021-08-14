#!/usr/bin/perl
# abstract: feed the sdorfehs sticky bar
# vim: ft=perl:fdm=marker:fmr=#<,#>:fen:et:sw=2:
use strict;
use warnings FATAL => 'all';
use vars     qw($VERSION);
use autodie  qw(:all);

use utf8;
use open qw(:std :utf8);

use Term::ExtendedColor::Dzen qw(fgd bgd);

use Audio::MPD;
use Time::Date;
use Music::Beets::Info qw(beet_info);
my $mpd = Audio::MPD->new;

use Data::Dumper;

np();

sub np {
  my $data = beet_info("$ENV{XDG_MUSIC_DIR}/" . $mpd->current->file);
#  print Dumper $data;

  $data->{bitrate} = $data->{bitrate}
    ? sprintf "%d", $data->{bitrate} / 1000
    : 0;

  if($data->{original_date}) {
    my $t = Time::Date->new($data->{original_date});
    $data->{original_date} = sprintf("%s", bgd('#ff0000', $t->strftime("%d %B, %Y")));
  }
  else {
    $data->{original_date} = '';
  }

  if($data->{label}) {
    $data->{label} = fgd('#ffff00', $data->{label});
  }
  else {
    $data->{label} = '';
  }
  $data->{format} = lc($data->{format})  unless not defined $data->{format};

  my $goto_album_dir  = sprintf "^ca(1, %s)", 'mpd-goto-album-dir';
  my $goto_artist_dir = sprintf "^ca(1, %s)", 'mpd-goto-artist-dir';
  printf "%s the %s song '%s' by $goto_artist_dir%s^ca() on $goto_album_dir%s^ca() released %s on %s. It's track %s/%s and the bitrate is %s kbps (%s).\n",
    fgd('#ef0e99', bold('▶')),
    white(bold(lc($data->{genre}))),
    bold(fgd('#afaf00', $data->{title})),
    bold(fgd('#afd700', $data->{artist})),
    bold(fgd('#87af5f', $data->{album})),
    bold(nc($data->{original_date})),
    bold($data->{label}),
    nc(defined $data->{track} ? $data->{track} : 0),
    nc(defined $data->{tracktotal} ? $data->{tracktotal} : 0),
    nc($data->{bitrate}),
    $data->{format},
}

sub white {
  return fgd('#fff', shift);
}

sub bold {
  return "^fn('Anonymous Pro:style=Bold:pixelsize=10:antialias=1:hinting=1:hintstyle=3')" . $_[0] . '^fn()';
}

sub italic {
  return "^fn('Anonymous Pro:style=Italic:pixelsize=10:antialias=1:hinting=1:hintstyle=3')" . $_[0] . '^fn()';
}

sub nc {
  return fgd('#0087ff', shift) . fgd();
}

sub fn {
#  return $_[0]
#    ? sprintf("^fn('Anonymous Pro:pixelsize=10:style=bold', $_[0])^fn()")
#    : '^fn()';
}
