"""Pub module extension."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_package = tag_class(
    attrs = {
        "name": attr.string(
            doc = "Base name for generated repositories.",
            mandatory = True,
        ),
        "version": attr.string(
            doc = "Version of the package.",
            mandatory = True,
        ),
        "sha256": attr.string(
            doc = "SHA256 of the package.",
            mandatory = True,
        ),
        "build_file": attr.label(
            doc = "Build file for the package.",
            allow_single_file = True,
            mandatory = True,
        ),
    },
)

def _pub_impl(ctx):
    packages = {}
    for mod in ctx.modules:
        for pkg in mod.tags.package:
            packages[pkg.name] = pkg
    for name, pkg in packages.items():
        # Example format: https://pub.dev/packages/meta/versions/1.12.0.tar.gz.
        url = "https://pub.dev/packages/{}/versions/{}.tar.gz".format(name, pkg.version)
        http_archive(
            name = name,
            urls = [url],
            sha256 = pkg.sha256,
            build_file = pkg.build_file,
        )

pub = module_extension(
    implementation = _pub_impl,
    tag_classes = {
        "package": _package,
    },
)
