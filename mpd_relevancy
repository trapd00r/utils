#!/bin/bash
### MPD Play by Relevancy ######
# Version 0.7 by Scott Garrett #
# Wintervenom [(at)] gmail.com #
################################
# Depends on:                  #
# - agrep (from 'tre')         #
# - mpc                        #
# - sponge (from 'moreutils')  #
################################

# Things you need to change to make this script work nicely for you:
#
# Obviously,
# - Change ${file}.  :P
# - Make sure the directories you use actually exist.
#   The script won't create those for you and will bitch if they're missing.
# - The larger your music collection, the better this works.
# Not as obvious,
# - You need to tune the pick_words() function to the formatting of your chat logs.
# Right now, it is tuned for my Weechat logs (and how I have it formatting them).
# Works best with the *actual converation* part of your logs -- no nicks, stamps,
# channel/network events, and such.
# - Currently, MPD filepaths (%file%) are used out of laziness.
# If you have some sort of funky organization scheme going on with your collection,
# you might want to play around with the fuzzy matching a bit.



###############
### Globals ###
###############
# What file should we scan for words and phrases?
file="./irssilog"

# Where the MPD library will be cached.
cache="/dev/shm/$(basename "$0").cache"

# Where already-added matches will be kept track of.
cache_added="./$(basename "$0").cache"

# Maximum length of add cache.
cache_added_len=100

# How many lines to consider at from the tail of the file.
tail_len=100

# Keep up to this many songs queued.
queue_len=100

# Minimal length of a query to be considered.
query_mlen=3

# If possible, consider this many extra consecutive words when forming a query.
query_words=1

# Fuzzy search approximation.  Lower == fewer mutations.
query_approximation=8

# Maximum number of results to return.  Lower == less result diversity.
# Results are weighted by accuracy.
result_maxlen=5

# Amount of time to sleep in between considerations.
sleep_consideration=1

# Maximum amount of time to sleep in between successful matches.
sleep_match=30

# Recache the MPD library after this many considerations.
interval_recache=30

# Consideration interval counter.  Leave it at zero.
interval_count=0



#################
### Functions ###
#################
pick_words () {
  # Get the last ${lail_len} lines of ${file}.
  tail -${tail_len} "${file}" |
  # Get rid of channel and network info crap.
  egrep -v '\[(Channel|Network)\]' |
  # Put the remaining lines into a bag and shuffle them.
  shuf | 
  # Grab the lucky line on the top.
  head -1 |
  # We're just interested in what the user had to say.
  cut -f3 |
  # Tell Awk to do dirty things to it:
  awk '{
    # Make it lowercase so we can be lazy.
    $0 = tolower($0);
    # Get rid of URIs.
    gsub(/(https?|ftp|telnet):\/\/.*\w\/?/,"");
    # Get rid of channel bot URI title-readers.
    gsub(/^Title: .*/,"");
    # Get rid of emoticons.
    gsub(/\w?(:-?[[:punct:]DP\|Oo3Ss\{\}]|[\\\/].[\\\/]|[Xx]D)\w?/,"");
    # Replace underscores with spaces.
    gsub(/_/," ");
    # Increase the chances of matching if someone is really talking about a song.
    gsub(/(artist|title|album)./,"");
    # Get rid of any non-alphanumeric characters except apostrophies.
    gsub(/[^[:alnum:][:space:]'\'']/," ");
    # Choose a random word from the line.
    srand(); word=int(1 + rand() * NF);
    # Print that word + ${query_words} + a random number of consecutive words.
    for (x=0; x<=int('"${query_words}"' + rand() * (1 + NF - word)); x++)
      printf("%s ",$(word + x)); printf("\n")
  }' |
  # Get rid of trailing spaces.
  sed 's/[ \t]*$//'
}



############
### Main ###
############
# Clean up if the user breaks with a [Control]-[C].
trap "echo; echo 'Cleaning up...'; rm -f '${cache}'; mpc consume off; exit" 2
echo "Caching MPD library..."
mpc -h 192.168.1.101 listall > "${cache}"
# Create the add cache now so Grep won't bitch.
touch "${cache_added}"
# Enable consume mode so we can tell when the playlist needs to be amended to.
mpc -h 192.168.1.101 -q consume on
mpc -q -h 192.168.1.101 random off
echo "Watching file: ${file}"
while :; do
  # Until the MPD queue is populated to at least ${queue_len} items...
  while [[ $(mpc -h 192.168.1.101 playlist | wc -l) -lt ${queue_len} ]]; do
    sleep ${sleep_consideration}
    # Increment the interval count and see if it is time to re-cache.
    if ((interval_count++ == interval_recache)); then
      echo "Re-caching MPD library..."
      mpc -h 192.168.1.101 listall > "${cache}"
      interval_count=0
    fi
    echo -n 'Considering query... '
    query=$(pick_words)
    # Check to see if this query is long enough to be useful.
    # If not, start back at the beginning of this loop.
    if [[ -z "${query}" ]]; then
      echo 'empty query.'
      continue
    elif [[ ${#query} -lt ${query_mlen} ]]; then
      echo "\"${query}\": too short."
      continue
    fi
    song=$(
      # Look for a song that is relevant to the query.
      agrep -${query_approximation}kis "${query}" "${cache}" |
      # Sort by how close they are to matching the query.
      sort -n |
      # Grab up to a ${result_maxlen} amount of the most accurate ones.
      # This gives a more weighted preference for accurate results.
      head -$((1 + RANDOM % result_maxlen)) |
      # Get rid of the accuracy level indicators.
      cut -d':' -f2 |
      # Shake, shake, shake... / Shake, shake, shake...
      shuf |
      # The lucky result.
      head -1
    )
    # If a relevant song was found...
    if [ "${song}" ]; then
      echo "\"${query}\": match found."
      # ...see if it has been added before.
      if grep -Fq "${song}" "${cache_added}"; then
        echo  "  Skipped: ${song}"
        continue
      fi
      # If not, add it...
      echo "  Added: ${song}"
      mpc -q -h 192.168.1.101 add "${song}"
      mpc -q -h 192.168.1.101 play
      # ...and cache it.
      (tail -${cache_added_len} "${cache_added}"; echo -e "${song}\t${query}") | sponge "${cache_added}"
      # Go to sleep for up to ${sleep_match} seconds, waiting for conversation.
      sleep $((RANDOM % sleep_match))
    else
      echo "\"${query}\": nothing relevant."
    fi
  done
  # Sleep until an MPD event happens, then check the playlist length.
  mpc -q -h 192.168.1.101 idle &> /dev/null
done
