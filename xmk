#!/usr/bin/perl
use strict;
use Getopt::Long;
use List::Util 'shuffle';

our($char, $space, $size) = ('$', '$', 8);
GetOptions(
  'char:s'  => \$char,
  'space:s' => \$space,
  'size:i'  => \$size,
);

my @c = ();
for(200..206,233..240) {
  push(@c, "\033[38;5;$_" . 'm');
}
@c = shuffle(@c);

sub square {
  my $i;
  for($i=0; $i< $size; ++$i) {
    my $j = (2 * $size) - ($i * 2);
    my $ci = $i;
    if($ci == scalar(@c-1)) {
      $ci = 0;
    }
    print $c[$ci], $space x $i, $c[$ci+2],$char,$c[$ci],$space x $j,$c[$ci+2],$char,$c[$ci],$space x$i,"\n";
    $ci++;
  }
  my $k = $size;
  for( ; $k > 0; --$k) {
    my $j = (2 * $size) - ($k * 2);
    my $ci = $k;
    if($ci == scalar(@c-1)) {
      $ci = 0;
    }
    print $c[$ci], $space x $k, $c[$ci+2],$char, $c[$ci],$space x $j,$c[$ci+2],$char, $c[$ci],$space x $k, "\n";
    $ci++;
  }
}

square();

