"""Extensions for bzlmod.

Installs a dart toolchain.
Every module can define a toolchain version under the default name, "dart".
The latest of those versions will be selected (the rest discarded),
and will always be registered by rules_dart.

Additionally, the root module can define arbitrarily many more toolchain versions under different
names (the latest version will be picked for each name) and can register them as it sees fit,
effectively overriding the default named toolchain due to toolchain resolution precedence.
"""

load(":repositories.bzl", "dart_register_toolchains")

_DEFAULT_NAME = "dart"

dart_toolchain = tag_class(attrs = {
    "name": attr.string(doc = """\
Base name for generated repositories, allowing more than one dart toolchain to be registered.
Overriding the default is only permitted in the root module.
""", default = _DEFAULT_NAME),
    "version": attr.string(doc = "Explicit version of dart.", mandatory = True),
})

def _toolchain_extension(ctx):
    registrations = {}
    for mod in ctx.modules:
        for toolchain in mod.tags.toolchain:
            if toolchain.name != _DEFAULT_NAME and not mod.is_root:
                fail("""\
                Only the root module may override the default name for the dart toolchain.
                This prevents conflicting registrations in the global namespace of external repos.
                """)
            if toolchain.name not in registrations.keys():
                registrations[toolchain.name] = []
            registrations[toolchain.name].append(toolchain.version)
    for name, versions in registrations.items():
        if len(versions) > 1:
            # TODO: Should be semver-aware, using MVS
            selected = sorted(versions, reverse = True)[0]

            # buildifier: disable=print
            print("NOTE: dart toolchain {} has multiple versions {}, selected {}".format(name, versions, selected))
        else:
            selected = versions[0]

        dart_register_toolchains(
            name = name,
            version = selected,
        )

dart = module_extension(
    implementation = _toolchain_extension,
    tag_classes = {
        "toolchain": dart_toolchain,
    },
)
