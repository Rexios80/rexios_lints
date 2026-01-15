import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/double_leading_zero.dart';
import 'package:analyzer/src/lint/registry.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

@reflectiveTest
class DoubleLeadingZeroTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DoubleLeadingZero.code.lowerCaseName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DoubleLeadingZero());
    super.setUp();
  }

  void test_invalid() async {
    await assertDiagnostics('final _ = .12345;', [lint(10, 6)]);
  }

  void test_valid() async {
    await assertNoDiagnostics('final _ = 0.12345;');
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(DoubleLeadingZeroTest);
  });
}
