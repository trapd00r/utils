#!/usr/bin/perl
# chmod, unpack, watch, delete
use strict;
use Cwd;
use File::Find;

my $mp = 'mplayer -msgcolor -slave -input file=$HOME/.mplayer/mplayer.fifo';
my $pwd = shift // getcwd();

my $permdir  = 01742; # -rwxr---wT
#my $permfile = 0755;  # -rwxr-xr-x

chmod($permdir, $pwd); # This is specific to me, you dont want this!

my $tempdir;
$pwd =~ m/^((?:\/[^\/]+){2}\/).*/ and $tempdir = "$1.temp";

use vars qw/*name *dir *prune/;
*name   = *File::Find::name;
*dir    = *File::Find::dir;
*prune  = *File::Find::prune;

File::Find::find({wanted  => \&wanted}, $pwd);

sub wanted {
  /^.+\.rar/ 
  && doexec(0, "rar x {} $tempdir && $mp $tempdir/* && rm -v $tempdir/*");
}

sub doexec ($@) {
    my $ok = shift;
    my @command = @_; # copy so we don't try to s/// aliases to constants
    for my $word (@command)
        { $word =~ s#{}#$name#g }
    if ($ok) {
        my $old = select(STDOUT);
        $| = 1;
        print "@command";
        select($old);
        return 0 unless <STDIN> =~ /^y/;
    }
    chdir($pwd); #sigh
    system(@command);
    chdir $File::Find::dir;
    return !$?;
}

