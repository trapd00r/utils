#!/usr/bin/perl
#mail
use strict;

if(!@ARGV) {
  print STDERR "$0 <subject> <body> <email>\n";
  exit 1;
}
my @details = @ARGV;
my $acc = "gmail";

sub mail {
  my ($subject, $body, $rec) = @_;
  $rec = "trapd00r\@trapd00r.se" unless $rec;
  my $content = sprintf("Subject:$subject\n\n$body\n");
  system("printf \"$content\"|msmtp -a $acc \"$rec\"");
}
&mail(@details);
