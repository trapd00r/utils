#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use utf8;
use open qw(:std :utf8);

use DDP;
use v5.30;

use Mojo::DOM;
use Mojo::UserAgent;

my $base_url = 'http://dl.xonotic.fps.gratis/';
my $map_dir = "$ENV{HOME}/Xonotic_old/data";

my $ua = Mojo::UserAgent->new;

my $dom = Mojo::DOM->new($ua->get($base_url)->result->body);

my %pk3 = map { $_ => "${base_url}$_" } $dom->find('a')->map(attr => 'href')->each;

for my $pk3 (keys %pk3) {
    my $file = "$map_dir/$pk3";
    next if -e $file;
    say "Downloading $pk3";
    $ua->get($pk3{$pk3})->result->save_to($file);
}


