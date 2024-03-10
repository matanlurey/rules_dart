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
* `packages`: [`dart_packages`](#dart_packages) target to resolve package URIs.

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

## `dart_packages`

Resolves Dart package URIs to their corresponding Bazel targets.

> [!NOTE]
> This is a very early version of this rule, and requires using an external
> `dart pub` command to generate the `package_config.json` file, or it has to
> be manually created.
>
> For example, for the following directory structure:
>
> ```txt
> ├── .dart_tool
> │   └── package_config.json
> └── lib
>     └── example.dart
> ```

> The `.dart_tool/package_config.json` file would look like:
>
> ```json
> {
>   "configVersion": 2,
>   "packages": [
>     {
>       "name": "example",
>       "rootUri": "../",
>       "packageUri": "lib/",
>       "languageVersion": "3.0"
>     }
>   ]
> }
> ```

```starlark
load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_packages")

dart_packages(
    name = "packages",
    config = ":.dart_tool/package_config.json",
)
```
