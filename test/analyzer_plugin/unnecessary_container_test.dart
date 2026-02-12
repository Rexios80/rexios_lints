import 'package:analyzer_testing/analysis_rule/analysis_rule.dart';
import 'package:rexios_lints/analyzer_plugin/unnecessary_container.dart';
import 'package:test_reflective_loader/test_reflective_loader.dart';
import 'package:analyzer/src/lint/registry.dart';

// TODO: Enable these tests when importing flutter package is supported
@reflectiveTest
class UnnecessaryContainerTest extends AnalysisRuleTest {
  @override
  String get analysisRule => UnnecessaryContainer.code.lowerCaseName;

  @override
  bool get addFlutterPackageDep => true;

  @override
  void setUp() {
    Registry.ruleRegistry.registerLintRule(UnnecessaryContainer());
    super.setUp();
  }

  String content(String content) =>
      '''
import 'package:flutter/widgets.dart';

final _ = $content;

class Matrix4 {
  Matrix4.identity();
}
''';

  void test_empty() async {
    await assertDiagnostics(content('Container()'), [lint(50, 11)]);
  }

  void test_child() async {
    await assertDiagnostics(content("Container(child: Text('Hello'))"), [
      lint(50, 31),
    ]);
  }

  void test_alignment() async {
    await assertDiagnostics(content('Container(alignment: Alignment.center)'), [
      lint(50, 38),
    ]);
  }

  void test_padding() async {
    await assertDiagnostics(content('Container(padding: EdgeInsets.zero)'), [
      lint(50, 35),
    ]);
  }

  void test_color() async {
    await assertDiagnostics(content('Container(color: Color(0x00000000))'), [
      lint(50, 35),
    ]);
  }

  void test_decoration() async {
    await assertDiagnostics(content('Container(decoration: BoxDecoration())'), [
      lint(50, 38),
    ]);
  }

  void test_foreground_decoration() async {
    await assertDiagnostics(
      content('Container(foregroundDecoration: BoxDecoration())'),
      [lint(50, 48)],
    );
  }

  void test_width() async {
    await assertDiagnostics(content('Container(width: 0)'), [lint(50, 19)]);
  }

  void test_height() async {
    await assertDiagnostics(content('Container(height: 0)'), [lint(50, 20)]);
  }

  void test_constraints() async {
    await assertDiagnostics(
      content('Container(constraints: BoxConstraints())'),
      [lint(50, 40)],
    );
  }

  void test_margin() async {
    await assertDiagnostics(content('Container(margin: EdgeInsets.zero)'), [
      lint(50, 34),
    ]);
  }

  void test_transform() async {
    await assertDiagnostics(
      content('Container(transform: Matrix4.identity())'),
      [lint(50, 40)],
    );
  }

  void test_clip_behavior() async {
    await assertDiagnostics(content('Container(clipBehavior: Clip.none)'), [
      lint(50, 34),
    ]);
  }

  void test_width_and_height() async {
    await assertDiagnostics(content('Container(width: 0, height: 0)'), [
      lint(50, 30),
    ]);
  }

  void test_width_and_height_and_child() async {
    await assertDiagnostics(
      content("Container(width: 0, height: 0, child: Text('Hello'))"),
      [lint(50, 52)],
    );
  }

  void test_transform_and_transform_alignment() async {
    await assertDiagnostics(
      content(
        'Container(transform: Matrix4.identity(), transformAlignment: Alignment.center)',
      ),
      [lint(50, 78)],
    );
  }

  void test_transform_and_transform_alignment_and_child() async {
    await assertDiagnostics(
      content(
        "Container(transform: Matrix4.identity(), transformAlignment: Alignment.center, child: Text('Hello'))",
      ),
      [lint(50, 100)],
    );
  }
}

void main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(UnnecessaryContainerTest);
  });
}
