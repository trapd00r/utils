#!/usr/bin/perl
# df
# Copyright (C) 2010 Magnus Woldrich <trapd00r@trapd00r.se>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################
use strict;
open(my $df, "df -hT @ARGV|");
my @c = <$df>;
close($df);

my(%disks,$header) = undef;
for my $l(@c) {
  if($l =~ /^Filesystem/) {
    $header = "\033[1m$l\033[0m";
  }
  elsif($l =~ m;/dev/(sd[a-z0-9]+)\s;s) {
    my($dev, $fs,$size,$used,$avail,$proc,$mount) = split(/\s+/, $l);
    $dev = $1; # hehu
    $disks{$dev}{fs}    = $fs;
    $disks{$dev}{used}  = $used;
    $disks{$dev}{size}  = $size;
    $disks{$dev}{avail} = $avail;
    $disks{$dev}{proc}  = $proc;
    $disks{$dev}{mount} = $mount;
  }
}

my $dpf = undef;
for my $dp(sort (keys(%disks))) {
  if($dp =~ m;([a-z]+)([0-9]+);) {
    $dpf = "\033[38;5;148m$1\033[38;5;178m\033[1m$2\033[0m";
  }

  my $proc = $disks{$dp}{proc};
  my $percent = undef;
  for($proc) {
    m/([0-9]+)%/;
    $percent = $1;
    if($percent > 90) {
      $percent = "\033[38;5;196m$percent\033[0m";
    }
    elsif($percent > 75) { 
      $percent = "\033[38;5;202m$percent\033[0m";
    }
    elsif($percent > 50) {
      $percent = "\033[38;5;208m$percent\033[0m";
    }
    elsif($percent > 25) {
      $percent = "\033[38;5;226m$percent\033[0m";
    }
    elsif($percent < 25) {
      $percent = "\033[38;5;148m$percent\033[0m";
    }
    elsif($percent < 10) {
      $percent = "\033[38;5;082m afafs $percent\033[0m";
    }
    else {
      $percent = "\033[38;5;244m$percent\033[0m";
    }
  }

  my $size   = $disks{$dp}{size};
  my $nsize  = notate_size($disks{$dp}{size});
  my $nused  = notate_size($disks{$dp}{used});
  my $navail = notate_size($disks{$dp}{avail});
  #for($size) {
  #  m/([0-9]+)(.)/;
  #  $nsize = $1;
  #  $notation = $2;
  #  if($notation eq 'M') { $notation = "\033[38;5;240m$notation\033[0m" }
  #  elsif($notation eq 'G') { $notation = "\033[38;5;248m$notation\033[0m" }
  #  elsif($notation eq 'T') { $notation = "\033[38;5;250m$notation\033[0m" }
  #  else { $notation = "\033[38;5;100m$notation\033[0m" }

  #  $nsize = "\033[38;5;184m$nsize\033[0m" . "\033[1m$notation\033[0m";
  #}

  printf("\033[1m%6s\033[0m \033[38;5;233m▏\033[38;5;29m%s \033[38;5;233m▏\033[38;5;244m%42s \033[38;5;202m%42s \033[38;5;192m%42s \033[38;5;148m%17s\033[0m% <\033[38;5;191m\033[1m%s \033[0m\n", 
    $disks{$dp}{fs}, $dpf,
    $nsize, $nused,
    $navail,$percent,
    $disks{$dp}{mount}
  ) unless(!defined($disks{$dp}{mount}));
}

sub notate_size {
  my $str = shift;
  my($nsize,$notation) = (undef);

  for($str) {
    m/([0-9]+)(.)/;
    $nsize = $1;
    $notation = $2;

    if($notation eq 'M') { 
      $notation = "\033[38;5;070m$notation\033[0m";
      $nsize = "\033[38;5;191m$nsize\033[0m" . "\033[1m$notation\033[0m";
    }
    elsif($notation eq 'G') {
      $notation = "\033[38;5;202m$notation\033[0m";
      $nsize = "\033[38;5;220m$nsize\033[0m" . "\033[1m$notation\033[0m";
    }

    elsif($notation eq 'T') {
      $notation = "\033[38;5;112m$notation\033[0m";
      $nsize = "\033[38;%;196m$nsize\033[0m" . "\033[1m$notation\033[0m";
    }
    else {
      $notation = "\033[38;5;100m$notation\033[0m";
    }
  }
  return($nsize);
}
