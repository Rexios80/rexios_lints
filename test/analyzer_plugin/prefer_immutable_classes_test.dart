import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:analyzer/src/lint/registry.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_immutable_classes.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';

@reflectiveTest
class PreferImmutableClassesTest extends AnalysisRuleTest {
  @override
  String get analysisRule => PreferImmutableClasses.code.name;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(PreferImmutableClasses());
    super.setUp();
  }

  String content(String content) =>
      '''
class Immutable {
  const Immutable();
}

const immutable = Immutable();

$content
''';

  void test_invalid() async {
    await assertDiagnostics(
      content('''
class ImmutableClass {
  final int value;

  ImmutableClass(this.value);
}
'''),
      [lint(80, 14)],
    );
  }

  void test_valid() async {
    await assertNoDiagnostics(
      content('''
@immutable
class ImmutableClass {
  final int value;

  const ImmutableClass(this.value);
}
'''),
    );
  }

  void test_extends_immutable() async {
    await assertNoDiagnostics(
      content('''
@immutable
class ImmutableSupertype {
  const ImmutableSupertype();
}

class ImmutableSubclass extends ImmutableSupertype {
  final String value;

  const ImmutableSubclass(this.value);
}
'''),
    );
  }

  void test_implements_immutable() async {
    await assertDiagnostics(
      content('''
@immutable
class ImmutableSupertype {
  const ImmutableSupertype();
}

class ImmutableSubclass implements ImmutableSupertype {
  final String value;

  const ImmutableSubclass(this.value);
}
'''),
      [lint(151, 17)],
    );
  }

  void test_extends_mutable() async {
    await assertNoDiagnostics(
      content('''
class MutableSupertype {
  int value;

  MutableSupertype(this.value);
}

class MutableSubclass extends MutableSupertype {
  MutableSubclass(super.value);
}
'''),
    );
  }

  void test_static_members() async {
    await assertDiagnostics(
      content('''
class ImmutableClass {
  static const constValue = 0;
  static final finalValue = 0;

  final int value;

  ImmutableClass(this.value);
}
'''),
      [lint(80, 14)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(PreferImmutableClassesTest);
  });
}
