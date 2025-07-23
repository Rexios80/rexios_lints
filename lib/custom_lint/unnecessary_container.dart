import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/custom_lint/utils.dart';

bool _canBeSizedBox(InstanceCreationExpression node) {
  final hasWidth = node.argumentList.argumentByName('width') != null;
  final hasHeight = node.argumentList.argumentByName('height') != null;
  final hasChild = node.argumentList.argumentByName('child') != null;

  final length = node.argumentList.arguments.length;
  return hasWidth && hasHeight && (length == 2 || (length == 3 && hasChild));
}

bool _canBeTransform(InstanceCreationExpression node) {
  final hasTransform = node.argumentList.argumentByName('transform') != null;
  final hasTransformAlignment =
      node.argumentList.argumentByName('transformAlignment') != null;
  final hasChild = node.argumentList.argumentByName('child') != null;

  final length = node.argumentList.arguments.length;
  return hasTransform &&
      hasTransformAlignment &&
      (length == 2 || (length == 3 && hasChild));
}

/// Do not use Containers unnecessarily
class UnnecessaryContainer extends DartLintRule {
  static const _code = LintCode(
    name: 'unnecessary_container',
    problemMessage: 'Do not use Containers unnecessarily.',
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
          !containerTypeChecker.isExactlyType(targetType)) {
        return;
      }

      final length = node.argumentList.arguments.length;
      final hasChild = node.argumentList.argumentByName('child') != null;

      if (length < 2 ||
          (length == 2 && hasChild) ||
          _canBeSizedBox(node) ||
          _canBeTransform(node)) {
        reporter.atNode(node, _code);
      }
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

      final childArgument = node.argumentList.argumentByName('child');
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

        if (widget == null) return;

        build(
          message: 'Use $widget',
          replacement: '$widget${node.argumentList.toSource()}',
        );
      } else if (_canBeSizedBox(node)) {
        build(
          message: 'Use SizedBox',
          replacement: 'SizedBox${node.argumentList.toSource()}',
        );
      } else if (_canBeTransform(node)) {
        final arguments = node.argumentList.arguments
            .whereType<NamedExpression>()
            .map((argument) {
              if (argument.name.label.name == 'transformAlignment') {
                return 'alignment: ${argument.expression.toSource()}';
              }
              return argument.toSource();
            })
            .join(', ');
        build(message: 'Use Transform', replacement: 'Transform($arguments)');
      }
    });
  }
}
