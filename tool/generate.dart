import 'dart:io';

import 'package:path/path.dart' as path;

final core = [
  'always_declare_return_types',
  'always_use_package_imports',
  'async_return_with_no_await',
  'avoid_types_on_closure_parameters',
  'conditional_uri_does_not_exist',
  'document_ignores',
  'empty_container_bodies',
  'initialize_in_field_declaration',
  'leading_newlines_in_multiline_strings',
  'no_raw_types',
  'omit_local_variable_types',
  'omit_obvious_property_types',
  'prefer_final_in_for_each',
  'prefer_final_locals',
  'prefer_int_literals',
  'prefer_single_quotes',
  'simple_directive_paths',
  'simplify_variable_pattern',
  'switch_on_type',
  'unawaited_futures',
  'unnecessary_async',
  'unnecessary_breaks',
  'unnecessary_const_in_enum_constructor',
  'unnecessary_ignore',
  'unnecessary_lambdas',
  'unnecessary_parenthesis',
  'unnecessary_primary_constructor_body',
  'unnecessary_type_name_in_constructor',
  'use_declaring_parameters',
  'use_null_aware_elements',
  'use_truncating_division',
  'var_with_no_type_annotation',
]..sort();

final dart = [...core, 'prefer_const_constructors_in_immutables']..sort();

final flutter = [
  ...core,
  'prefer_const_constructors',
  'prefer_const_declarations',
  'prefer_const_literals_to_create_immutables',
  'migrate_design_widgets',
  'use_colored_box',
  'use_decorated_box',
]..sort();

final package = ['public_member_api_docs']..sort();

final version = File('pubspec.yaml')
    .readAsLinesSync()
    .firstWhere((e) => e.startsWith('version:'))
    .split(':')[1]
    .trim();

final plugins = '''
plugins:
  rexios_lints:
    version: ^$version''';

void main() {
  write(
    folder: 'dart',
    coreInclude: 'package:lints/recommended.yaml',
    coreLints: dart,
    packageLints: package,
  );

  write(
    folder: 'flutter',
    coreInclude: 'package:flutter_lints/flutter.yaml',
    coreLints: flutter,
    packageLints: package,
  );
}

void write({
  required String folder,
  required String coreInclude,
  required List<String> coreLints,
  required List<String> packageLints,
}) {
  Directory(path.join('lib', folder)).createSync(recursive: true);

  // Write core lints
  File(path.join('lib', folder, 'core.yaml')).writeAsStringSync('''
include: $coreInclude

linter:
  rules:
${coreLints.map((e) => '    - $e').join('\n')}
''');

  // Write core_extra lints
  File(path.join('lib', folder, 'core_extra.yaml')).writeAsStringSync('''
include: package:rexios_lints/$folder/core.yaml

$plugins
''');

  // Write package lints
  File(path.join('lib', folder, 'package.yaml')).writeAsStringSync('''
include: package:rexios_lints/$folder/core.yaml

linter:
  rules:
${packageLints.map((e) => '    - $e').join('\n')}
''');

  // Write package_extra lints
  File(path.join('lib', folder, 'package_extra.yaml')).writeAsStringSync('''
include: package:rexios_lints/$folder/package.yaml

$plugins
''');
}
