#!/usr/bin/perl
use strict;
#mail

my @details = @ARGV;
my $acc = "gmail";

&interactive if !@ARGV;

sub mail {
  my ($subject, $body, $rec) = @_;
  $rec = "trapd00r\@trapd00r.se" unless $rec;
  my $content = sprintf("Subject:$subject\n\n$body\n");
  system("printf \"$content\"|msmtp -a $acc \"$rec\"");
  print "Status: $?\n";
}
&mail(@details);

sub interactive {
  print "Subject: ";
  my $subject = <STDIN>;
  print "Body: ";
  my $body    = <STDIN>;
  print "Mail: ";
  my $rec     = <STDIN>;
  chomp($subject,$body,$rec);
  my $content = sprintf("Subject:$subject\n$body\n");
  system("printf \"$content\"|msmtp -a $acc \"$rec\"");
  print "Status: $?\n";
}

