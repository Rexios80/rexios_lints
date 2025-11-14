import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Prefer async/await over using raw futures
class PreferAsyncAwait extends DartLintRule {
  static const _code = LintCode(
    name: 'prefer_async_await',
    problemMessage: 'Prefer async/await over using raw futures.',
    url:
        'https://dart.dev/effective-dart/usage#prefer-asyncawait-over-using-raw-futures',
    errorSeverity: DiagnosticSeverity.INFO,
  );

  /// Type checker for `Future`
  static const futreTypeChecker = TypeChecker.fromName('Future');

  /// Constructor
  const PreferAsyncAwait() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      final targetType = node.target?.staticType;
      if (targetType == null ||
          node.methodName.name != 'then' ||
          !futreTypeChecker.isExactlyType(targetType)) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }
}
