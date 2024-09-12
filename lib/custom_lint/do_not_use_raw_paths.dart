import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Do not use raw paths
class DoNotUseRawPaths extends DartLintRule {
  static const _code = LintCode(
    name: 'do_not_use_raw_paths',
    problemMessage: 'Raw path strings are platform-specific.',
    correctionMessage: 'Use the join method from the path package instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  /// Type checker for `FileSystemEntity`
  static const fileSystemEntityTypeChecker =
      TypeChecker.fromName('FileSystemEntity');

  /// Constructor
  const DoNotUseRawPaths() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final targetType = node.staticType;
      if (targetType == null ||
          !fileSystemEntityTypeChecker.isAssignableFromType(targetType)) return;

      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;

      final pathArgument = arguments.first;
      if (pathArgument is! StringLiteral) return;

      final path = pathArgument.stringValue;
      if (path == null || !{'/', '\\'}.any(path.contains)) return;

      reporter.atNode(node, _code);
    });
  }
}
