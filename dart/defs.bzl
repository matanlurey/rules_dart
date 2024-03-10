"""Public API for rules."""

load("//dart/private/rules:dart_binary.bzl", _dart_binary = "dart_binary")
load("//dart/private/rules:dart_library.bzl", _dart_library = "dart_library")
load("//dart/private/rules:dart_packages.bzl", _dart_packages = "dart_packages")

dart_binary = _dart_binary
dart_library = _dart_library
dart_packages = _dart_packages
