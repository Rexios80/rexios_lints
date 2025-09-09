import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Do use leading zeros in double literals
class DoubleLeadingZero extends DartLintRule {
  static const _code = LintCode(
    name: 'double_leading_zero',
    problemMessage:
        'Doubles with no integer component should have a leading zero.',
    correctionMessage: 'Add a leading zero.',
    errorSeverity: DiagnosticSeverity.INFO,
  );

  /// Constructor
  const DoubleLeadingZero() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addDoubleLiteral((node) {
      if (!node.toSource().startsWith('.')) return;
      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_AddLeadingZeroFix()];
}

class _AddLeadingZeroFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> others,
  ) {
    context.registry.addDoubleLiteral((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Add leading zero',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      builder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          analysisError.sourceRange,
          node.value.toString(),
        );
      });
    });
  }
}
