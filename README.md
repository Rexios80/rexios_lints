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

Project:

```yaml
include: package:rexios_lints/{dart|flutter}/core.yaml
```

Project with `custom_lint` enabled:

```yaml
include: package:rexios_lints/{dart|flutter}/core_extra.yaml
```

Package:

```yaml
include: package:rexios_lints/{dart|flutter}/package.yaml
```

Package with `custom_lint` enabled:

```yaml
include: package:rexios_lints/{dart|flutter}/package_extra.yaml
```

## Custom lints

The `extra` rulesets include custom lint rules created with the [custom_lint](https://pub.dev/packages/custom_lint) package. See the `custom_lint` documentation for help configuring custom lints.

To check for custom lint issues in CI run the following command:

```console
dart run custom_lint
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

[document_ignores](https://dart.dev/tools/linter-rules/document_ignores)

- Technical debt
- In the rare case that ignoring a lint rule is unavoidable, the reason should be documented

[invalid_runtime_check_with_js_interop_types](https://dart.dev/tools/linter-rules/invalid_runtime_check_with_js_interop_types)

- Safety
- Runtime type tests with JS interop types do not work on all platforms

[leading_newlines_in_multiline_strings](https://dart.dev/tools/linter-rules/leading_newlines_in_multiline_strings)

- Readability
- Not all languages ignore a leading newline in multiline strings. Dart does, and it's more readable. No more remembering if Dart supports it or not.

[omit_local_variable_types](https://dart.dev/tools/linter-rules/omit_local_variable_types)

- Brevity
- The type checker can inform you of the type if you need to see it

[omit_obvious_property_types](https://dart.dev/tools/linter-rules/omit_obvious_property_types)

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

[switch_on_type](https://dart.dev/tools/linter-rules/switch_on_type)

- Safety
- Switching on `Type` is not type-safe and can lead to bugs if the class hierarchy changes. Prefer to use pattern matching on the variable instead.

[unawaited_futures](https://dart.dev/tools/linter-rules/unawaited_futures)

- Safety
- Ensures that async calls in async methods aren't accidentally ignored

[unnecessary_async](https://dart.dev/tools/linter-rules/unnecessary_async)

- Brevity
- It's easy to end up with unnecessary async modifiers when refactoring

[unnecessary_breaks](https://dart.dev/tools/linter-rules/unnecessary_breaks)

- Brevity
- Switch cases no longer need explicit break statements as of Dart 3

[unnecessary_ignore](https://dart.dev/tools/linter-rules/unnecessary_ignore)

- Brevity
- Extra ignore comments are not necessary

[unnecessary_lambdas](https://dart.dev/tools/linter-rules/unnecessary_lambdas)

- Brevity
- `Widget`s using tear-offs can be declared `const` in some cases
- This can expose unsafe usage of `dynamic` types

[unnecessary_parenthesis](https://dart.dev/tools/linter-rules/unnecessary_parenthesis)

- Brevity
- It's easy to end up with extra parenthesis when refactoring

[use_null_aware_elements](https://dart.dev/tools/linter-rules/use_null_aware_elements)

- Brevity
- `{?key: "value"}` is more concise than `{if (key != null) key: "value"}`

[use_truncating_division](https://dart.dev/tools/linter-rules/use_truncating_division)

- Brevity
- `a ~/ b` is more concise than `(a / b).toInt()`

### dart/core

[prefer_const_constructors_in_immutables](https://dart.dev/tools/linter-rules/prefer_const_constructors_in_immutables)

- Performance
- Const constructors improve performance

### flutter/core

[prefer_const_constructors](https://dart.dev/tools/linter-rules/prefer_const_constructors)

- Performance
- Const constructors improve performance

[prefer_const_declarations](https://dart.dev/tools/linter-rules/prefer_const_declarations)

- Performance
- Const constructors improve performance

[prefer_const_literals_to_create_immutables](https://dart.dev/tools/linter-rules/prefer_const_literals_to_create_immutables)

- Performance
- Const constructors improve performance

[use_colored_box](https://dart.dev/tools/linter-rules/use_colored_box)

- Performance
- A `ColoredBox` is more performant than a `Container` with a `color` property

[use_decorated_box](https://dart.dev/tools/linter-rules/use_decorated_box)

- Performance
- A `DecoratedBox` is more performant than a `Container` with a `decoration` property

### package

[public_member_api_docs](https://dart.dev/tools/linter-rules/public_member_api_docs)

- Enforces documentation. Promotes code readability and maintenance. Also ensures a good documentation score from `pana`.

### extra

do_not_use_raw_paths

- Safety
- Raw path strings (e.g. `'/path/to/file'`) are platform-specific. Use the `join` method from the [path](https://pub.dev/packages/path) package instead.

do_not_use_stateful_builder

- Readability
- Usage of `StatefulBuilder` indicates a complex widget that should be encapsulated in a `StatefulWidget` class

[inline_context_lookups](https://redd.it/1liezgz)

- Performance
- Using many inline context lookups can lead to performance issues

[prefer_async_await](https://dart.dev/effective-dart/usage#prefer-asyncawait-over-using-raw-futures)

- Readability
- `async`/`await` is more readable than `Future.then`

prefer_immutable_classes

- Performance
- Immutable classes can have const constructors

prefer_timestamps

- Safety
- Creating anything other than UTC timestamps with `DateTime.timestamp()` could lead to storing bad data

unnecessary_container

- Performance
- `Container` widgets add a lot of overhead. Use specialized widgets when possible.
