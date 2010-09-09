#!/usr/bin/perl
# dynamic X resources
use strict;

my $xres_prefix = 'URxvt.india';
my $xresources  = "$ENV{HOME}/configs/.Xresources";

open(my $fh, '<', $xresources) or die($!);
my @data = <$fh>;
close($fh);

chomp(my @colors = grep{/^$xres_prefix\.color/} @data);
map{s/.+(?:UL|RV).+\n//} @colors;
map{s;(/\*.*\*/);;} @colors;
map{s;\s+;\t\t;} @colors;
print "$_\n" for @colors;

#TODO Map color indexes to their ANSI names


my $grey = shift // '1c1c1c';

my @valid_hex = qw(A B C D E F a b c d e f 0 1 2 3 4 5 6 7 8 9);
for(0..15) {
  my @shade;

  my @chars = split(//, $grey);
  for my $foo(@chars) {
    if($foo ~~ @valid_hex) {
      if(($foo =~ m/[0-9]/) and ($foo < 10 and $foo >= 0) or ($foo =~ /[A-Ea-e]/)) {
        $foo++ unless($_ == 0);
      }
      push(@shade, $foo);
    }
  }
  $grey = sprintf("%.6s",join('', @shade));

  #printf("Color resource %2d: ", $_);
  #chomp(my $choice = <STDIN>);
  my $new_c = "$xres_prefix.color$_:  #$grey";
  printf("%30s\n", $new_c);
  system("echo \"$new_c\" | xrdb -merge") == 0 or print($!) and exit(-1);
}
system("echo \"$xres_prefix.color7:  #e5d5dd\"| xrdb -merge");
system("echo \"$xres_prefix.color15:  #ffffff\"| xrdb -merge");
