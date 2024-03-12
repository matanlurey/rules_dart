"Bazel provider for defining files that can be imported by a `package:` URI."

DartPackageRootInfo = provider(
    """\
Provider for a Dart package root.

A package root is a directory that is resolved by Dart tools when resolving a
`package:` URI. This provider allows you to define a package root for a
particular target.

```starlark
DartPackageRootInfo(
    name = "my_package",
    root = "packages/my_package",
)
```
""",
    fields = {
        "name": "Name of the package.",
        "root": "The directory that is the package root.",
    },
)
