#!/usr/bin/perl
# cpmpd
# copy now playing track or album from remote MPD server to local box
use strict;
use Getopt::Long;

my $base       = '/mnt/Music_1';
my $target     = "$ENV{HOME}/ToTransfer";
my $host       = '192.168.1.101';
chomp(my $file = `mpc -h $host --format %file%|head -1`);
my $path       = "$base/$file";
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
    # I need all music files in the root of my music player
    chomp(my @files = grep{/\.(?:mp3|flac)$/} `ssh -p 19216 scp1\@$host \"find \'$album\'\"`);
    map{$_ = "'$_'"} @files;

    for(@files) {
      $_ =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;
      system("scp -P 19216 scp1\@$host:$_ $target");
    }
  }
  exit(0);
}
