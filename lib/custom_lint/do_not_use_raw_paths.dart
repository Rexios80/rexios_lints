import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _pathSeparatorRegex = RegExp(r'[\\/]');

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
          !fileSystemEntityTypeChecker.isAssignableFromType(targetType)) {
        return;
      }

      final arguments = node.argumentList.arguments;
      if (arguments.isEmpty) return;

      final pathArgument = arguments.first;
      if (pathArgument is! StringLiteral) return;

      final path = pathArgument.stringValue;
      if (path == null || !_pathSeparatorRegex.hasMatch(path)) return;

      reporter.atNode(pathArgument, _code, data: path);
    });
  }

  @override
  List<Fix> getFixes() => [_UsePathJoinFix()];
}

class _UsePathJoinFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Use path.join(...)',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      final path = analysisError.data as String;
      final segments = path.split(_pathSeparatorRegex);
      final segmentsString = segments.map((e) => "'$e'").join(', ');

      builder.addDartFileEdit((builder) {
        builder.addSimpleReplacement(
          analysisError.sourceRange,
          'path.join($segmentsString)',
        );
      });
    });
  }
}
