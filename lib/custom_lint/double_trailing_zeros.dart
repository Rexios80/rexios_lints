import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Do not add trailing zeros to double literals
class DoubleTrailingZeros extends DartLintRule {
  static const _code = LintCode(
    name: 'double_trailing_zeros',
    problemMessage: 'Trailing zeros in double literals are unnecessary.',
    correctionMessage: 'Remove the trailing zeros.',
    errorSeverity: ErrorSeverity.INFO,
  );

  /// Constructor
  const DoubleTrailingZeros() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addDoubleLiteral((node) {
      final source = node.toSource();
      if (!source.contains('.') || !source.endsWith('0')) return;

      final parent = node.parent;
      final isImplicitVariableDeclaration =
          parent is VariableDeclaration &&
          (parent.declaredElement2?.hasImplicitType ?? false);
      if (isImplicitVariableDeclaration && source.endsWith('.0')) return;

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_RemoveTrailingZerosFix()];
}

class _RemoveTrailingZerosFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addDoubleLiteral((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Remove trailing zeros',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      var doubleString = node.value.toString();
      // Strip trailing `.0` so it can be conditionally added back later
      if (doubleString.endsWith('.0')) {
        doubleString = doubleString.substring(0, doubleString.length - 2);
      }

      final parent = node.parent;
      final isImplicitVariableDeclaration =
          parent is VariableDeclaration &&
          (parent.declaredElement2?.hasImplicitType ?? false);

      final fixedDoubleString =
          isImplicitVariableDeclaration && !doubleString.contains('.')
          ? '$doubleString.0'
          : doubleString;

      builder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          analysisError.sourceRange,
          fixedDoubleString,
        );
      });
    });
  }
}
