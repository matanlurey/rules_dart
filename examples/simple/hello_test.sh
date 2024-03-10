#!/bin/sh

# Fail on any error.
set -e

# Path to your binary.
binary_path="./hello.sh"

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
