"""Providers for interopability between rules."""

DartFilesInfo = provider(
    "Provider for Dart files",
    fields = {
        "binary": "Main Dart script.",
    },
)

DartPackageInfo = provider(
    "Provider for Dart package configuration",
    fields = {
        "config": "package_config.json file.",
    },
)
