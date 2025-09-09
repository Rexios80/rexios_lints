import 'package:analyzer/diagnostic/diagnostic.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Prefer UTC timestamps
class PreferTimestamps extends DartLintRule {
  static const _code = LintCode(
    name: 'prefer_timestamps',
    problemMessage:
        'Prefer creating UTC timestamps. Local time should only be used for display purposes.',
    correctionMessage: 'Use DateTime.timestamp() instead.',
    errorSeverity: DiagnosticSeverity.INFO,
  );

  /// Type checker for `DateTime`
  static const dateTimeTypeChecker = TypeChecker.fromName('DateTime');

  /// Constructor
  const PreferTimestamps() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final targetType = node.staticType;
      if (targetType == null ||
          node.constructorName.name?.name != 'now' ||
          !dateTimeTypeChecker.isExactlyType(targetType)) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_UseTimestampFix()];
}

class _UseTimestampFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    Diagnostic analysisError,
    List<Diagnostic> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Use DateTime.timestamp()',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      builder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          analysisError.sourceRange,
          'DateTime.timestamp()',
        );
      });
    });
  }
}
