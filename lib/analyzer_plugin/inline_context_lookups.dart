import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Avoid inline context lookups
class InlineContextLookups extends DartLintRule {
  static const _code = LintCode(
    name: 'inline_context_lookups',
    problemMessage: 'Avoid inline context lookups.',
    correctionMessage:
        'Store the result of context lookups in reusable variables.',
    url: 'https://redd.it/1liezgz',
    errorSeverity: DiagnosticSeverity.INFO,
  );

  /// Constructor
  const InlineContextLookups() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addMethodInvocation((node) {
      if (node.parent is VariableDeclaration ||
          !node.methodName.name.toLowerCase().endsWith('of') ||
          node.argumentList.arguments.length != 1 ||
          node.argumentList.arguments.first.toSource() != 'context') {
        return;
      }

      reporter.atNode(node, _code);
    });
  }
}
