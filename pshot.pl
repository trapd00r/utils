#!/usr/bin/perl
our $APP     = 'pshot';
our $VERSION = 0.1;

use strict;
use Getopt::Long;
use Pod::Usage;

# TODO : scrot vs import, bbcode img thumbs, no hardcoded ssh stuff, xclip?
my $base = 'http://psy.trapd00r.se';

our($opt_bbcode,$opt_html);
GetOptions(
  bbcode  => \$opt_bbcode,
  html    => \$opt_html,
  help    => sub { pod2usage(verbose => 1) && exit(0); },
  man     => sub { pod2usage(verbose => 3) && exit(0); },
);

my $dname = 'scrots/' . shift(@ARGV);

print shot(),"\n";

sub shot {
  my $fname = time() . '.png';
  system('scrot', $fname) == 0 or die($!);

  system(
    'ssh', '-p', 19216,
    'scp1@192.168.1.100', "mkdir -p http/psy/$dname"
  ) == 0 or(die($!));

  open(OLD_STDOUT, '>&', STDOUT) or die($!);
  close(STDOUT);

  system(
    'scp', '-P', 19216,
    $fname, "scp1\@192.168.1.100:http/psy/$dname"
  ) == 0 or(die($!));

  open(STDOUT, '>&', OLD_STDOUT) or die($!);

  if($opt_html) {
    return("<a href=\"$base/$dname/$fname\">");
  }
  elsif($opt_bbcode) { #TODO use thumb in [img]
    return("[url=$base/$dname/$fname][img]$base/$dname/$fname\[/img][/url]");
  }
  else {
    return("$base/$dname/$fname");
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
  -he,  --help      show the help and exit
  -m,   --man       show the manual and exit

=head1 AUTHOR

Written by Magnus Woldrich.

License: GPLv2

=head1 COPYRIGHT

Copyright (C) Magnus Woldrich 2010

=cut
