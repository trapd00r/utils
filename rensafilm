#!/usr/bin/perl
# rensafilm
use strict;

opendir(my $dh, '/mnt/Movies_1') or die($!);
my @movies_1 = readdir($dh);
close($dh);

opendir(my $dh, '/mnt/Movies_2') or die($!);
my @movies_2 = readdir($dh);
close($dh);

for my $foo(@movies_1) {
  for(@movies_2) {
    my($name) = $foo =~ /(.+)\.[0-9]{4}\..+/;
    next if(!$name);
    if($_ =~ /$name/) {
      printf("\e[38;5;148m/mnt/Movies_1/\e[1m\e[38;5;100m%s\e[0m => \e[38;5;131m/mnt/Movies_2/\e[1m\e[38;5;166m$_\e[0m\n",
        $foo, $_);
    }
  }
}
