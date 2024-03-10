#!/bin/sh

# Fail on any error.
set -e

# Print all arguments for debugging.
echo "Arguments: $@"

# Run the binary and capture its stdout
output=$(exec $1)

# Check the output
echo "Output: $output"
if [ "$output" != "Hello, world!" ]; then
  echo "TEST FAIL: Unexpected output: $output"
  exit 1
echo 
  echo "TEST PASS"
fi
