import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/custom_lint/utils.dart';

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
      bool canBeSizedBox() {
        final hasWidth = node.argumentList.argumentByName('width') != null;
        final hasHeight = node.argumentList.argumentByName('height') != null;
        final hasChild = node.argumentList.argumentByName('child') != null;
        return hasWidth && hasHeight && hasChild;
      }

      bool canBeTransform() {
        final hasTransform =
            node.argumentList.argumentByName('transform') != null;
        final hasTransformAlignment =
            node.argumentList.argumentByName('transformAlignment') != null;
        return hasTransform && hasTransformAlignment;
      }

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

      final childArgument =
          node.argumentList.argumentByName('child') as NamedExpression?;
      final otherArguments = node.argumentList.arguments.where(
        (argument) => argument != childArgument,
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
            replacement: childArgument.expression.toSource(),
          );
        }
      } else if (otherArguments.length == 1) {
        final otherArgument = otherArguments.single as NamedExpression;

        final widget = switch (otherArgument.name.label.name) {
          'alignment' => 'Align',
          'padding' => 'Padding',
          'color' => 'ColoredBox',
          'decoration' || 'foregroundDecoration' => 'DecoratedBox',
          'width' || 'height' => 'SizedBox',
          'constraints' => 'ConstrainedBox',
          'margin' => 'Padding',
          'transform' => 'Transform',
          'clipBehavior' => 'ClipRRect',
          _ => null,
        };

        var replacement = '$widget(${otherArgument.toSource()}';

        if (childArgument != null) {
          replacement += ', ${childArgument.toSource()})';
        } else {
          replacement += ')';
        }

        build(message: 'Use $widget', replacement: replacement);
      }
    });
  }
}
