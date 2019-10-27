#!/bin/bash

TARGET=/var/www/html/flickr/
SRC=/media/public/incoming/

if [ "$#" -eq 0 ]; then
    echo "nothing to upload"
    exit 1
fi

for i in "$@"; do
    if [ ! -d ${SRC}"$i" ]; then
	echo "invalid src: $i"
	continue
    fi
    N=find "${SRC}${i}" -type f | egrep ".jpg|.png" | wc -l

    DEST=${TARGET}$(basename "${i}")

    mkdir -p "${DEST}/.tn/"
    if [ $? -ne 0 ]; then
	echo "failed to created target dir: ${DEST}"
	continue
    fi
    rsync -vauht "${SRC}${i}"/*.{jpg,png} "$DEST"
    for j in "$DEST"/*.{jpg,png}; do
	convert -resize 300 -quality 50 "$j" "${DEST}"/.tn/$(basename "$j")
    done
    cd "${DEST}" && ln -s ../_index.html index.html && cd -
done
