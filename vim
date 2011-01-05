#!/usr/bin/perl
# vim wrapper

use strict;
use Time::localtime;
use Term::ExtendedColor;
use Data::Dumper;
$Data::Dumper::Terse     = 1;
$Data::Dumper::Indent    = 1;
$Data::Dumper::Useqq     = 1;
$Data::Dumper::Deparse   = 1;
$Data::Dumper::Quotekeys = 0;
$Data::Dumper::Sortkeys  = 1;



my $history = "$ENV{HOME}/doc/vimtimes";

$\ = "\n";
$|++;

my $start = time();

#print $fh "Task started  " . scalar(localtime), "\n";
#print $fh "   cmdline> [vim] ",  join(' ', @ARGV), "\n";


system('/usr/bin/vim', '-p', @ARGV);

my $end = time();

my $time_spent = ($end - $start);

my $t = localtime($time_spent);

my @files = map { -f $_ && $_ } @ARGV;
my $vim = join(', ', @files);
my $result;
push(
  @{$result->{$vim}},
    sprintf("%d min, %d sec",
      $t->min, $t->sec,
  )
);

open(my $fh, '>>', $history) or die($!);
print $fh sprintf("% 2d min, % 2d sec spent hacking on %s", $t->min, $t->sec, $vim)
  unless($vim =~ /^, , , /);
close($fh);

my ($min, $sec) = ($t->min, $t->sec);

printf("%s %s, %s %s spent hacking on %s\n",
  fg('blue8', fg('bold', $min)),
  fg('bold', 'minutes'),
  fg('blue4', fg('bold', $sec)),
  fg('bold', 'seconds'),
  $vim,
);
