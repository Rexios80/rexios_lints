These are the linting rules I use for my Flutter and Dart projects

## Getting started

Add this package to your dev_dependencies in `pubspec.yaml`:
```yaml
dev_dependencies:
  rexios_lints: latest
```

## Usage

This package includes four different sets of linting rules. Add the relevant line to the top of your `analysis_options.yaml` file.

Dart project:
```yaml
include: package:rexios_lints/dart/core.yaml
```

Dart package:
```yaml
include: package:rexios_lints/dart/package.yaml
```

Flutter project:
```yaml
include: package:rexios_lints/flutter/core.yaml
```

Flutter package:
```yaml
include: package:rexios_lints/flutter/package.yaml
```

## Justification

Core:

| Lint                              | Reason                            |
| --------------------------------- | --------------------------------- |
| always_declare_return_types       | Prevents accidental dynamic calls |
| always_use_package_imports        | Consistency                       |
| avoid_types_on_closure_parameters | Brevity                           |

Package:

| Lint | Reason |
| ---- | ------ |
|      |        |
