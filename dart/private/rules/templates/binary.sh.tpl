#!/usr/bin/env bash

# Resolve the runfiles directory.
{rlocation_function}

# Provide a realpath implementation for macOS.
realpath() (
  OURPWD=$PWD
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  cd "$OURPWD"
  echo "$REALPATH"
)

export RUNFILES_DIR="$(realpath "${RUNFILES_DIR:-$0.runfiles}")"

entrypoint=$(rlocation {entrypoint})

exec {dart_binary_name} {dart_binary_args} $entrypoint "$@"
