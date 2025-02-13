import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

final _pathSeparatorRegex = RegExp(r'[\\/]');
final _stringRegex = RegExp(r'''(['"]{1,3})([\s\S]*?)\1''');
final _stringInterpolation1 = RegExp(r'^\${(.+?)}(.+?)?$');
final _stringInterpolation2 = RegExp(r'^\$(\w+?)$');

/// Do not use raw paths
class DoNotUseRawPaths extends DartLintRule {
  static const _code = LintCode(
    name: 'do_not_use_raw_paths',
    problemMessage: 'Raw path strings are platform-specific.',
    correctionMessage: 'Use the join method from the path package instead.',
    errorSeverity: ErrorSeverity.WARNING,
  );

  /// Type checker for `FileSystemEntity`
  static const fileSystemEntityTypeChecker = TypeChecker.fromName(
    'FileSystemEntity',
  );

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

      // Strip quotes from source
      final path = _stringRegex.firstMatch(pathArgument.toSource())![2]!;
      if (!_pathSeparatorRegex.hasMatch(path)) return;

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
  ) async {
    final resolved = await resolver.getResolvedUnitResult();

    context.registry.addInstanceCreationExpression((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Use path.join(...)',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      final path = analysisError.data as String;
      final segmentsString = path
          .split(_pathSeparatorRegex)
          .map((segment) {
            final si1Match = _stringInterpolation1.firstMatch(segment);
            if (si1Match != null) {
              final content = si1Match[1]!;
              if (si1Match[2] == null) {
                // Strip interpolation
                return content;
              } else {
                // Do not strip interpolation
                return "'$segment'";
              }
            }

            final si2Match = _stringInterpolation2.firstMatch(segment);
            if (si2Match != null) return si2Match[1]!;

            return "'$segment'";
          })
          .join(', ');

      final imports = resolved.unit.directives.whereType<ImportDirective>();
      final pathImport =
          imports
              .where((e) => e.uri.stringValue == 'package:path/path.dart')
              .firstOrNull;

      final pathAlias = pathImport?.prefix ?? 'path';

      builder.addDartFileEdit((builder) {
        if (pathImport == null) {
          builder.addSimpleInsertion(
            imports.last.end,
            "\nimport 'package:path/path.dart' as path;",
          );
        }

        builder.addSimpleReplacement(
          analysisError.sourceRange,
          '$pathAlias.join($segmentsString)',
        );
      });
    });
  }
}
