#!/usr/bin/perl
# vim wrapper

# Calculate changes?
use strict;

my $history = "$ENV{HOME}/doc/vimtimes";

$\ = "\n";
$|++;


my $files;
map{ -f $_ and $files++ } @ARGV;

my $start = time();

open(my $fh, '>>', $history) or die($!);
print $fh "Task started  " . scalar(localtime), "\n";
print $fh "   cmdline> [vim] ",  join(' ', @ARGV), "\n";

system('/usr/bin/vim', '-p', @ARGV);

my $end = time();

my $time_spent = ($end - $start);

my $m = $time_spent / 60;

print $fh sprintf("   Edited %s %s\n", $files, ($files > 1) ? 'files' : 'file');
print $fh "Task finished in " . sprintf("%.2d minutes (%d seconds)",
  $m, $time_spent), "\n-\n";

__DATA__

Task started  Tue Nov 30 22:50:55 2010

   cmdline> [vim] vim fxshot calc batwarn fillmp3

   Edited 5 files

Task finished Tue Nov 30 22:50:59 2010
-

