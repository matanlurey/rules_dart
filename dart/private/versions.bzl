"""Mirror of release info.

TODO: Generate this file.
"""

# The integrity hashes can be computed with
# shasum -b -a 384 [downloaded file] | awk '{ print $1 }' | xxd -r -p | base64
TOOL_VERSIONS = {
    "3.3.1": {
        "macos-arm64": "sha384-m1xdNg5b/9HUxBGRmsHZ4AhoXF2dvfwNNMlGrb99KUvPJAqCe3dqJM/Q4mIROoPO",
    },
}
