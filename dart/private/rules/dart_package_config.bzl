"""Reading and referencing package_config.json files."""

load(
    "//dart/private:providers.bzl",
    "DartPackageConfigInfo",
)

_DOC = """\
Provides access to the package_config.json file for a Dart project.

When using Dart with the "pub" package manager, the `package_config.json` file
is automatically generated by `pub get` and `pub upgrade` commands. This rule
consumes an existing or generated `package_config.json` file and provides access
to its contents for use in other rules.

For example given the following directory structure:

```txt
./
  .dart_tool/
    package_config.json
  BUILD.bazel
  WORKSPACE.bazel
```

```starlark
# BUILD.bazel

load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_package_config")

dart_package_config(
    name = "package_config",
    src = ":.dart_tool/package_config.json",
)
```

In practice, at least for Bazel projects, the `package_config.json` file will
typically be generated by another rule, such as `dart_package_config_gen`, or
implicitly by macros like `dart_binary`.
"""

_ATTRS = {
    "src": attr.label(
        doc = "The package_config.json file to read.",
        allow_single_file = True,
        mandatory = True,
    ),
}

def _impl(ctx):
    return [DartPackageConfigInfo(ctx.file.src)]

dart_package_config = rule(
    implementation = _impl,
    attrs = _ATTRS,
    doc = _DOC,
)