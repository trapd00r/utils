#!/bin/sh
database="$HOME/.mpd/mpd.db"

LC_ALL="C"

number_of() {
  local N=$(grep "$1" "$database" | sort | uniq | wc -l)
  echo $N
}

most_from() {
  local most=$(grep "$1" "$database" | sort | uniq -c | sort -r | head -1 | cut -d ':' -f 2-)
  echo $most
}

echo
echo "tracks  : $(number_of '^Title: ')"
echo "artists : $(number_of '^Artist: ')"
echo "albums  : $(number_of '^Album: ')"
echo
echo "most from artist : $(most_from '^Artist: ')"
echo "most from year   : $(most_from '^Date: ')"
echo "most from genre  : $(most_from '^Genre: ')"
echo

