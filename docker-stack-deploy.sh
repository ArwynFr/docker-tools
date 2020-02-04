#!/bin/bash

STACK_NAME=${1%/}
STACK_ROOT=${STACK_ROOT:-.}
STACK_PATH=$STACK_ROOT/$STACK_NAME
STACK_COMPOSE=$STACK_PATH/docker-compose.yml

if [[ $# -ne 1 ]]; then
  echo "Usage : $0 STACK"
  echo
  echo "Deploys a docker stack to the local swarm manager."
  echo
  echo " The script looks for a file named \$STACK_ROOT/STACK/docker-compose.yml."
  echo " If the stack already exists, it is dropped and created again."
  echo " The latest image is always pulled before recreating the stack."
  echo " If \$GITHUB_USERNAME and \$GITHUB_TOKEN are provided, the script will also docker login."
  echo " If the \$STACK_ROOT varaiable is undefined, the script will use current working directory."
  echo
  exit 1
fi

if [[ ! -d $STACK_PATH ]]; then
  echo "Stack $STACK_PATH not found"
  exit 2
fi

if [[ ! -f $STACK_COMPOSE ]]; then
  echo "$STACK_COMPOSE file not found"
  exit 3
fi

if [[ (! -z "$GITHUB_TOKEN") && (! -z "$GITHUB_USERNAME") ]]; then
    docker login docker.pkg.github.com --username "$GITHUB_USERNAME" --password "$GITHUB_TOKEN"
fi

docker-compose --file "$STACK_COMPOSE" pull

if [[ $(docker stack ls | grep --count "^$STACK_NAME[[:space:]]") -eq 1 ]]; then
    docker stack rm "$STACK_NAME"
fi

docker stack deploy --compose-file "$STACK_COMPOSE" "$STACK_NAME"
