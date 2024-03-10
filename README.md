# Dart rules for [Bazel](https://bazel.build/)

This is an unofficial set of rules for using Dart with Bazel.

[![CI](https://github.com/matanlurey/rules_dart/actions/workflows/ci.yml/badge.svg)](https://github.com/matanlurey/rules_dart/actions/workflows/ci.yml)

Support is limited to:

- Bazel 7 using `WORKSPACE` and `Bzlmod`;
- [ARM64 Macs][][^slow], [Intel Macs][], or [Linux x64][].

[arm64 macs]: https://github.com/search?q=repo%3Amatanlurey%2Frules_dart+%22macos-arm64%22&type=code
[intel macs]: https://github.com/search?q=repo%3Amatanlurey%2Frules_dart+%22macos-x64%22&type=code
[linux x64]: https://github.com/search?q=repo%3Amatanlurey%2Frules_dart%20%22linux-x64%22&type=code

[^slow]: 
    The GitHub action runners are extremely slow to queue on ARM64 Macs, and as
    a result are only run once a day. 

In addition, only Dart `3.3.1` is tested on CI.

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

To automatically generate (some) parts of `BUILD.bazel` files:

```sh
bazel run //:gazelle update
```

To format the rules:

```sh
bazel run //:buildifier.fix
```

To run the tests:

```sh
bazel test //...
```

### Adding a new version

See [`versions.bzl`](./dart/private/versions.bzl).

## See also

- <https://github.com/bazel-contrib/rules-template>
- <https://github.com/bazelbuild/examples/tree/main/rules>
