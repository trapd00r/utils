#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

#use open qw(:std :utf8);

use DDP;
use Filesys::DiskUsage qw(du);
use Cwd;
use v5.30;
use File::Find::Rule;

# Sophie Zelmani │2010│ I'm the Rain [CD, FLAC]
# Sophie Zelmani │2010│ I'm the Rain [CD, MP3]


# find all directory names that has the same name except for one can have [CD, FLAC] and the other [CD, MP3]

my $trash = "$ENV{HOME}/trash";

my @remove_mp3;
#for my $dir(glob('*/*')) {
for my $dir(File::Find::Rule->directory->in('.')) {
  if($dir =~ m/FLAC/) {
    my $absname = getcwd() . '/' . $dir;
    my $mp3_dir = $dir;
    $mp3_dir =~ s/FLAC/MP3/;
    my $absnamemp3 = getcwd() . '/' . $mp3_dir;
    if(-d $mp3_dir) {
      printf "% 10s FLAC: '%s'\n", du({ 'human-readable' => 1 }, $dir), $absname;
      printf "\e[48;5;160m% 10s  MP3: '%s'\e[m\n", du({ 'human-readable' => 1 }, $mp3_dir), $absnamemp3;
      push(@remove_mp3, $absnamemp3);
    }
  }
}


# ask user if remove the MP3 directories
if(@remove_mp3) {
  print "Remove MP3 directories? [y/N] ";
  my $answer = <STDIN>;
  chomp $answer;
  if($answer eq 'y') {
    for my $dir(@remove_mp3) {
#      print("rm -rf '$dir'");
      $dir = quotemeta($dir);
      system("mv -v $dir $trash");
    }
  }
}
