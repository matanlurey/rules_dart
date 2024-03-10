"""Mirror of release info.

TODO: Generate this file.
"""

# The integrity hashes can be computed with
# shasum -b -a 384 [downloaded file] | awk '{ print $1 }' | xxd -r -p | base64
#
# See: https://dart.dev/get-dart/archive.
TOOL_VERSIONS = {
    "3.3.1": {
        "linux-x64": "sha384-U9XMbL1psUYMRAAEGuXDfZxtUWTyo+fdeXEJQHDudYfrsHSe0/nQV4UY69TZMIFi",
        "macos-arm64": "sha384-m1xdNg5b/9HUxBGRmsHZ4AhoXF2dvfwNNMlGrb99KUvPJAqCe3dqJM/Q4mIROoPO",
        "macos-x64": "sha384-dU/3SqLPsexypM7fyzeqv2HcqTSjX7ULYuf11jSyZP1FKg4ug1uRdFaBVwNBL+ya",
    },
}
