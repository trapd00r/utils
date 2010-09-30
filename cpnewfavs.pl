#!/usr/bin/perl
# cpnewfavs - copy todays favorites to the portable player
use File::Copy;

my $basedir  = '/mnt/Music_1';
my $listdir  = "$basedir/Playlists";
my $target   = "/mnt/mp3/MUSIC";

my(undef, undef, undef, $mday, $mon, $year) = localtime(time);
$mon  += 1;
$year += 1900;

my $playlist = sprintf("%d-%02d-%02d_history.m3u",
  $year, $mon, $mday);

open(my $cat, '<', "$listdir/$playlist")
  or die($!);

while(<$cat>) {
  chomp;
  my $file = "$basedir/$_";
  #$file =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;


  if(copy($file, $target)) {
    my($basename) = $file =~ m;.+/(.+)$;;
    printf("\e[33;1m%30.30s\e[0m => \e[1m%s\e[0m\n",
      $basename, $target);
  }
  else {
    print STDERR "copy $file: $!\n";
  }
}

close($cat); # be nice

