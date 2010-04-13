#!/usr/bin/perl
# dmenuclip.pl
# REALLY nasty... 
use strict;
my $xsels = "/home/scp1/temp/xsels";
my $xclip = `xclip -o`;
open(XSEL_WA, ">>", $xsels) or die "$!\n";
print XSEL_WA "$xclip\n";
close XSEL_WA;
open(XSEL_R, "<", $xsels) or die "Reading: $!\n";
my @lines = <XSEL_R>;
system("printf \$(\\cat $xsels|dmenu)|xclip -i -l 1|xclip -o");
