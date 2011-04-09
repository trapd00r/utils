#!/usr/bin/env perl
use 5.012;
use strict;
use warnings;
use utf8;

sub get_maxmind_ip_js() {
    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    my $response = $ua->get("http://j.maxmind.com/app/geoip.js");
    if ($response->is_success) {
        return $response->decoded_content;
    }
    else {
        die $response->status_line;
    }
}

sub location() {
    my $content = get_maxmind_ip_js();

    my $loc = {};
    while ($content =~ m/^function geoip_(\w+)\(\)\s*{ return '(.*?)'; }$/msg) {
        my ($name, $value) = ($1, $2);
        $loc->{$name} = $value;
    }
    return $loc;
}

my $location = location;
# use YAML;
# say YAML::Dump($location);
say $location->{latitude} .", ". $location->{longitude};
