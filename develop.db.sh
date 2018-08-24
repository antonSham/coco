#!/usr/bin/env bash

DATABASE="$1"

if [ -z "$DATABASE" ]
then
  DATABASE="api_development"
fi

./develop.sh exec db psql -U postgres "$DATABASE"
