"""Implements the Dart toolchain rule.
"""

DartInfo = provider(
    doc = "Information about how to invoke the Dart toolchain.",
    fields = {
        "dart_bin": "The Dart executable for the target platform.",
    },
)

# Avoid using non-normalized paths (workspace/../other_workspace/path)
def _to_manifest_path(ctx, file):
    if file.short_path.startswith("../"):
        return "external/" + file.short_path[3:]
    else:
        return ctx.workspace_name + "/" + file.short_path

def _dart_toolchain_impl(ctx):
    if not ctx.attr.dart_bin:
        fail("Must set \"dart_bin\" attribute to the dart executable.")

    # Make the $(tool_BIN) varaible available in places like genrules.
    tool_files = ctx.attr.dart_bin.files.to_list()
    template_variables = platform_common.TemplateVariableInfo({
        "DART_BIN": _to_manifest_path(ctx, tool_files[0]),
    })

    default = DefaultInfo(
        files = depset([]),
        runfiles = ctx.runfiles(files = []),
    )
    dartinfo = DartInfo(dart_bin = ctx.attr.dart_bin)

    # Export all of the providers inside our ToolchainInfo so that the
    # resolved_toolchain rule can grab and re-export them.
    toolchain_info = platform_common.ToolchainInfo(
        dart = dartinfo,
        template_variables = template_variables,
        default = default,
    )

    return [
        default,
        toolchain_info,
        template_variables,
    ]

dart_toolchain = rule(
    implementation = _dart_toolchain_impl,
    attrs = {
        "dart_bin": attr.label(
            doc = "The Dart executable for the target platform.",
            mandatory = True,
            allow_single_file = True,
        ),
    },
    doc = """Defines a dart runtime toolchain.

For usage see https://docs.bazel.build/versions/main/toolchains.html#defining-toolchains.
""",
)
