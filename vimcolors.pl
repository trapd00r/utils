#!/usr/bin/perl
use strict;
use Data::Dumper;

my $theme = shift // "$ENV{HOME}/.vim/colors/neverland.vim";
open(my $fh, '<', $theme) or die($!);
my @th = <$fh>;
close($fh);

my %theme;
for my $line(@th) {
  next unless($line =~ /^\s+hi /);
  my($sp,$hi,$thing,$fg,$bg,$attr) = split(/\s+/, $line);
  my ($color) = $fg =~ m/=(\d+)$/;
  $theme{$thing} = $color;
}

for(sort(keys(%theme))) {
  print "\033[38;5;$theme{$_}m $_\n";
}
