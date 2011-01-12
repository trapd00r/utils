#!/usr/bin/perl
# vim wrapper

use strict;
use Time::localtime;
use Term::ExtendedColor;

#use Data::Dumper;
#$Data::Dumper::Terse     = 1;
#$Data::Dumper::Indent    = 1;
#$Data::Dumper::Useqq     = 1;
#$Data::Dumper::Deparse   = 1;
#$Data::Dumper::Quotekeys = 0;
#$Data::Dumper::Sortkeys  = 1;

my $history = "$ENV{HOME}/doc/vimtimes";

$\ = "\n"; # evil :)
$|++;

my $start = time();

system('/usr/bin/vim', '-p', @ARGV);

my $end = time();

my $time_spent = ($end - $start);

my $t = localtime($time_spent);

my @files = map { -f $_ && $_ } @ARGV;
my $vim = join(' ', @files);
my $result;
push(
  @{$result->{$vim}},
    sprintf("%d min, %d sec",
      $t->hour, $t->min, $t->sec,
  )
);

open(my $fh, '>>', $history) or die($!);
print $fh sprintf(" %3d hours, % 3d min, % 3d sec spent hacking on %s",
  $t->hour, $t->min, $t->sec, $vim)
  unless($vim =~ /^,/);
close($fh);

my($hour, $min, $sec) = (0) x 3;
$hour = $t->hour -1;
$min  = $t->min;
$sec  = $t->sec;

printf("%s %s",
  fg('blue8', fg('bold', $hour)), ($hour > 1) ? 'hours ' : 'hour'
) unless($hour == 0);

printf(" %s %s",
  fg('blue8', fg('bold', $min)), ($min > 1) ? 'minutes ' : 'minute'
) unless($min == 0);

printf(" %s %s",
  fg('blue8', fg('bold', $sec)),
  (($sec != 0) && ($sec > 1)) ? 'seconds ' : 'second'
);

@files = split(/\s+/, $vim);
my $i = 2;
@files = map {++$i; $_ = fg($i, $_);} @files;

my $foo = join(', ', @files);
$foo =~ s/(.+), (.+)$/$1 . fg('bold', ' and ') . "$2."/e;

printf(" spent hacking on %s\n", $foo);

