#!/usr/bin/perl
our $APP     = 'cpmpd';
our $VERSION = 0.2;

use strict;
use Getopt::Long;

#FIXME throw this crap in a config file
my $base       = '/mnt/Music_1';
my $target     = "$ENV{HOME}/ToTransfer";
my $user       = 'scp1';
my $host       = '192.168.1.101';
my $port       = 19216;
my $scp        = '/usr/bin/scp';

chomp(my $file = `mpc -h $host --format %file%|head -1`);
my $path       = "$base/$file";

my ($basename) = $path =~ m;.+/(.+)$;;
my ($album)    = $path =~ m;(.+)/.+$;;
my ($albname)  = $album =~ m;.+/(.+)$;;

our($opt_album) = undef;
our(@opt_search);

GetOptions(
  'album'         => \&get_album,
  'track'         => \&get_track,
  'dest:s'        => \$target,
  'search=s{1,}'  => \@opt_search,
);

search(@opt_search) if(@opt_search);

sub get_album {
  printf("\e[38;5;208m\e[1m$albname\e[0m => \e[1m$target\e[0m\n");
  transfer($album);
}
sub get_track {
  printf("\e[38;5;196m\e[1m$basename\e[0m => \e[1m$target\e[0m\n");
  transfer($path);
}

sub search {
  my @search = @_;
  my $query = join(' ', @search);
  chomp(my @result = `mpc -h $host search $query`);
  if(@result) {
    map{$_ = "$base/$_"} @result;
    transfer(@result);
  }
  exit(0);
}
sub transfer {
  my @files = @_;
  for(@files) {
    $_ =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;
    system("$scp -P $port -r $user\@$host:\"$_\" $target");
  }
  exit(0);
}

=pod

=head1 NAME

  cpmpd - copy music from a (remote) MPD server

=head1 DESCRIPTION

  cpmpd is cool

=head1 OPTIONS

  --dest    set target destination
  --album   copy the now playing album to target
  --track   copy the now playing track to target
  --search  search the MPD db and copy results to target

=head1 COPYRIGHT

Copyright (C) Magnus Woldrich 2010

License GPLv2

=cut
