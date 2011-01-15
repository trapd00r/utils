#!/usr/bin/perl

# Create a hash of colorschemes found in .Xresources
use strict;

my $file = shift or die;

open(my $fh, '<', $file) or die($!);
chomp( my @r = <$fh> );
close($fh);


my @c = grep{/(\*color\d+:\s*#.+)/} @r;


for(@c) {
  if($_ =~ /!?\*(color\d+):\s*#(.+)/) {
    print "  $1 => '$2',\n";
  }

}


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

