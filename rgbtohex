#!/usr/bin/perl
# Converts the X11 colortable RGB Values to hexadecimal
use strict;
my $rgbfile = "/usr/share/X11/rgb.txt";
open(RGB,"<", $rgbfile) or die;
while(my $rgb = <RGB>) {
  if($rgb =~ /(\d+ \d+ \d+)/) {
    my $rgbstring = $1;
    my ($r,$g,$b) = split(/\s/, $rgbstring);
    printf("%x %x %x | %12s", $r, $g, $b, $rgb);
  }
}
close(RGB);
