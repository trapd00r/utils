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

# Directory to save artist summaries
my $output_dir = '/home/scp1/doc/music/artists';
mkdir $output_dir unless -d $output_dir;

# Fetch all artists
my $artists_url = "$plex_host/library/sections/$artist_section_id/all";
my $xml_data = get($artists_url) or die "Could not fetch artist list: $!";
my $artists = XMLin($xml_data, ForceArray => ['Directory'], KeyAttr => {});

# Process each artist
foreach my $artist (@{$artists->{Directory}}) {
    my $artist_name = $artist->{title};
    my $artist_key = $artist->{ratingKey};

    # Fetch artist details
    my $artist_url = "$plex_host/library/metadata/$artist_key";
    my $artist_xml = get($artist_url) or die "Could not fetch artist details for $artist_name: $!";
    my $artist_data = XMLin($artist_xml);

    # Extract artist information
    my $artist_summary = $artist_data->{Directory}->{summary} || 'No summary available';
    my $artist_genre = $artist_data->{Directory}->{Genre}->{tag} || 'Unknown genre';
    my $artist_country = $artist_data->{Directory}->{Country} || 'Unknown country';
    my $years_active = $artist_data->{Directory}->{yearsActive} || 'Unknown years active';
    my $albums_count = $artist_data->{Directory}->{childCount} || 'Unknown album count';
    my $rating = $artist_data->{Directory}->{rating} || 'No rating';
    my $similar_artists = $artist_data->{Directory}->{SimilarArtist} || [];
    my $track_count = $artist_data->{Directory}->{leafCount} || 'Unknown track count';
    my $artist_type = $artist_data->{Directory}->{type} || 'Unknown artist type';
    my $mood = $artist_data->{Directory}->{Mood}->{tag} || 'Unknown mood';
    my $style = $artist_data->{Directory}->{Style}->{tag} || 'Unknown style';
    my $thumb_image = $artist_data->{Directory}->{thumb} || 'No image available';

    # Prepare data to save
    my $output_data = {
        artist        => $artist_name,
        summary       => $artist_summary,
        genre         => $artist_genre,
        country       => $artist_country,
        years_active  => $years_active,
        albums_count  => $albums_count,
        track_count   => $track_count,
        rating        => $rating,
        similar_artists => [ map { $_->{tag} } @{$similar_artists} ],
        artist_type   => $artist_type,
        mood          => $mood,
        style         => $style,
        thumb_image   => $thumb_image,
    };

    print "Saving info for artist: $artist_name\n";

    my $output_file = "$output_dir/$artist_name.json";
    open my $fh, '>', $output_file or next;
    print $fh to_json($output_data, { pretty => 1 });
    close $fh;

    print "Saved summary for artist: $artist_name\n";
}

print "All artist summaries saved successfully.\n";
