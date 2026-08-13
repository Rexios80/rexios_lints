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

Project with the analyzer plugin enabled:

```yaml
include: package:rexios_lints/{dart|flutter}/core_extra.yaml
```

Package:

```yaml
include: package:rexios_lints/{dart|flutter}/package.yaml
```

Package with the analyzer plugin enabled:

```yaml
include: package:rexios_lints/{dart|flutter}/package_extra.yaml
```

## Analyzer plugin

The `extra` rulesets include an [analyzer plugin](https://dart.dev/tools/analyzer-plugins) with custom diagnostics.

Here is an example of how to disable specific diagnostics from the analyzer plugin:

```yaml
include: package:rexios_lints/dart/package_extra.yaml

plugins:
  rexios_lints:
    diagnostics:
      not_null_assertion: false
```

## Justification

### core

[always_declare_return_types](https://dart.dev/tools/linter-rules/always_declare_return_types)

- Safety
- Undeclared return types are `dynamic`. This is almost never intentional. Either declare `void` or explicitly declare `dynamic`.

[always_use_package_imports](https://dart.dev/tools/linter-rules/always_use_package_imports)

- Readability
- Relative imports make it hard to see where a file is coming from

[async_return_with_no_await](https://dart.dev/tools/linter-rules/async_return_with_no_await)

- Safety
- Returning a `Future` from an `async` function without `await` skips the function's error handling

[avoid_types_on_closure_parameters](https://dart.dev/tools/linter-rules/avoid_types_on_closure_parameters)

- Brevity
- The type checker can inform you of the type if you need to see it

[conditional_uri_does_not_exist](https://dart.dev/tools/linter-rules/conditional_uri_does_not_exist)

- Safety
- Without this rule there is no warning if a conditional import does not exist

[document_ignores](https://dart.dev/tools/linter-rules/document_ignores)

- Technical debt
- In the rare case that ignoring a lint rule is unavoidable, the reason should be documented

[empty_container_bodies](https://dart.dev/tools/linter-rules/empty_container_bodies)

- Brevity
- Empty class-like declarations can use `;` instead of `{}`

[initialize_in_field_declaration](https://dart.dev/tools/linter-rules/initialize_in_field_declaration)

- Readability
- Field initialization is easier to find at the declaration than in a constructor

[invalid_runtime_check_with_js_interop_types](https://dart.dev/tools/linter-rules/invalid_runtime_check_with_js_interop_types)

- Safety
- Runtime type tests with JS interop types do not work on all platforms

[leading_newlines_in_multiline_strings](https://dart.dev/tools/linter-rules/leading_newlines_in_multiline_strings)

- Readability
- Not all languages ignore a leading newline in multiline strings. Dart does, and it's more readable. No more remembering if Dart supports it or not.

[no_raw_types](https://dart.dev/tools/linter-rules/no_raw_types)

- Safety
- Raw generic types don't infer type arguments. They use the type parameter bound, which is usually `dynamic`

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

[prefer_int_literals](https://dart.dev/tools/linter-rules/prefer_int_literals)

- Brevity
- Integer literals are more concise than double literals

[prefer_single_quotes](https://dart.dev/tools/linter-rules/prefer_single_quotes)

- Consistency
- Enforces consistency with the rest of the Dart ecosystem

[simple_directive_paths](https://dart.dev/tools/linter-rules/simple_directive_paths)

- Readability
- Redundant `./` and `../` segments make import, export, and part paths harder to follow

[simplify_variable_pattern](https://dart.dev/tools/linter-rules/simplify_variable_pattern)

- Brevity
- `String(:var length)` is more concise than `String(length: var length)`

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

[unnecessary_const_in_enum_constructor](https://dart.dev/tools/linter-rules/unnecessary_const_in_enum_constructor)

- Brevity
- Generative enum constructors are implicitly `const`

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

[unnecessary_primary_constructor_body](https://dart.dev/tools/linter-rules/unnecessary_primary_constructor_body)

- Brevity
- Empty primary constructor bodies can be replaced with `;`

[unnecessary_type_name_in_constructor](https://dart.dev/tools/linter-rules/unnecessary_type_name_in_constructor)

- Brevity
- `new` is more concise than repeating the type name in constructor declarations

[use_declaring_parameters](https://dart.dev/tools/linter-rules/use_declaring_parameters)

- Brevity
- Declaring parameters avoid repeating field names and types

[use_null_aware_elements](https://dart.dev/tools/linter-rules/use_null_aware_elements)

- Brevity
- `{?key: "value"}` is more concise than `{if (key != null) key: "value"}`

[use_truncating_division](https://dart.dev/tools/linter-rules/use_truncating_division)

- Brevity
- `a ~/ b` is more concise than `(a / b).toInt()`

[var_with_no_type_annotation](https://dart.dev/tools/linter-rules/var_with_no_type_annotation)

- Safety
- `var` on parameters is reserved for declaring parameters. Use an explicit type or omit `var`.

### dart/core

[prefer_const_constructors_in_immutables](https://dart.dev/tools/linter-rules/prefer_const_constructors_in_immutables)

- Performance
- Const constructors improve performance

### flutter/core

[migrate_design_widgets](https://dart.dev/tools/linter-rules/migrate_design_widgets)

- Technical debt
- `package:flutter/material.dart` and `package:flutter/cupertino.dart` are deprecated. Use `material_ui` and `cupertino_ui` instead.

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

- Best practices
- Usage of `StatefulBuilder` indicates a complex widget that should be encapsulated in a `StatefulWidget` class

double_leading_zero

- Readability
- `0.12345` is more readable than `.12345`

[inline_context_lookups](https://redd.it/1liezgz)

- Performance
- Using many inline context lookups can lead to performance issues

not_null_assertion

- Safety
- Using `!` to assert a value is not null is not safe. [See the Dart documentation for help.](https://dart.dev/null-safety/understanding-null-safety#working-with-nullable-types)

[prefer_async_await](https://dart.dev/effective-dart/usage#prefer-asyncawait-over-using-raw-futures)

- Readability
- `async`/`await` is more readable than `Future.then`

prefer_immutable_classes

- Performance
- Immutable classes can have const constructors

prefer_timestamps

- Safety
- Creating anything other than UTC timestamps with `DateTime.timestamp()` or `clock.now().toUtc()` could lead to storing bad data

unnecessary_container

- Performance
- `Container` widgets add a lot of overhead. Use specialized widgets when possible.
