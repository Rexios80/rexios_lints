These are the linting rules I use for my Flutter and Dart projects

## Getting started

Add this package to your dev_dependencies in `pubspec.yaml`:
```yaml
dev_dependencies:
  rexios_lints: ^1.0.0
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