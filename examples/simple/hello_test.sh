#!/bin/sh

# Fail on any error.
set -e

# Print all arguments for debugging.
echo "Arguments: $@"

# Run the binary.
exec $1
