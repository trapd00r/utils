#!/usr/bin/perl
package Trapd00r::Linux::Mail;
use vars qw($VERSION);
$VERSION = '0.01';

our(@ISA, @EXPORT);
BEGIN {
  require Exporter;
  @ISA = qw(Exporter);
  @EXPORT = qw(new_mail get_subject);
}


use strict;
use Carp 'confess';

sub new_mail {
  #my @new_mails = map {
  #  $_ = "/mnt/Docs/Mail/inbox/new/$_";
  #  } glob("/mnt/Docs/Mail/inbox/new/*");

  my @new_mails = glob("/mnt/Docs/Mail/inbox/new/*");

  return (wantarray()) ? @new_mails : scalar(@new_mails);
}

sub get_subject {
  my $mail = shift;

  open(my $fh, '<', $mail)
    or confess("Cant open mail $mail: $!");
  chomp(my @content = <$fh>);

  my($subject, $from) = qw(NULL NOBODY);

  for my $line(@content) {
    if($line =~ m/^Subject: (.+)/) {
      $subject = $1;
      next;
    }
    if($line =~ m/^From: .* <(\S+)>/) {
      $from = $1;
      if($subject) {
        last;
      }
    }
  }

  return ($subject =~ /UTF-8/) ? $from : $subject;
}
