#!/bin/bash

### Script for downloading albums from Youtube Music ##########
### Usage: ./yt-music-album-download.sh <youtube music url> ###

# - Converts to MP3 from the best quality audio feed
# - Adds track number, album, artist, title, and release year into id3 tags
# - Adds album art embedded thumbnails

echo "Retrieving album information..."
# Downloading the json data of the first track only
jsondata=`yt-dlp -j --playlist-items 1 $1`

# Grabbing the "release_year" and "release_date" and comparing which is lowest integer.
# Sometimes Youtube Music doesn't even populate the "release_date" field, but when it does we need to compare it to "release_year"
# If both the "release_date" and "release_year" exist, check which one is the lower integer, and that should be the actual album release year.
jq_release_year_1=`echo $jsondata | jq -r '.release_year'`
jq_release_date=`echo $jsondata | jq -r '.release_date'`
if [ $jq_release_date != 'null' ]; then
        jq_release_year_2=${jq_release_date::-4};
        year=$((jq_release_year_1<jq_release_year_2?jq_release_year_1:jq_release_year_2));
else
        year=$jq_release_year_1;
fi

# Grabbing the artist then removing any superfluous information after the first comma. Some artists put every band memember into the artist field.
jq_artist=`echo $jsondata | jq -r '.artist'`
artist=${jq_artist%%,*}

echo "Album information retrieved..."
# Pass to yt-dlp and begin download all the music!
yt-dlp  --ignore-errors \
        --format "(bestaudio[acodec^=opus]/bestaudio)/best" \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --parse-metadata "playlist_index:%(track_number)s" \
        --parse-metadata ":(?P<webpage_url>)" \
        --parse-metadata ":(?P<synopsis>)" \
        --parse-metadata ":(?P<description>)" \
        --add-metadata \
        --postprocessor-args "-metadata date='${year}' -metadata artist=\"${artist}\" -metadata album_artist=\"${artist}\"" \
        --embed-thumbnail \
        --ppa "EmbedThumbnail+ffmpeg_o:-c:v mjpeg -vf crop=\"'if(gt(ih,iw),iw,ih)':'if(gt(iw,ih),ih,iw)'\"" \
        -o "$artist - %(album)s/%(playlist_index)s - %(title)s.%(ext)s" "$1"
