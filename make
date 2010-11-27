#!/usr/bin/perl
use strict;


my $remote_host   = '192.168.1.100';
my $remote_port   = '19216';
my $remote_user   = 'scp1';
my $remote_dest   = 'http/p/devel';

pass_on(@ARGV);

sub pass_on {
  if($_[0] eq 'dist') {
    system("/usr/bin/make", 'dist');
    for(glob('*.tar.gz')) {
      print "<< $_ <<\n";
      scp($remote_host, $remote_port, $remote_dest, $_);
    }
  }
  else {
    system("/usr/bin/make", @_);
  }
}

sub scp {
  my($host, $port, $dest, $target) = @_;
  $port or $port = 22;
  return system("scp -P $remote_port $target $remote_user\@$remote_host:$dest");
}
