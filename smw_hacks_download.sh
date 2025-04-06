#!/bin/sh

# - downloads all the Super Mario World hacks from SMW Central
# - applies the patches to the base ROM 'Super Mario World (USA).sfc'
# - names are cleaned up and used from the description

# Helper functions for colored output
info()    { printf "\033[1;34m==> %s\033[0m\n" "$*"; }
success() { printf "\033[1;32m✔ %s\033[0m\n" "$*"; }
error()   { printf "\033[1;31m✖ %s\033[0m\n" "$*"; }

# Check for base ROM
if [ ! -f "Super Mario World (USA).sfc" ]; then
    error "Please place 'Super Mario World (USA).sfc' in the current directory."
    exit 1
fi

# Check for required tools
for tool in curl awk wget 7z flips perl; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        error "Please install $tool to use this script."
        exit 1
    fi
done

# Download Stage
info "Starting download stage..."
for page in $(seq 1 50); do
    curl -s "https://www.smwcentral.net/?p=section&s=smwhacks&u=0&g=0&n=${page}&o=hof&d=desc" |
    awk '
      /<a href="\/\?p=section&amp;a=details&amp;id=.*">.*<\/a>/ {
          match($0, /a href="[^"]+">([^<]+)<\/a>/, m);
          hackname = m[1];
      }
      /https:\/\/dl\.smwcentral\.net\/[^\"]+\.zip/ {
          match($0, /href="([^"]+\.zip)"/, u);
          zipurl = u[1];
          if (hackname && zipurl) {
              print zipurl "|" hackname;
              hackname = zipurl = "";
          }
      }' | while IFS='|' read -r url hackname; do
          hackname_clean=$(printf "%s" "$hackname" | perl -MHTML::Entities -pe 'decode_entities($_); s#[/:*?"<>|]#_#g')
          filename="${hackname_clean}.zip"
          printf "Downloading \033[1;33m%s\033[0m... " "$filename"
          wget -q "$url" -O "$filename" && success "Done" || error "Failed to download $filename"
      done
done

# Extraction Stage
info "Starting extraction stage..."
for zipfile in *.zip; do
    dirname=$(basename "$zipfile" .zip)
    7z x -y -o"$dirname" "$zipfile" >/dev/null
    find "$dirname" -type f -iname '*.bps' | while read -r patchfile; do
        mv "$patchfile" "${dirname}.bps"
        success "Extracted patch ${dirname}.bps"
    done
    rm -rf "$dirname"
done

# Patching Stage
info "Starting patching stage..."
count=0
for patchfile in *.bps; do
    outputfile="$(basename "$patchfile" .bps).sfc"
    printf "Patching \033[1;36m%s\033[0m... " "$outputfile"
    if flips -a "$patchfile" "Super Mario World (USA).sfc" "$outputfile" >/dev/null; then
        success "Patched $outputfile"
        count=$((count + 1))
    else
        error "Failed to patch $outputfile"
    fi
done

# Cleanup Stage
info "Starting cleanup stage..."
rm -f *.zip *.bps

success "All stages completed successfully!"
info "Total ROM hacks patched: \033[1;35m$count\033[0m"
