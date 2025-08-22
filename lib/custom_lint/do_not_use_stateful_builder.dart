import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Do not use StatefulBuilder
class DoNotUseStatefulBuilder extends DartLintRule {
  static const _code = LintCode(
    name: 'do_not_use_stateful_builder',
    problemMessage:
        'StatefulBuilder usage indicates this widget should be encapsulated.',
    correctionMessage: 'Create a standalone StatefulWidget class.',
    errorSeverity: ErrorSeverity.INFO,
  );

  /// Type checker for `StatefulBuilder`
  static const statefulBuilderTypeChecker = TypeChecker.fromName(
    'StatefulBuilder',
  );

  /// Constructor
  const DoNotUseStatefulBuilder() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final targetType = node.staticType;
      if (targetType == null ||
          !statefulBuilderTypeChecker.isAssignableFromType(targetType)) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }
}
