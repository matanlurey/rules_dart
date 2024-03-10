"""Public API for rules."""

load("//dart/private/rules:compute_pub_deps.bzl", _compute_pub_deps = "compute_pub_deps")
load("//dart/private/rules:dart_binary.bzl", _dart_binary = "dart_binary")

compute_pub_deps = _compute_pub_deps
dart_binary = _dart_binary
