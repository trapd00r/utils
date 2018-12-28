#!/usr/bin/perl
# abstract: a terminal color clock
use strict;
use vars qw($VERSION);
my $APP  = q{colorclock};
$VERSION = '0.003';

use Term::ExtendedColor qw(:attributes);
use Term::ExtendedColor::Xresources qw(set_xterm_color);

$SIG{INT} = sub {
  print "\e[?25h";
  set_xterm_color({ 255 => 'eeeeee'});
  exit;
};

$|++;
print "\e[?25l";
while(1) {
  my($s, $m, $h) = map { sprintf("%02d", $_) } (localtime)[0..2];
  print  values %{ set_xterm_color({ 255 => qq{$h$m$s}}) };
  printf("%s\r", bg(255, "$h$m$s"));
  sleep 1;
}

__END__
