#!/usr/bin/perl 
use strict;
# crossmake - Makes cross's in all kinds of shapes and colors

use encoding 'utf8';
use Getopt::Long;
use List::Util qw(shuffle);

our($color,$char,$space,$size);
GetOptions('color!'   =>  \$color,
           'char=s'   =>  \$char,
           'space=s'  =>  \$space,
           'size=i'   =>  \$size,
           'help'     =>  \&help,
          );
my @colors;

for(my $i=0;$i<256;$i++) {
    push(@colors, "\033[38;5;$i"."m");
}

my @chars = qw([♥] ♥ o O x X);
my @space = ('▇', '▕', '#');
@chars = shuffle(@chars);
@space = shuffle(@space);

my $token = $char  // $chars[0];
my $ws    = $space // $space[0];
my $count = $size  // 8;
my $c = "\033[0m";
for(my $i=0; $i<$count; ++$i) {
  if($i%2==0) {
    @colors = shuffle(@colors);
    $c = $colors[0] unless(!$color);
  }
  else {
    @colors = shuffle(@colors);
    $c = $colors[0] unless(!$color);
  }
  my $j = 2 * $count - $i * 2;
  print $c, $ws x $i, $token, $ws x $j, $token, $ws x $i, "\n";
}
for(my $i=$count; $i>0; --$i) {
  if($i%2==0) {
    @colors = shuffle(@colors);
    $c = $colors[0] unless(!$color);
  }
  else {
    @colors = shuffle(@colors);
    $c = $colors[0] unless(!$color);
  }
  my $j = 2 * $count - $i * 2;
  print $c, $ws x $i, $token, $ws x $j, $token, $ws x $i, "\n";
}

sub help {
  print << "HLEP";
  USAGE
    $0 [OPTIONS]
  OPTIONS
    --(no)color
    --char      char
    --space     " "
    --size      size of painting
HLEP
exit 0;
}

