import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/not_null_assertion.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class NotNullAssertionTest extends AnalysisRuleTest {
  @override
  String get analysisRule => NotNullAssertion.code.name;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(NotNullAssertion());
    super.setUp();
  }

  String content(String content) =>
      '''
String? nullableString;
void test() {
  $content
}
''';

  void test_invalid() async {
    await assertDiagnostics(content("nullableString!.split('');"), [
      lint(40, 15),
    ]);
  }

  void test_valid() async {
    await assertNoDiagnostics(content("nullableString?.split('');"));
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(NotNullAssertionTest);
  });
}
