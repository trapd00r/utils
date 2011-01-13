#!/usr/bin/perl
# vim wrapper

use strict;
use Storable;
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

my @files = map { -f $_ && $_ =~ s|.+/(.+)$|$1|; $_ } @ARGV;
my $vim = join(' ', @files);

my $result;
-f $history and $result = retrieve($history);

for my $file(@files) {
  $result->{$file} += $time_spent;
}

my($hour, $min, $sec) = (0) x 3;
$hour = $t->hour -1;
$min  = $t->min;
$sec  = $t->sec;

printf("%s %s,",
  fg('blue8', fg('bold', $hour)), ($hour > 1) ? 'hours ' : 'hour'
) unless($hour == 0);

printf(" %s %s,",
  fg('blue8', fg('bold', $min)), ($min > 1) ? 'minutes ' : 'minute'
) unless($min == 0);

printf(" %s %s",
  fg('blue8', fg('bold', $sec)),
  (($sec != 0) && ($sec > 1)) ? 'seconds ' : 'second'
);

#FIXME
@ARGV = @files;
@files = split(/\s+/, $vim);
my $i = 2;
@files = map {++$i; $_ = fg($i, $_);} @files;

my $foo = join(', ', @files);
$foo =~ s/(.+), (.+)$/$1 . fg('bold', ' and ') . "$2."/e;

printf(" spent hacking on %s\n", $foo);

#FIXME
@files = @ARGV;
if(scalar(@files) == 1) {
  my $w = localtime($result->{$files[0]});
  my $h = $w->hour - 1;
  my $m = $w->min;
  my $s = $w->sec;
  printf(" %s hours, %s minutes, %s seconds of total hacking time on %s\n",
    fg('blue8', fg('bold', $h)),
    fg('blue8', fg('bold', $m)),
    fg('blue8', fg('bold', $s)),
    fg('bold', fg('bold', fg('orange4', $files[0]))),
  );
}

store($result, $history);
