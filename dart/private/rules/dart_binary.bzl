"""Implementation details for dart_binary."""

load(
    "//dart/private:providers.bzl",
    "DartFilesInfo",
    "DartPackageInfo",
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
    "packages": attr.label(
        default = None,
        providers = [DartPackageInfo],
    ),
    "_binary_sh_tpl": attr.label(
        allow_single_file = True,
        default = "@dev_lurey_rules_dart//dart/private/rules/templates:binary.sh.tpl",
    ),
}

# buildifier: disable=function-docstring
def generate_dart_binary_script(ctx, binary):
    toolchain = ctx.toolchains["@dev_lurey_rules_dart//dart:toolchain_type"]
    script = ctx.actions.declare_file("{}.sh".format(ctx.label.name))
    args = []

    # Optionally, add --packages argument to the Dart binary.
    if ctx.attr.packages:
        packages = ctx.attr.packages[DartPackageInfo]
        args.append("--packages={}".format(packages.config.files.to_list()[0].path))

    ctx.actions.expand_template(
        template = ctx.file._binary_sh_tpl,
        output = script,
        is_executable = True,
        substitutions = {
            "{dart_binary_args}": " ".join(args),
            "{dart_binary_name}": toolchain.dart.dart_bin.files.to_list()[0].basename,
            "{binary}": binary.path,
        },
    )

    return script

# buildifier: disable=function-docstring
def dart_binary_impl(ctx):
    executable = ctx.executable.main
    if ctx.attr.main and DartFilesInfo in ctx.attr.main and ctx.attr.main[DartFilesInfo].binary:
        executable = ctx.attr.main[DartFilesInfo].binary
    script = generate_dart_binary_script(ctx, executable)

    runfiles = [executable]
    if ctx.attr.packages:
        runfiles.extend(ctx.attr.packages[DartPackageInfo].config.files.to_list())

    # Add srcs to runfiles.
    runfiles.extend(ctx.files.srcs)

    return [
        DefaultInfo(
            executable = script,
            files = depset([]),
            runfiles = ctx.runfiles(runfiles),
        ),
        DartFilesInfo(
            binary = executable,
        ),
    ]

dart_binary = rule(
    implementation = dart_binary_impl,
    attrs = dict(
        ATTRS,
    ),
    executable = True,
    toolchains = ["@dev_lurey_rules_dart//dart:toolchain_type"],
    doc = """
Runs a Dart binary.
""",
)
