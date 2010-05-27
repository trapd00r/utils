#!/usr/bin/perl
use strict;

chomp(my @gf = `git ls-files`);
chomp(my @rf = glob('*'));
chomp(my $lastcommit = `git --no-pager shortlog|tail -2`);
$lastcommit =~ s/^\s+//;
chomp(my $branchname = `git status|head -1`);
$branchname =~ m/On branch (.+)/;
$branchname = $1;

print "  \033[38;5;226m $branchname\033[0m:\n";
print "\033[38;5;74m=>\033[0m $lastcommit";
for(@gf) {
  if($_ ~~ @rf) {
    print "\033[38;5;100m->\033[0m $_\n" if $_ ~~ @rf;
  }
  else {
    print "\033[38;5;196m:(\033[0m $_\n";
  }
}
