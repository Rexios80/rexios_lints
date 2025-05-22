## 11.0.6

- Does not enforce `prefer_immutable_classes` on classes with mutable supertypes

## 11.0.5

- Inserts `@immutable` annotation after documentation comment

## 11.0.4

- Does not enforce `prefer_immutable_classes` on classes that have zero parameter constructors

## 11.0.3

- Does not enforce `prefer_immutable_classes` on classes that extend immutable classes

## 11.0.2

- Does not enforce `prefer_immutable_classes` on classes with no fields

## 11.0.1

- Fixes an issue where imports couldn't be properly added to files without existing import statements

## 11.0.0

- Requires Dart `3.8.0`
- Additions to `core`:
  - `unnecessary_ignore`
  - `use_null_aware_elements`
- Additions to `dart`:
  - `prefer_const_constructors_in_immutables`
- Additions to `extra`:
  - `prefer_immutable_classes`
- Fixes issue with `do_not_use_raw_paths` fix

## 10.1.0

- Fixes issue with `do_not_use_raw_paths` fix ([#2](https://github.com/Rexios80/rexios_lints/issues/2))
- Updates `analyzer_plugin` to `0.13.0`

## 10.0.1

- Formatting

## 10.0.0

- Updates the SDK lower-bound to `3.7.0`
- Adds the following lints to `core`:
  - `omit_obvious_property_types`
  - `unnecessary_async`
  - `unnecessary_underscores`

## 9.3.0

- Improves `do_not_use_raw_paths`
  - Handles paths using string interpolation
  - Adds `path` import if not already imported

## 9.2.0

- Supports `analyzer` version `7.0.0`

## 9.1.0

- Removes `discarded_futures` since it is too annoying

## 9.0.0

- Updates the SDK lower-bound to `3.6.0`
- Upgrades `lints` to `5.0.0`
- Upgrades `flutter_lints` to `5.0.0`
- Adds the following lints to `core`
  - `discarded_futures`
  - `use_truncating_division`
- Removes the following rules from `core` that were added to `lints/recommended`
  - `invalid_runtime_check_with_js_interop_types`
- Adds the following rules to `flutter` that were removed from `flutter_lints`
  - `prefer_const_constructors`
  - `prefer_const_declarations`
  - `prefer_const_literals_to_create_immutables`

## 8.2.0

- Adds a fix for `do_not_use_raw_paths`

## 8.1.0

- Adds `{dart|flutter}/core_extra.yaml` rulesets
- Adds `{dart|flutter}/package_extra.yaml` rulesets

## 8.0.0

- Adds `document_ignores` to core lints
- Adds `invalid_runtime_check_with_js_interop_types` to core lints

## 7.0.0

- Upgrades `lints` and `flutter_lints`

## 6.0.1

- Update readme

## 6.0.0

- Upgrades `lints` to 3.0.0
- Upgrades `flutter_lints` to 3.0.0
- Removes `use_super_parameters` from ruleset since it is now a part of `lints/recommended`
- Adds the following lints to `dart/core` and `flutter/core`
  - `conditional_uri_does_not_exist`
  - `unnecessary_breaks`
- Adds the following lints to `flutter/core`
  - `use_colored_box`
  - `use_decorated_box`

## 5.0.0

- Adds the following lints
  - `always_declare_return_types`
  - `avoid_types_on_closure_parameters`
  - `leading_newlines_in_multiline_strings`
  - `omit_local_variable_types`
  - `unnecessary_lambdas`
  - `unnecessary_parenthesis`
- See the README for justification

## 4.0.0

- Removes analysis exclusions for the following reasons:
  - Errors in generated files should not be invisible
  - Lint issues in generated files point to issues in the generator
  - Pana no longer respects exclusions specified in analysis options

## 3.0.0

- Added `use_super_parameters`, `prefer_final_in_for_each`, and `prefer_final_locals` to core lints

## 2.0.1

- Updated readme

## 2.0.0

- Updated lints packages to version 2

## 1.0.0

- Initial version.
