"Bazel provider for pointing to a `package_config.json` file."

DartPackageConfigInfo = provider(
    "Provider for a Dart package configuration",
    fields = {
        "file": "The `package_config.json` file.",
    },
)
