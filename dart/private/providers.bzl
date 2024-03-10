"""Providers for interopability between rules."""

DartFilesInfo = provider(
    "Provider for Dart files",
    fields = {
        "binary": "Main Dart script.",
    },
)
