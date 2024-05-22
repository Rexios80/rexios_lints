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

### core

[always_declare_return_types](https://dart.dev/tools/linter-rules/always_declare_return_types)
- Safety
- Undeclared return types are `dynamic`. This is almost never intentional. Either declare `void` or explicitly declare `dynamic`.

[always_use_package_imports](https://dart.dev/tools/linter-rules/always_use_package_imports)
- Readability
- Relative imports make it hard to see where a file is coming from
  
[avoid_types_on_closure_parameters](https://dart.dev/tools/linter-rules/avoid_types_on_closure_parameters)
- Brevity
- The type checker can inform you of the type if you need to see it

[conditional_uri_does_not_exist](https://dart.dev/tools/linter-rules/conditional_uri_does_not_exist)
- Safety
- Without this rule there is no warning if a conditional import does not exist

[leading_newlines_in_multiline_strings](https://dart.dev/tools/linter-rules/leading_newlines_in_multiline_strings)
- Readability
- Not all languages ignore a leading newline in multiline strings. Dart does, and it's more readable. No more remembering if Dart supports it or not.

[omit_local_variable_types](https://dart.dev/tools/linter-rules/omit_local_variable_types)
- Brevity
- The type checker can inform you of the type if you need to see it

[prefer_final_in_for_each](https://dart.dev/tools/linter-rules/prefer_final_in_for_each)
- Safety
- Prevents accidental reassignment

[prefer_final_locals](https://dart.dev/tools/linter-rules/prefer_final_locals)
- Safety
- Prevents accidental reassignment

[prefer_single_quotes](https://dart.dev/tools/linter-rules/prefer_single_quotes)
- Consistency
- Enforces consistency with the rest of the Dart ecosystem

[require_trailing_commas](https://dart.dev/tools/linter-rules/require_trailing_commas)
- Readability
- Prevents excessively long lines

[unawaited_futures](https://dart.dev/tools/linter-rules/unawaited_futures)
- Safety
- Ensures that async calls in async methods aren't accidentally ignored

[unnecessary_breaks](https://dart.dev/tools/linter-rules/unnecessary_breaks)
- Brevity
- Switch cases no longer need explicit break statements as of Dart 3

[unnecessary_lambdas](https://dart.dev/tools/linter-rules/unnecessary_lambdas)
- Brevity
- `Widget`s using tear-offs can be declared `const` in some cases
- This can expose unsafe usage of `dynamic` types

[unnecessary_parenthesis](https://dart.dev/tools/linter-rules/unnecessary_parenthesis)
- Brevity
- It's easy to end up with extra parenthesis when refactoring


### flutter/core

[use_colored_box](https://dart.dev/tools/linter-rules/use_colored_box)
- Performance
- A `ColoredBox` is more performant than a `Container` with a `color` property

[use_decorated_box](https://dart.dev/tools/linter-rules/use_decorated_box)
- Performance
- A `DecoratedBox` is more performant than a `Container` with a `decoration` property

### package

[public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs)
- Enforces documentation. Promotes code readability and maintenance. Also ensures a good documentation score from `pana`.
