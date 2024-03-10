"""Public API for rules."""

load("//dart/private/rules:dart_binary.bzl", _dart_binary = "dart_binary")
load("//dart/private/rules:dart_library.bzl", _dart_library = "dart_library")
load(
    "//dart/private/rules:dart_packages.bzl",
    _dart_package_config = "dart_package_config",
)

def dart_binary(
        name,
        packages = None,
        deps = None,
        **kwargs):
    """Create a dart_binary target.

    Args:
        name: The name of the target.
        packages: The package_config to use for this target.
          If not provided, one will be created.
        deps: A list of dependencies for this target.
        **kwargs: Additional arguments to pass to the dart_binary rule.

    Returns:
        A dart_binary target.
"""
    if not packages:
        packages = "%s.package_config" % name
        dart_package_config(
            name = packages,
            out = "%s.package_config.json" % name,
            deps = deps,
        )
    return _dart_binary(
        name = name,
        packages = packages,
        deps = deps,
        **kwargs
    )

dart_library = _dart_library
dart_package_config = _dart_package_config
