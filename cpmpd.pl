#!/usr/bin/perl
use strict;
use Getopt::Long;

my $base   = '/mnt/Music_1';
my $target = "$ENV{HOME}/ToTransfer";
my $host   = '192.168.1.101';
chomp(my $file = `mpc -h $host --format %file%|head -1`);
my $path   = "$base/$file";
my ($basename) = $path =~ m;.+/(.+)$;;
my ($album)    = $path =~ m;(.+)/.+$;;

our($opt_album) = 0;
GetOptions(
  'album'    => \$opt_album,
  'target:s' => \$target,
);

transfer($opt_album);
sub transfer {
  my $what = shift;
  if($what == 0) {
    exec('scp', "-P 19216", "scp1\@$host:\"$path\"", $target);
  }
  else {
    exec('scp', '-P 19216', '-r', "scp1\@$host:\"$album\"", $target);
  }
  exit(0);
}
