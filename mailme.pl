#!/usr/bin/perl
use strict;
use Getopt::Long;
our $APP     = 'mailme';
our $VERSION = '0.1.2';

my $account = 'gmail';

usage() unless(@ARGV);

our($opt_subject, $opt_recipient, $opt_body);
GetOptions(
  'subject:s'   => \$opt_subject,
  'recipient:s' => \$opt_recipient,
);

if($opt_subject && $opt_recipient) {
  my $tmp_body = "/tmp/$APP-$opt_subject.pl";
  system("\$EDITOR $tmp_body");
  open(my $fh, '<', "$tmp_body") or die($!);
  $opt_body = <$fh>;
  close($fh);
  unlink($tmp_body) or die($!);
  mail($opt_subject,$opt_body,$opt_recipient);

}

sub mail {
  my($subject,$body,$recipient) = @_;
  return unless($recipient);

  my $content = sprintf("Subject:$subject\n\n$body\n");
  system("printf \"$content\"|msmtp -a $account \"$recipient\"");
  exit(0);
}

sub usage {
  print << "USAGE";
  $APP $VERSION
  USAGE
    $APP [-s subject] [-r recipient]
USAGE
exit(0);
}
