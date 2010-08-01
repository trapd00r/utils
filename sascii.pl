#!/usr/bin/perl

use strict;
use Term::ReadKey;

ReadMode('cbreak');

while (1) {
    my $char = ReadKey(0);
    printf("%3s - %3d | 0x%x\n",$char, ord($char), ord($char));
}

ReadMode('normal');
