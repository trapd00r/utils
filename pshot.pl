#!/usr/bin/perl
our $APP     = 'pshot';
our $VERSION = 0.2;

use strict;
use Getopt::Long;
use Pod::Usage;

my $base     = 'http://psy.trapd00r.se';
my $ssh_host = '192.168.1.100';
my $ssh_user = 'scp1';
my $ssh_port = 19216;

our($opt_bbcode,$opt_html);
GetOptions(
  bbcode  => \$opt_bbcode,
  html    => \$opt_html,
  '-h'    => sub { pod2usage(verbose => 1) && exit(0); },
  man     => sub { pod2usage(verbose => 3) && exit(0); },
);

my $dname = 'scrots';
if(@ARGV) {
  $dname . "/" . shift(@ARGV);
}

print shot(),"\n";

sub shot {
  my $fname = 'pshot-' . time();
  system("scrot -q 100 $fname.png -t 30%") == 0 or die("scrot failed: $!");

  system(
    'ssh', '-p', $ssh_port,
    "$ssh_user\@$ssh_host", "mkdir -p http/psy/$dname"
  ) == 0 or(die("ssh failed: $!"));

  # dupe STDOUT so we can reopen it when we wanna be loud
  open(OLD_STDOUT, '>&', STDOUT) or die("stddd$!");
  close(STDOUT);

  system(
    'scp', '-P', $ssh_port,
    "$fname.png", "$fname-thumb.png", "$ssh_user\@$ssh_host:http/psy/$dname"
  ) == 0 or(die("scp failed: $!"));
  unlink("$fname.png") or print "$fname.png: $!" and exit(-1);
  unlink("$fname-thumb.png") or print "$fname-thumb.png: $!" and exit(-1);

  open(STDOUT, '>&', OLD_STDOUT) or die($!);

  if($opt_html) {
    return("<a href=\"$base/$dname/$fname.png\">");
  }
  elsif($opt_bbcode) {
    return(
      "[url=$base/$dname/$fname.png][img]$base/$dname/$fname-thumb.png\[/img][/url]"
    );
  }
  else {
    return("$base/$dname/$fname.png");
  }
  exit(0);
}

=pod

=head1 NAME

  pshot - screenshot automation tool

=head1 DESCRIPTION

  phshot takes a screenshot, transfers it to a remote host and return the
  resulting URI (assuming remote httpd). HTML style notation and BBCode syntax
  is optional.

=head1 OPTIONS

  -b,   --bbcode    return the uri in bbcode syntax
  -ht,  --html      return the uri wrapped in html href syntax
  -h,   --help      show the help and exit
  -m,   --man       show the manual and exit

=head1 AUTHOR

Written by Magnus Woldrich.

License: GPLv2

=head1 COPYRIGHT

Copyright (C) Magnus Woldrich 2010

=cut
