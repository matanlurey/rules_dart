"""Dart library rule."""

load(
    "//dart/private:providers.bzl",
    "DartLibraryInfo",
    "get_transitive_runfiles",
    "get_transitive_srcs",
)

ATTRS = {
    "srcs": attr.label_list(
        allow_files = True,
        doc = "Dart source files used to build the library.",
    ),
    "deps": attr.label_list(
        doc = "List of other Dart libraries the target depends on.",
        providers = [DartLibraryInfo],
    ),
}

def _dart_library_impl(ctx):
    transitive_srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps).to_list()
    runfiles = ctx.runfiles(transitive_srcs)
    runfiles = get_transitive_runfiles(runfiles, srcs = ctx.attr.srcs, data = [], deps = ctx.attr.deps)

    return [
        DefaultInfo(
            files = depset(transitive_srcs),
            runfiles = runfiles,
        ),
        DartLibraryInfo(
            transitive_srcs = depset(transitive_srcs),
        ),
    ]

dart_library = rule(
    implementation = _dart_library_impl,
    attrs = ATTRS,
    doc = "Creates a Dart library from the given source files.",
)