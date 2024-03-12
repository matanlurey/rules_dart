"""Implementation details for dart_binary."""

load(
    "//dart/private:providers.bzl",
    "DartBinaryInfo",
    "DartLibraryInfo",
    "DartPackageConfigInfo",
)
load(
    "//dart/private/rules:dart_package_config_gen.bzl",
    "dart_package_config_gen",
)

ATTRS = {
    "main": attr.label(
        executable = True,
        allow_single_file = True,
        cfg = "exec",
        doc = """
Dart script to run.
        """,
    ),
    "srcs": attr.label_list(
        allow_files = True,
        cfg = "exec",
        doc = """
Source files to include in the binary.
        """,
    ),
    "deps": attr.label_list(
        cfg = "exec",
        doc = """
Additional dependencies to include in the binary.
        """,
        providers = [DartLibraryInfo],
    ),
    "packages": attr.label(
        default = None,
        allow_single_file = True,
        providers = [DartPackageConfigInfo],
    ),
    "_binary_sh_tpl": attr.label(
        allow_single_file = True,
        default = "@dev_lurey_rules_dart//dart/private/rules/templates:binary.sh.tpl",
    ),
    "_runfiles_library": attr.label(
        doc = "The runfiles library to use.",
        allow_single_file = True,
        default = "@bazel_tools//tools/bash/runfiles",
    ),
}

# https://github.com/aspect-build/bazel-lib/blob/ddac9c46c3bff4cf8d0118a164c75390dbec2da9/lib/paths.bzl
_BASH_RLOCATION_FUNCTION = r"""
# --- begin runfiles.bash initialization v2 ---
set -uo pipefail; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
source "$0.runfiles/$f" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
{ echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v2 ---
"""

def generate_dart_binary_script(ctx, dart_executable, dart_main):
    script = ctx.actions.declare_file("{}.sh".format(ctx.label.name))
    args = []

    # Create a default package config if none is provided.
    packages = ctx.attr.packages

    # Optionally, add --packages argument to the Dart binary.
    if ctx.attr.packages:
        packages = ctx.attr.packages[DartPackageConfigInfo]
        args.append("--packages={}".format(packages.file.short_path))

    dart_binary_name = dart_executable.files.to_list()[0].path
    dart_main_full_path = "%s/%s" % (ctx.workspace_name, dart_main.path)

    ctx.actions.expand_template(
        template = ctx.file._binary_sh_tpl,
        output = script,
        is_executable = True,
        substitutions = {
            "{dart_binary_args}": " ".join(args),
            "{dart_binary_name}": dart_binary_name,
            "{entrypoint}": dart_main_full_path,
            "{rlocation_function}": _BASH_RLOCATION_FUNCTION,
        },
    )

    return script

def _impl(ctx):
    # Find the dart executable.
    toolchain = ctx.toolchains["@dev_lurey_rules_dart//dart:toolchain_type"]
    dart_bin = toolchain.dart.dart_bin

    executable = ctx.executable.main
    if ctx.attr.main and DartBinaryInfo in ctx.attr.main and ctx.attr.main[DartBinaryInfo].binary:
        executable = ctx.attr.main[DartBinaryInfo].binary

    script = generate_dart_binary_script(
        ctx,
        dart_executable = dart_bin,
        dart_main = executable,
    )

    runfiles = [executable]
    if ctx.attr.packages:
        runfiles.append(ctx.attr.packages[DartPackageConfigInfo].file)

    # Add srcs to runfiles.
    runfiles.extend(ctx.files.srcs)

    # Adds deps to runfiles.
    runfiles.extend(ctx.files.deps)

    # Add runfiles support library to runfiles.
    runfiles.append(ctx.file._runfiles_library)

    # Add the toolchain to runfiles.
    runfiles.extend(dart_bin.files.to_list())

    return [
        DefaultInfo(
            executable = script,
            runfiles = ctx.runfiles(runfiles),
        ),
        DartBinaryInfo(
            binary = executable,
        ),
    ]

_dart_binary = rule(
    implementation = _impl,
    attrs = dict(
        ATTRS,
    ),
    executable = True,
    toolchains = ["@dev_lurey_rules_dart//dart:toolchain_type"],
    doc = "Runs a Dart binary.",
)

def dart_binary(
        name,
        packages = None,
        deps = None,
        **kwargs):
    """Create a dart_binary target.

    Args:
        name: The name of the target.
        packages: The package_config to use for this target.
          If not provided, one will be created.
        deps: A list of dependencies for this target.
        **kwargs: Additional arguments to pass to the dart_binary rule.

    Returns:
        A dart_binary target.
"""
    if not packages:
        packages = "%s.package_config" % name
        dart_package_config_gen(
            name = packages,
            out = "%s.package_config.json" % name,
            deps = deps,
        )
    return _dart_binary(
        name = name,
        packages = packages,
        deps = deps,
        **kwargs
    )
