#!/usr/bin/perl
use strict;

for(`acpi`) {
  s/Battery 0: (.).+, ([0-9]+)%.+\n/$1/;
  if($1 eq 'D') {
    print "◀▪$2";
  }
  else {
    print "▪▶$2";
  }
}
