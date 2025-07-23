import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Do not use Containers with less than 2 modifiers
class UnnecessaryContainer extends DartLintRule {
  static const _code = LintCode(
    name: 'unnecessary_container',
    problemMessage: 'Do not use Containers with less than 2 modifiers.',
    correctionMessage: 'Use specialized widgets instead.',
    errorSeverity: ErrorSeverity.INFO,
  );

  /// Type checker for `Container`
  static const containerTypeChecker = TypeChecker.fromName('Container');

  /// Constructor
  const UnnecessaryContainer() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final targetType = node.staticType;
      if (targetType == null ||
          !containerTypeChecker.isExactlyType(targetType) ||
          node.argumentList.arguments.length > 2) {
        return;
      }

      reporter.atNode(node, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_UseSpecializedWidgetFix()];
}

class _UseSpecializedWidgetFix extends DartFix {
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

      final childArgument = node.argumentList.arguments
          .where(
            (argument) =>
                argument.correspondingParameter?.displayName == 'child',
          )
          .firstOrNull;
      final otherArguments = node.argumentList.arguments.where(
        (argument) => argument.correspondingParameter?.displayName != 'child',
      );

      void build({required String message, required String replacement}) {
        final builder = reporter.createChangeBuilder(
          message: message,
          // TODO: Is there a standard priority for lint fixes
          priority: 999,
        );

        builder.addDartFileEdit((builder) {
          builder.addSimpleReplacement(analysisError.sourceRange, replacement);
        });
      }

      if (otherArguments.isEmpty) {
        if (childArgument == null) {
          build(
            message: 'Use SizedBox.shrink()',
            replacement: 'const SizedBox.shrink()',
          );
        } else {
          build(
            message: 'Remove this Container',
            replacement: childArgument.toSource(),
          );
        }
      } else if (otherArguments.length == 1) {
        final otherArgument = otherArguments.single;
        print(otherArgument.runtimeType);
        final parameterName = otherArgument.correspondingParameter?.displayName;
        if (parameterName == null) return;

        String widget;
        switch (parameterName) {
          case 'alignment':
            widget = 'Align';
          case 'padding':
            widget = 'Padding';
          case 'color':
            widget = 'ColoredBox';
          case 'decoration' || 'foregroundDecoration':
            widget = 'DecoratedBox';
          case 'width' || 'height':
            widget = 'SizedBox';
          case 'constraints':
            widget = 'ConstrainedBox';
          case 'margin':
            widget = 'Padding';
          case 'transform':
            widget = 'Transform';
          case 'clipBehavior':
            widget = 'ClipRRect';
          default:
            return;
        }

        var replacement = '$widget($parameterName: ${otherArgument.toSource()}';

        if (childArgument != null) {
          replacement += ', child: ${childArgument.toSource()})';
        } else {
          replacement += ')';
        }

        build(message: 'Replace with $widget', replacement: replacement);
      }
    });
  }
}
