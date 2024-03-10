"""Rules to verify and optionally update, a pubspec.lock file."""

# buildifier: disable=function-docstring
def _dart_pub_impl(_ctx):
    return []

dart_pub = rule(
    implementation = _dart_pub_impl,
    attrs = {
        "yaml_file": attr.label(
            allow_single_file = True,
            default = "pubspec.yaml",
            doc = "The pubspec.yaml file to validate and/or update.",
        ),
        "lock_file": attr.label(
            allow_single_file = True,
            default = "pubspec.lock",
            doc = "The pubspec.lock file to validate and/or update.",
        ),
    },
)

# buildifier: disable=function-docstring
def compute_pub_deps(
        name,
        src = None,
        visibility = ["//visibility:private"],
        tags = None,
        **kwargs):
    """Generates targets for managing pub dependencies with "dart pub".

    It generates three targets:
    - validate with `bazel test [name]_test`
    - update with `bazel run [name].update`
    - upgrade with `bazel run [name].upgrade`

    If you are using a version control system, the pubspec.lock generated by
    this rule should be checked into it to ensure that all developers/users have
    the same dependency versions.

    Args:
        name: base name for generated targets, typically "pubspec".
        src: file containing inputs to dependency resolution. If not specified,
            defaults to `pubspec.yaml`.
        tags: tagging attribute common to all build rules, passed to both the _test and .update rules.
        visibility: passed to both the _test and .update rules.
        **kwargs: other bazel attributes passed to the "_test" rule.
    """
    src = src or "pubspec.yaml"