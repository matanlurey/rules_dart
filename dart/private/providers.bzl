"""Providers for interopability between rules."""

DartBinaryInfo = provider(
    "Provider for Dart files",
    fields = {
        "binary": "Main Dart script.",
    },
)

DartLibraryInfo = provider(
    "Provider for Dart libraries",
    fields = {
        "transitive_srcs": "Transitive Dart sources.",
    },
)

DartPackageInfo = provider(
    "Provider for Dart package configuration",
    fields = {
        "config": "package_config.json file.",
    },
)

def get_transitive_srcs(srcs, deps):
    """Obtain the source files for a target and its transitive dependencies.

    Args:
        srcs: a list of source files
        deps: a list of targets that are direct dependencies
    Returns:
        a collection of the transitive sources
    """
    return depset(
        srcs,
        transitive = [dep[DartLibraryInfo].transitive_srcs for dep in deps],
    )

def get_transitive_runfiles(runfiles, srcs, data, deps):
    """Obtain the runfiles for a target, its transitive data files and dependencies.

    Args:
        runfiles: the runfiles
        srcs: a list of source files
        data: a list of data files
        deps: a list of targets that are direct dependencies
    Returns:
        the runfiles
    """
    transitive_runfiles = []
    for targets in (srcs, data, deps):
        for target in targets:
            transitive_runfiles.append(target[DefaultInfo].default_runfiles)
    return runfiles.merge_all(transitive_runfiles)
