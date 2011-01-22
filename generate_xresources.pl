#!/usr/bin/perl
# Generate a hash with colorschemes from X resources
use vars qw($VERSION);
my $APP  = '';
$VERSION = '0.003';

use strict;
use Data::Dumper;

{
  package Data::Dumper;
  no strict 'vars';
  $Terse = $Indent = $Useqq = $Deparse = $Sortkeys = 1;
  $Quotekeys = 0;
}

my $colors;

for my $file(@ARGV) {
  open(my $fh, '<', $file) or die($!);
  chomp( my @r = <$fh> );

  @r = grep{/(\*color\d+:\s*#.+)/} @r;

  for my $l(@r) {
    print $l, "\n";
    if($l =~ m/!?(?:\w+)?\*color(\d+):\s*#(.+)/) {
      $colors->{$file}->{$1} = $2;
    }
  }
}

print Dumper $colors;



__DATA__
! .Xdefaults
! <hcarvalhoalves@archlinux.us>

! Colour scheme
*background:#1a1a1a
*foreground:#fff
*highlightColor:#444
*color0:#000000
*color1:#ff6565
*color2:#93d44f
*color3:#eab93d
*color4:#204a87
*color5:#ce5c00
*color6:#89b6e2
*color7:#cccccc
*color8:#555753
*color9:#ff8d8d
*color10:#c8e7a8
*color11:#ffc123
*color12:#3465a4
*color13:#f57900
*color14:#46a4ff
*color15:#ffffff

! Xft resources
Xft.antialias:true
Xft.dpi:96
Xft.hinting:true
! hintslight | hintsmedium | hintsfull
Xft.hintstyle:hintslight
! rgba subpixel hinting (for LCDs)
Xft.rgba:none

! Xterm resources

! Xft font name style
XTerm*faceName:Liberation Mono
XTerm*faceSize:9
! Enable 256 color
XTerm*termName:xterm-color
XTerm*cursorBlink:false
XTerm*utf8:1
XTerm*loginShell:true
! Fix some input and <Alt> for ncurses
XTerm*eightBitInput:false
XTerm*altSendsEscape:true
! Matches selection for URLs and emails when double-click
XTerm*charClass: 33:48,37-38:48,45-47:48,64:48,58:48,126:48,61:48,63:48,43:48,35:38
XTerm*trimSelection: true

! Sets Xcursor theme (installed under /usr/share/icons/ or ~/.icons/)
Xcursor.theme:Vanilla-DMZ-AA


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

