import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:analyzer/src/lint/registry.dart';
import 'package:rexios_lints/analyzer_plugin/inline_context_lookups.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

@reflectiveTest
class InlineContextLookupsTest extends AnalysisRuleTest {
  @override
  String get analysisRule => InlineContextLookups.code.name;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(InlineContextLookups());
    super.setUp();
  }

  static String content(String content) =>
      '''
class Navigator {
  static Navigator of(context) => Navigator();
  static Navigator? maybeOf(context) => Navigator();

  void pop() {}
}

final context = null;

void test() {
  $content
}
''';

  void test_invalid() async {
    await assertDiagnostics(
      content('''
Navigator.of(context).pop();
Navigator.maybeOf(context)?.pop();
'''),
      [lint(177, 21), lint(206, 26)],
    );
  }

  void test_valid() async {
    await assertNoDiagnostics(
      content('''
final navigator = Navigator.of(context);
navigator.pop();
'''),
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(InlineContextLookupsTest);
  });
}
