"""Dart library rule."""

load(
    "//dart/private:providers.bzl",
    "DartLibraryInfo",
    "DartPackageRootInfo",
    "get_transitive_deps",
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

def _path_to_package_name(path):
    return path.replace("/", ".")

def _dart_library_impl(ctx):
    # Fail on empty srcs.
    if not ctx.files.srcs:
        fail("No source files provided.")

    transitive_deps = get_transitive_deps(ctx.attr.deps).to_list()
    transitive_srcs = get_transitive_srcs(ctx.files.srcs, ctx.attr.deps).to_list()
    runfiles = ctx.runfiles(transitive_srcs)
    runfiles = get_transitive_runfiles(runfiles, srcs = ctx.attr.srcs, data = [], deps = ctx.attr.deps)

    # TODO: This is a not a good way to determine the package name.
    package_name = ""
    if ctx.label.package != "":
        package_name = _path_to_package_name(ctx.label.package)
    else:
        package_name = ctx.label.name

    package_root = ""
    if ctx.label.workspace_root != "":
        package_root = ctx.label.workspace_root + ctx.label.package
    else:
        package_root = ctx.label.package

    providers = [
        DefaultInfo(
            files = depset(transitive_srcs),
            runfiles = runfiles,
        ),
        DartLibraryInfo(
            transitive_deps = depset(transitive_deps),
            transitive_srcs = depset(transitive_srcs),
        ),
        DartPackageRootInfo(
            name = package_name,
            root = package_root,
        ),
    ]

    return providers

dart_library = rule(
    implementation = _dart_library_impl,
    attrs = ATTRS,
    provides = [DartLibraryInfo],
    doc = "Creates a Dart library from the given source files.",
)
