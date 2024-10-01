## NEXT

- Adds `discarded_futures`

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
