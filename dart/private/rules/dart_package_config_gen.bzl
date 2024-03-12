"Implementation details for generating a `package_config.json` file."

load(
    "//dart/private:providers.bzl",
    "DartLibraryInfo",
    "DartPackageConfigInfo",
    "DartPackageRootInfo",
    "get_transitive_deps",
)

_DOC = """\
Generates a `package_config.json` file from a set of transitive dependencies.

For example, given the following directory structure:

```txt
./
├── packages/
│   ├── foo/
│   │   ├── lib/
│   │   └── BUILD.bazel
│   └── bar/
│       ├── lib/
│       └── BUILD.bazel
├── BUILD.bazel
└── WORKSPACE.bazel
```

If the root `BUILD.bazel` file contains the following:

```starlark
# BUILD.bazel

load("@dev_lurey_rules_dart//dart:defs.bzl", "dart_package_config")

dart_package_config_gen(
    name = "package_config",
    deps = [
        "//packages/foo",
        "//packages/bar",
    ],
)
```

Then a `package_config.json` file similar to the following will be generated:

```json
{
  "configVersion": 2,
  "packages": [
    {
      "name": "packages.foo",
      "rootUri": "packages/foo",
      "packageUri": "lib/",
    },
    {
      "name": "packages.bar",
      "rootUri": "packages/bar",
      "packageUri": "lib/",
    }
  ]
}
```

Note that package names are derived from the relative path from the root of the
workspace to the package's `BUILD.bazel` file, in contrast to external packages
or names you might expect from a `pubspec.yaml` file.
"""

_ATTRS = {
    "deps": attr.label_list(
        doc = """\
A list of dependencies to include in the generated package config.

Each dependency must be a label to a `dart_library` target.

Dependencies are walked transitively, so you do not need to include
dependencies of dependencies, similar to any other list of dependencies in
Bazel.
""",
        providers = [DartLibraryInfo],
    ),
    "out": attr.output(
        doc = """\
The output file to write the generated package config to.

If not provided, the default is `package_config.json` in the same directory as
the `BUILD.bazel` file that contains the `dart_package_config_gen` rule.
""",
    ),

    # TODO: Provide an attribute (relative file path) where all packages
    # directly nested within it do not have their names prefixed with the
    # relative file path, i.e. a typical `third_party/` or `third_party/dart/`
    # directory for a larger mono-repo.
}

_CONFIG_VERSION = 2

def _impl(ctx):
    packages = []
    for dep in get_transitive_deps(ctx.attr.deps).to_list():
        pkg_root = dep[DartPackageRootInfo]
        if not pkg_root:
            continue
        packages.append(
            {
                "name": pkg_root.name,
                "rooUri": pkg_root.root,
                "packageUri": "lib/",
            },
        )
    out = ctx.actions.declare_file(
        ctx.attr.out.name if ctx.attr.out else "package_config.json",
    )
    ctx.actions.write(
        out,
        content = json.encode_indent({
            "configVersion": _CONFIG_VERSION,
            "packages": packages,
        }),
    )

    return [
        DefaultInfo(
            files = depset([out]),
        ),
        DartPackageConfigInfo(
            file = out,
        ),
    ]

dart_package_config_gen = rule(
    doc = _DOC,
    attrs = _ATTRS,
    implementation = _impl,
)
