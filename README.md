These are the linting rules I use for my Flutter and Dart projects

## Getting started

Add this package to your dev_dependencies in `pubspec.yaml`:
```yaml
dev_dependencies:
  rexios_lints: latest
```

## Goal

The goal of these rules is to enforce code consistency without being annoying. All of the rules in this package were added because of real-life issues I've encountered in projects.

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

### Core

[always_declare_return_types](https://dart-lang.github.io/linter/lints/always_declare_return_types.html)
- Safety
- Undeclared return types are `dynamic`. This is almost never intentional. Either declare `void` or explicitly declare `dynamic`.

[always_use_package_imports](https://dart-lang.github.io/linter/lints/always_use_package_imports.html)
- Readability
- Relative imports make it hard to see where a file is coming from
  
[avoid_types_on_closure_parameters](https://dart-lang.github.io/linter/lints/avoid_types_on_closure_parameters.html)
- Brevity
- The type checker can inform you of the type if you need to see it

[conditional_uri_does_not_exist](https://dart.dev/tools/linter-rules/conditional_uri_does_not_exist)
- Safety
- Without this rule there is no warning if a conditional import does not exist

[leading_newlines_in_multiline_strings](https://dart-lang.github.io/linter/lints/leading_newlines_in_multiline_strings.html)
- Readability
- Not all languages ignore a leading newline in multiline strings. Dart does, and it's more readable. No more remembering if Dart supports it or not.

[omit_local_variable_types](https://dart-lang.github.io/linter/lints/omit_local_variable_types.html)
- Brevity
- The type checker can inform you of the type if you need to see it

[prefer_final_in_for_each](https://dart-lang.github.io/linter/lints/prefer_final_in_for_each.html)
- Safety
- Prevents accidental reassignment

[prefer_final_locals](https://dart-lang.github.io/linter/lints/prefer_final_locals.html)
- Safety
- Prevents accidental reassignment

[prefer_single_quotes](https://dart-lang.github.io/linter/lints/prefer_single_quotes.html)
- Consistency
- Enforces consistency with the rest of the Dart ecosystem

[require_trailing_commas](https://dart-lang.github.io/linter/lints/require_trailing_commas.html)
- Readability
- Prevents excessively long lines

[unawaited_futures](https://dart-lang.github.io/linter/lints/unawaited_futures.html)
- Safety
- Ensures that async calls in async methods aren't accidentally ignored

[unnecessary_breaks](https://dart.dev/tools/linter-rules/unnecessary_breaks)
- Brevity
- Switch cases no longer need explicit break statements as of Dart 3

[unnecessary_lambdas](https://dart-lang.github.io/linter/lints/unnecessary_lambdas.html)
- Brevity
- `Widget`s using tear-offs can be declared `const` in some cases
- This can expose unsafe usage of `dynamic` types

[unnecessary_parenthesis](https://dart-lang.github.io/linter/lints/unnecessary_parenthesis.html)
- Brevity
- It's easy to end up with extra parenthesis when refactoring

[use_colored_box](https://dart-lang.github.io/linter/lints/use_colored_box.html)
- Performance
- A `ColoredBox` is more performant than a `Container` with a `color` property

[use_decorated_box](https://dart-lang.github.io/linter/lints/use_decorated_box.html)
- Performance
- A `DecoratedBox` is more performant than a `Container` with a `decoration` property

### Package

[public_member_api_docs](https://dart-lang.github.io/linter/lints/public_member_api_docs.html)
- Enforces documentation. Promotes code readability and maintenance. Also ensures a good documentation score from `pana`.
