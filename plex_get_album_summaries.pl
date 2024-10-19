#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use open(':std', ':encoding(UTF-8)');
use LWP::Simple;
use XML::Simple;
use JSON;
use DDP;

# Plex server details
my $plex_host = 'http://192.168.1.34:32400';
my $artist_section_id = '16';

# Directory to save album summaries
my $output_dir = '/home/scp1/doc/music/albums';
mkdir $output_dir unless -d $output_dir;

# Fetch all artists
my $artists_url = "$plex_host/library/sections/$artist_section_id/all";
my $xml_data = get($artists_url) or die "Could not fetch artist list: $!";
my $artists = XMLin($xml_data, ForceArray => ['Directory'], KeyAttr => {});

# Process each artist
foreach my $artist (@{$artists->{Directory}}) {
    my $artist_name = $artist->{title};
    my $artist_key = $artist->{ratingKey};

    # Fetch albums for the artist
    my $albums_url = "$plex_host/library/metadata/$artist_key/children";
    my $albums_xml = get($albums_url) or die "Could not fetch albums for artist $artist_name: $!";
    my $albums = XMLin($albums_xml, ForceArray => ['Directory'], KeyAttr => {});

    foreach my $album (@{$albums->{Directory}}) {
        my $album_name = $album->{title};
        my $album_key = $album->{ratingKey};

        # Fetch album details
        my $album_url = "$plex_host/library/metadata/$album_key";
        my $album_xml = get($album_url) or die "Could not fetch album details for $album_name: $!";
        my $album_data = XMLin($album_xml);

        # Extract album information
        my $album_summary = $album_data->{Directory}->{summary} || 'No summary available';
        my $album_year = $album_data->{Directory}->{year} || 'Unknown year';
        my $album_genre = $album_data->{Directory}->{Genre}->{tag} || 'Unknown genre';
        my $album_type = $album_data->{Directory}->{type} || 'Unknown type';
        my $track_count = $album_data->{Directory}->{leafCount} || 'Unknown track count';

        # Prepare data to save
        my $output_data = {
            artist      => $artist_name,
            album       => $album_name,
            summary     => $album_summary,
            year        => $album_year,
            genre       => $album_genre,
            album_type  => $album_type,
            track_count => $track_count,
        };

        print "Saving info for album: $album_name by $artist_name\n";

        my $output_file = "$output_dir/$artist_name - $album_name.json";
        open my $fh, '>', $output_file or next;
        print $fh to_json($output_data, { pretty => 1 });
        close $fh;

        print "Saved summary for album: $album_name by $artist_name\n";
    }
}
