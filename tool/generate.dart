import 'dart:io';

final core = [
  'always_declare_return_types',
  'always_use_package_imports',
  'avoid_types_on_closure_parameters',
  'conditional_uri_does_not_exist',
  // TODO: Add when Dart 3.5.0 is stable
  // 'document_ignores',
  'leading_newlines_in_multiline_strings',
  'omit_local_variable_types',
  'prefer_final_in_for_each',
  'prefer_final_locals',
  'prefer_single_quotes',
  'require_trailing_commas',
  'unawaited_futures',
  'unnecessary_breaks',
  'unnecessary_lambdas',
  'unnecessary_parenthesis',
]..sort();

final flutter = [
  ...core,
  'use_colored_box',
  'use_decorated_box',
]..sort();

final package = [
  'public_member_api_docs',
]..sort();

void main() {
  write(
    folder: 'dart',
    coreInclude: 'package:lints/recommended.yaml',
    coreLints: core,
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
  final file = File('lib/$folder/core.yaml');
  file.createSync(recursive: true);
  file.writeAsStringSync('''
include: $coreInclude

linter:
  rules:
${coreLints.map((e) => '    - $e').join('\n')}
''');

  File('lib/$folder/package.yaml').writeAsStringSync('''
include: package:rexios_lints/$folder/core.yaml

linter:
  rules:
${packageLints.map((e) => '    - $e').join('\n')}
''');
}
