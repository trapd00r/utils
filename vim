#!/usr/bin/perl
# vim wrapper

# Calculate changes?
use strict;

my $history = "$ENV{HOME}/vimtimes";

$\ = "\n";
$|++;


my $files;
map{ -f $_ and $files++ } @ARGV;

my $start = time();

open(my $fh, '>>', $history) or die($!);
print $fh "Task started  " . scalar(localtime), "\n";
print $fh "   cmdline> [vim] ",  join(' ', @ARGV), "\n";

system('/usr/bin/vim', '-p', @ARGV);

print $fh sprintf("   Edited %s %s\n", $files, ($files > 1) ? 'files' : 'file');
print $fh "Task finished " . scalar(localtime), "\n-\n";

__DATA__

Task started  Tue Nov 30 22:50:55 2010

   cmdline> [vim] vim fxshot calc batwarn fillmp3

   Edited 5 files

Task finished Tue Nov 30 22:50:59 2010
-

