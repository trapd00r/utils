#!/usr/bin/perl
# mount-shiva
use strict;
use Data::Dumper;

my %mounts = (
  Music_1 => '/mnt/Music_1',
  Music_2 => '/mnt/Music_2',
  Music_3 => '/mnt/Music_3',
  Music_4 => '/mnt/Music_3',
  Music_5 => '/mnt/Music_3',
  Music_6 => '/mnt/Music_3',
  Music_7 => '/mnt/Music_3',
  Mvids   => '/mnt/Mvids',
  Mvids_2 => '/mnt/Mvids_2',
  Movies_1=> '/mnt/Movies_1',
  Movies_2=> '/mnt/Movies_2',
  Games_1 => '/mnt/Games_1',
  Games_2 => '/mnt/Games_2',
  Books   => '/mnt/Books',
  Docs    => '/mnt/Docs',
  Leftover=> '/mnt/Leftover',
  Porn    => '/mnt/Porn',
  TV_1    => '/mnt/TV_1',
  TV_2    => '/mnt/TV_2',
);

my $mount = shift;

if(!$mount) {
  mount(\%mounts);
}
else {
  mount($mount);
}

sub mount {
  my $mounty = shift;
  if(ref($mounty) eq 'HASH') {
    for my $shname(sort(keys(%{$mounty}))) {
      exec('sshfs', '-p', 19216, 'scp1@192.168.1.101:' . $mounty->{$shname},
        $mounty->{$shname}) == 0 or croak($!);
    }
  }
  else {
    if($mounts{$mounty}) {
      print "OK";
    }
  }
}


