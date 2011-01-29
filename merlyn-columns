#!/usr/bin/perl
# merlyn fetcher
use strict;
use WWW::Mechanize;

my $base = 'http://cpan.se/authors/id/M/ME/MERLYN';
my $m    = WWW::Mechanize->new;

$m->get($base) or die;


$\ = "\n";
for(map{ $_->url_abs; } $m->find_all_links) {
  if(my($mag, $col) = $_ =~ m;http://.+merlyn/(.+)/(.+(?:\.txt|html))$;) {
    my $file = lc($mag) . "-$col";

    $m->follow_link(url => $_) unless($_ !~ /http/);
    print "Saving $file";
    $m->save_content($file);
    $m->back;
  }
}

