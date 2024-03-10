"""Working with package_config.json files and related."""

load(
    "//dart/private:providers.bzl",
    "DartPackageInfo",
)

# buildifier: disable=function-docstring
def _dart_packages_impl(ctx):
    return [
        DartPackageInfo(
            config = ctx.attr.config,
        ),
    ]

dart_packages = rule(
    implementation = _dart_packages_impl,
    attrs = {
        "config": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
    doc = "Provides access to the package_config.json file for a Dart package.",
)
