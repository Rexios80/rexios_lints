import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  final coreLints = readAndSortRules('tool/src/core.yaml');
  final packageLints = readAndSortRules('tool/src/package.yaml');

  write(
    folder: 'dart',
    coreInclude: 'package:lints/recommended.yaml',
    coreLints: coreLints,
    packageLints: packageLints,
  );

  write(
    folder: 'flutter',
    coreInclude: 'package:flutter_lints/flutter.yaml',
    coreLints: coreLints,
    packageLints: packageLints,
  );
}

String readAndSortRules(String fileName) {
  final file = File(fileName);
  final yaml = loadYaml(file.readAsStringSync()) as YamlMap;
  final rules = (yaml['linter']['rules'] as YamlList).toList();
  rules.sort();
  final sorted = '''
linter:
  rules:
    - ${rules.join('\n    - ')}
''';
  file.writeAsStringSync(sorted);
  return sorted.trim();
}

void write({
  required String folder,
  required String coreInclude,
  required String coreLints,
  required String packageLints,
}) {
  File('lib/$folder/core.yaml').writeAsStringSync('''
include: $coreInclude

$coreLints
''');
  File('lib/$folder/package.yaml').writeAsStringSync('''
include: package:rexios_lints/$folder/core.yaml

$packageLints
''');
}
