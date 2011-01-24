#!/usr/bin/perl
use strict;
use Data::Dumper;
use Term::ExtendedColor qw(fg);


my $themes = _vim_colors( _get_vim_themes() );

my $previous;
for my $theme(sort(keys(%{$themes}))) {
  for my $tag(sort(keys(%{$themes->{$theme}}))) {
    if($theme ne $previous) {
      $previous = $theme;
      print "\n";
    }
    printf("%20.20s: %s\n", $theme, $tag) if $tag =~ /\[0?m/;
  }
}

sub _vim_colors {
  my @schemes = @_;

  my $theme;
  for my $s(@schemes) {
    open(my $fh, '<', $s) or next;
    while(<$fh>) {
      chomp;
      next unless $_ =~ /^\s+hi /;

      my($basename) = $s =~ m|.*/(.+)\.vim$|;

      my($sp, $hi, $thing, $fg, $bg, $attr) = split(/\s+/, $_);

      my($color) = $fg =~ m/=(\d+)$/;
      $theme->{$basename}->{fg($color, $thing)} = $color;
    }
  }
  return $theme;
}




sub _get_vim_themes {
  return glob("$ENV{HOME}/configs/vim/colors/*.vim");
}
