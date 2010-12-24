#!/usr/bin/perl
# uncompress gzipped bitches with regex
s;^([^']+\.(?:gz|Z))\z;zcat "$1"|;xs for @ARGV; print while <>;
