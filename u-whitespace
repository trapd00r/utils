#!/usr/bin/perl
use vars qw($VERSION);
my $APP  = '';
$VERSION = '0.001';

use strict;
use Data::Dumper;

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

use charnames qw(:full);

print <<"LEGEND";
s   matches \\s, matches Perl whitespace
h   matches \\h, horizontal whitespace
v   matches \\v, vertical whitespace
p   matches [[:space:]], POSIX whitespace
all characters match Unicode whitespace, \\p{Space}

LEGEND

printf qq(%s %s %s %s  %-7s --> %s\n),
  qw( s h v p  Ordinal  Name );
print '-' x 50, "\n";

foreach my $ord ( 0 .. 0x10ffff ) {
  next unless chr($ord) =~ /\p{Space}/;
  my( $s, $h, $v, $posix ) =
    map { chr($ord) =~ m/$_/ ? 'x' : ' ' }
      ( qr/\s/, qr/\h/, qr/\v/, qr/[[:space:]]/ );
  printf qq(%s %s %s %s  0x%04X  --> %s\n),
    $s, $h, $v, $posix,
    $ord, charnames::viacode($ord);
  }





=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 OPTIONS

=head1 AUTHOR

  Magnus Woldrich
  CPAN ID: WOLDRICH
  magnus@trapd00r.se
  http://japh.se

=head1 REPORTING BUGS

Report bugs on rt.cpan.org or to magnus@trapd00r.se

=head1 COPYRIGHT

Copyright (C) 2011 Magnus Woldrich. All right reserved.
This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


# vim: set ts=2 et sw=2:

