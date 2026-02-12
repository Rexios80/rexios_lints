import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/do_not_use_stateful_builder.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class DoNotUseStatefulBuilderTest extends AnalysisRuleTest {
  @override
  String get analysisRule => DoNotUseStatefulBuilder.code.lowerCaseName;

  @override
  bool get addFlutterPackageDep => true;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(DoNotUseStatefulBuilder());
    super.setUp();

    newFile(
      join(packagesRootPath, 'flutter', 'lib', 'src', 'widgets', 'basic.dart'),
      '''
class StatefulBuilder {
  const StatefulBuilder({builder});
}
class SizedBox {
  const SizedBox.shrink();
}
''',
    );
  }

  void test_invalid() async {
    await assertDiagnostics(
      '''
import 'package:flutter/widgets.dart';

final _ = StatefulBuilder(builder: (_, _) => const SizedBox.shrink());
''',
      [lint(50, 59)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(DoNotUseStatefulBuilderTest);
  });
}
