import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/src/analyzer_plugin/prefer_timestamps.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

@reflectiveTest
class PreferTimestampsTest extends AnalysisRuleTest {
  @override
  String get analysisRule => PreferTimestamps.code.lowerCaseName;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(PreferTimestamps());

    newPackage('clock').addFile('lib/clock.dart', '''
class Clock {
  DateTime now() => DateTime.now();
}
final Clock clock = Clock();
''');

    super.setUp();

    final core = getFile('/sdk/lib/core/core.dart');
    final coreContent = core.readAsStringSync();
    final newCoreContent = coreContent
        .replaceAll(
          RegExp(r'DateTime.now\(\).*'),
          'DateTime.now();\nDateTime.timestamp();',
        )
        .replaceAll(
          'external int get millisecondsSinceEpoch;',
          'external int get millisecondsSinceEpoch;\n'
              'external DateTime toUtc();',
        );
    core.writeAsStringSync(newCoreContent);
  }

  void test_dateTimeNow() async {
    await assertDiagnostics('final _ = DateTime.now();', [lint(10, 14)]);
  }

  void test_dateTimeTimestamp() async {
    await assertNoDiagnostics('final _ = DateTime.timestamp();');
  }

  void test_clockNow() async {
    await assertDiagnostics(
      '''
import 'package:clock/clock.dart';

final _ = clock.now();
''',
      [lint(46, 11)],
    );
  }

  void test_clockNowToUtc() async {
    await assertNoDiagnostics('''
import 'package:clock/clock.dart';

final _ = clock.now().toUtc();
''');
  }

  void test_customClockNow() async {
    await assertDiagnostics(
      '''
import 'package:clock/clock.dart';

final myClock = Clock();
final _ = myClock.now();
''',
      [lint(71, 13)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferTimestampsTest);
  });
}
