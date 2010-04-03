#!/usr/bin/perl
use strict;
# flexget parser

my $flexlog = "/home/scp1/.flexget.log";

open(LOG,$flexlog) || die "$flexlog does not exist?!\n";
my @releases = <LOG>;
close(LOG);

my @episodes;

foreach(@releases) {
	next unless (/Downloading:/);
	s/\w+\s+\w+\s+\w+: //;
		if($_ =~ /(S[0-9]+)?(E[0-9]+)?(.*TV)/) {
			push(@episodes, $_);
    }
}

printf("%25s\n",'DAGENS AVSNITT');
print "-"x40, "\n";
foreach my $rel(sort(@episodes)) {
  chomp($rel);
  $rel = "\033[38;5;114m$rel \033]0m" if $rel =~ /fringe/i;
  $rel = "\033[38;5;121m$rel \033[0m" if $rel =~ /house/i;
  $rel = "\033[38;5;126m$rel \033[0m" if $rel =~ /do(c|k?)u(ment.+)?|
                                                          granskning|
                                                          discovery/ix;
  $rel = "\033[38;5;190m$rel \033[0m" if $rel =~ /SWE(DISH)?/i;
  $rel = "\033[38;5;203m$rel \033[0m" if $rel =~ /mythbusters/i;
  $rel = "\033[38;5;056m$rel \033[0m" if $rel =~ /the\.real\.hustle/i;
  $rel = "\033[38;5;137m$rel \033[0m" if $rel =~ /simpsons/i;
  $rel = "\033[38;5;119m$rel \033[0m" if $rel =~ /smallville/i;
  $rel = "\033[38;5;242m$rel \033[0m" if $rel =~ /(WWE|UEFA|UFC).+/;
  $rel = "\033[38;5;244m$rel \033[0m" if $rel =~ /letterman|ferguson/i;
  $rel = "\033[38;5;108m$rel \033[0m" if $rel =~ /S[0-9]{2}E[0-9]{2}/i;
  print $rel, "\n";
}
