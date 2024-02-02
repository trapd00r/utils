#!/bin/bash

source_dir="/home/scp1/mnt/nasse/music"
dest_dir="/home/scp1/mnt/media2/music"

# List all directories with the name "+tracks" in the source directory and its subdirectories
find "$source_dir" -type d -name "+tracks" | while read -r source_tracks_dir; do
  # Extract the relative path of the "+tracks" directory from the source directory
  relative_path="${source_tracks_dir#$source_dir}"

  # Build the corresponding destination directory path
  dest_tracks_dir="$dest_dir$relative_path"

  # Move the "+tracks" directory to the destination directory
   mv -nv "$source_tracks_dir" "$dest_tracks_dir"
#    echo "Moved '$source_tracks_dir' to '$dest_tracks_dir'"
done
