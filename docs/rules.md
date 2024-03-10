# `rules_dart`

<!-- TODO: Make this auto-generated. -->

## `dart_binary`

Creates a new Dart binary target.

```starlark
load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_binary")

dart_binary(
    name = "example",
    main = ["example.dart"],
)
```

* `name`: The name of the target (required).
* `main`: The entrypoint Dart file (required).
* `srcs`: Additional source files to include in the binary.
* `deps`: Additional `dart_library` dependencies to import in the binary.
* `packages`: [`dart_package_config`](#dart_package_config) target to resolve package URIs.

## `dart_library`

Creates a new Dart library target.

```starlark
load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_library")

dart_library(
    name = "example",
    srcs = ["example.dart"],
)
```

* `name`: The name of the target (required).
* `srcs`: The source files to include in the library (required).
* `deps`: Additional `dart_library` dependencies to import in the library.

## `dart_package_config`

Resolves Dart package URIs to their corresponding Bazel targets.

```starlark
load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_package_config")

dart_package_config(
    name = "package_config",
    deps = [
        "//packages/foo",
    ],
)
```
