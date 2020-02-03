#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage : $0 VOLUME FILENAME"
  echo
  echo "Creates a tgz archive of the volume content"
  exit 1
fi

VOLUME=$1
FILENAME=$2

docker volume inspect "$VOLUME" >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Volume $VOLUME was not found"
  exit 2
fi

# FIXME support --force to overwrite the file
if [[ -e $FILENAME ]]; then
  echo "Filename $FILENAME already exists"
  exit 3
fi

docker run --rm --workdir /volume --volume "$VOLUME:/volume:ro" alpine tar czf - . > "$FILENAME"
