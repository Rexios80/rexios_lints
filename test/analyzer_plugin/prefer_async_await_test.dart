import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_async_await.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class PreferAsyncAwaitTest extends AnalysisRuleTest {
  @override
  String get analysisRule => PreferAsyncAwait.code.lowerCaseName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(PreferAsyncAwait());
    super.setUp();
  }

  void test_invalid() async {
    await assertDiagnostics(
      '''
void test() {
  Future.value().then((_) {});
}
''',
      [lint(16, 27)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferAsyncAwaitTest);
  });
}
