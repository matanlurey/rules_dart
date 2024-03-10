# Dart rules for [Bazel](https://bazel.build/)

This is an unofficial set of rules for using Dart with Bazel.

Support is limited to a single configuration:

- Bazel 7 using `WORKSPACE` and `Bzlmod`;
- Dart 3.3.1;
- ARM64 Macs.

## Usage

[`Bzlmod`](https://docs.bazel.build/versions/main/bzlmod.html) is required to
use these rules.

Add the following to your `MODULE.bazel` file:

```starlark
dart = use_extension("@dev_lurey_rules_dart//dart:extensions.bzl", "dart")
dart.toolchain(
    name = "dart",
    version = "3.3.1",
)
```

## Contributing

Follow the official style guide at <https://bazel.build/rules/deploying>.

## See also

- <https://github.com/bazel-contrib/rules-template>
- <https://github.com/bazelbuild/examples/tree/main/rules>
