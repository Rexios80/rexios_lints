import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_timestamps.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class PreferTimestampsTest extends AnalysisRuleTest {
  @override
  String get analysisRule => PreferTimestamps.code.lowerCaseName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(PreferTimestamps());
    super.setUp();

    final core = getFile('/sdk/lib/core/core.dart');
    final coreContent = core.readAsStringSync();
    final newCoreContent = coreContent.replaceAll(
      RegExp(r'DateTime.now\(\).*'),
      'DateTime.now();\nDateTime.timestamp();',
    );
    core.writeAsStringSync(newCoreContent);
  }

  void test_invalid() async {
    await assertDiagnostics('final _ = DateTime.now();', [lint(10, 14)]);
  }

  void test_valid() async {
    await assertNoDiagnostics('final _ = DateTime.timestamp();');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferTimestampsTest);
  });
}
