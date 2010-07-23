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

for my $dp(sort(keys(%disks))) {
  printf("[ \033[1m%s\033[0m ] \033[38;5;29m%s \033[38;5;244m %4s \033[38;5;202m%4s\033[38;5;192m%4s \033[38;5;148m%s <\033[38;5;178m%s \033[0m\n", 
    $disks{$dp}{fs}, $dp,
    $disks{$dp}{size}, $disks{$dp}{used},
    $disks{$dp}{avail},$disks{$dp}{proc},
    $disks{$dp}{mount}
  ) unless(!defined($disks{$dp}));
}
