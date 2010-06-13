#!/usr/bin/perl
# stumpdump

my $fname = int(rand(100));
system("stumpish dump-desktop-to-file $fname");
my $foo = <STDIN>;
system("stumpish restore-from-file $fname && rm \$HOME/$fname");
