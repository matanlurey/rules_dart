# Bazel Implementation Notes

## Writing rules

See <https://bazel.build/extending/rules> for a guide on writing custom rules.

Rules that process source code usually define the following `attrs`:

- `srcs`: source files processed by the rule.
- `deps`: other rules that this rule depends on, typically gated by 
  `providers`.
- `data`: files to be made available at runtime to any `executable` rule
   that depends on this rule.

For example:

```starlark
example_library = rule(
    implementation = _example_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = [".example"]),
        "deps": attr.label_list(providers = [ExampleInfo]),
        "data": attr.label_list(allow_files = True),
        ...
    },
)
```

_Private_ (`_`-prefixed) attributes are typically created with an _implicit_
(default) dependency on tools that reside in the same repository as the rule
definition:

```starlark
_example_library_impl = implementation(
    implementation = _example_library_impl,
    attrs = {
        ...
        "_compiler": attr.label(
            default = Label("//tools:compiler"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)
```

If the tool comes from the [execution platform](https://bazel.build/extending/platforms)
or a different repository, the rule should instead obtain that tool from a
[toolchain](https://bazel.build/extending/toolchains):

```starlark
_example_library_impl = implementation(
    implementation = _example_library_impl,
    attrs = {
        ...
    },
    toolchains = ["@my_toolchain//:toolchain_type"],
    ...
)
```
