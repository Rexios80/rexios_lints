import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/do_not_use_raw_paths.dart';
import 'package:test/test.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class DoNotUseRawPathsTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DoNotUseRawPaths.code.name;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DoNotUseRawPaths());
    super.setUp();
  }

  static content(String entity, String path) =>
      '''
import 'dart:io';

final _ = $entity('$path');
''';

  void test_directory() async {
    await assertDiagnostics(content('Directory', 'path/to/directory'), [
      lint(39, 19),
    ]);
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(DoNotUseRawPathsTest);
  });

  test('create path segments', () {
    expect(
      UsePathJoin.createSegmentsString("'path/to/entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString(r"'path\\to\\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString(r"r'path\to\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString('r"path/to/entity"'),
      "'path', 'to', 'entity'",
    );
  });
}
