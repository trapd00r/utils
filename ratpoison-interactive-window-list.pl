#!/usr/bin/perl -w

# Interactive window list replacement for ratpoison's "windows"
# command, needs either ratmenu or ratmen. For UTF-8 support either
# ratmenu version 2.3.20 or higher, or ratmen with the UTF-8 patch
# from http://www.rubyist.net/~rubikitch/computer/ratmen/i18n.patch
# are necessary.
#
# Copyright (C) 2008-2010 by Axel Beckert, licensed under the GPLv3

use strict;

### CONFIG

my @ratmenu_options = (qw(-font 6x13),
           qw(-fg tan -bg black -style dreary),
           );
my @ratmen_options = (qw(-F 6x13bold),
          qw(--foreground tan --background black -s dreary),
          '-t', 'ratmen: ratpoison window list');

### COMMANDLINE OPTIONS

my $type = 'windows';
my $select = 'select';
if ($ARGV[0] and $ARGV[0] eq '-g') {
    $type = 'groups';
    $select = 'gselect';
}

### CODE

# Read original window list -- Could be done more elegant
my @windowlist = split(/\n/, `ratpoison -c $type`);

# Check if there are any windows, if not simulate ratpoison's
# behaviour

if ($#windowlist == 0 and $windowlist[0] !~ /^\d/) {
    exec('ratpoison', '-c', "echo No managed $type");

# Else create a window list sorted and suitable for ratmenu
} else {
    my %windowlist = map { /^(\d+)/ => $_ } @windowlist;
    @windowlist = map { $windowlist{$_} => "ratpoison -c '$select $_'" }
      sort { $a <=> $b }
      keys %windowlist;

    # Search window which would be next by default
    my $io = 0;
    my $found = 0;
    for my $i (@windowlist) {
  $io++ if $i =~ /^\d/;
  if ($i =~ /^\d+\+/) {
      $found = 1;
      last;
  }
    }
    $io = 1 unless $found;

    exec('ratmenu', @ratmenu_options, '-io', $io, @windowlist);
#    exec('ratmen', @ratmen_options, '-i', $io, @windowlist);
}
