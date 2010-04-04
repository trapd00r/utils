#!/usr/bin/perl
use strict;
#mail
use Getopt::Long;

&interactive if !@ARGV;
our $opt_stdin;
GetOptions(stdin  =>  \$opt_stdin);

my @details = @ARGV;
my $acc = "gmail";
my $def_Rec = "trapd00r\@trapd00r.se";


&readStdin if $opt_stdin;

sub readStdin {
  my @body;
  while(<>) {
    push(@body, $_);
  }
  my $body = join/\n/, @body;
  my $rec  = $def_Rec;
  my $subject = 'stdin';
  my $content = sprintf("Subject:$subject\n\n$body\n");
  system("printf \"$content\"|msmtp -a $acc \"$def_Rec\"");
  print "Status: $?\n";
  exit 0;
}
  
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

