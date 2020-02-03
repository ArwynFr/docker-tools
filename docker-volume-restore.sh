#!/bin/bash

if [[ $# -ne 2 ]]; then
  echo "Usage : $0 VOLUME FILENAME"
  echo
  echo "Restores a volume from a tgz archive"
  echo "If the volume does not exists, it will be created"
  exit 1
fi

VOLUME=$1
FILENAME=$2

if [[ ! -f $FILENAME ]]; then
  echo "Filename $FILENAME not found"
  exit 2
fi

docker volume inspect "$VOLUME" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  docker volume rm "$VOLUME" >/dev/null
fi

docker volume create "$VOLUME" >/dev/null
(docker run --rm --interactive --workdir /volume --volume "$VOLUME:/volume" alpine tar xzf -) < "$FILENAME"
