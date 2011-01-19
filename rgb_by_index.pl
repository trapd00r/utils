#!/usr/bin/perl
use strict;
use Term::ReadKey;
use Term::ExtendedColor qw(fg);
use Data::Dumper;
$Data::Dumper::Terse     = 1;
$Data::Dumper::Indent    = 1;
$Data::Dumper::Useqq     = 1;
$Data::Dumper::Deparse   = 1;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;


by_index( [0 .. 255] );

sub by_index {
  my $index = shift;

  my @indexes;
  if(ref($index) eq 'ARRAY') {
    push(@indexes, @{$index});
  }
  else {
    push(@indexes, $index);
  }

  open(my $tty, '<', '/dev/tty') or die($!);

  my $colors;

  for my $i(@indexes) {
    ReadMode 'raw', $tty;

    print "\e]4;$i;?\a";

    my $foo = '';
    $foo .= ReadKey 0, $tty for 0..22;
    ReadMode "normal";

    my ($r, $g, $b) = $foo =~ m{
      rgb: ([A-Za-z0-9]{2})
      .*/
      ([A-Za-z0-9]{2})
      .*/
      ([A-Za-z0-9]{2})
      .*
    }x;

    $colors->{$i}->{red}   = $r;
    $colors->{$i}->{green} = $g;
    $colors->{$i}->{blue}  = $b;

    print "xterm index [@{[fg($i, $i)]}] has RGB value [0x$r, 0x$g, 0x$b]\n";
    #print "xterm index <font color=\"#$r$g$b\">$i</font> has RGB value [0x$r, 0x$g, 0x$b]\n<br>";
    #printf("colorcoke --single $r$g$b $i\n");
  }
  return $colors;
}

