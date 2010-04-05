#!/usr/bin/perl
use strict;
# randwall
use List::Util qw(shuffle);

my $wdir = '/mnt/Docs/Wallpapers/3360x1050';
opendir(my $walls, $wdir) or die "Cant open $wdir: $!\n";
my @walls = readdir($walls);
@walls = shuffle(@walls);

system("feh --bg-center \"$wdir/$walls[0]\"");
