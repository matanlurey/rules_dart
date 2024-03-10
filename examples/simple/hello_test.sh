#!/bin/sh

# Fail on any error.
set -e

# Path to your binary.
binary_path="$1"
shift

# Check if the path is valid.
if [[ ! -f "$binary_path" ]]; then
  echo "Binary not found: $binary_path"
  exit 1
else
  echo "Using binary at $binary_path"
fi

# Run the binary and capture the output
output=$($binary_path)

# Expected output (adjust this)
expected_output="Hello, world!"

# Simple assertion
if [[ "$output" == "$expected_output" ]]; then
  echo "Test PASSED"
  exit 0
else
  echo "Test FAILED: Output did not match expected: $expected_output"
  echo "Actual output: $output"
  exit 1
fi
