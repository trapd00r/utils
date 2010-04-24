#!/usr/bin/perl
# np-dingata
use XML::Simple;
use LWP::Simple;
use Data::Dumper;
my $url = "http://api.sr.se/api/rightnowinfo/Rightnowinfo.aspx?unit=2576";

my $c = get($url) or die;

my $x = XML::Simple->new;
my $d = $x->XMLin($c);
my $dc = $data->{'Channel'};

print "np: $dc->{Song} | Next: $dc->{NextSong} (Din Gata)\n";

