import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:meta/meta.dart';
import 'package:rexios_lints/analyzer_plugin/utils.dart';
import 'package:source_gen/source_gen.dart';

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
class UnnecessaryContainer extends AnalysisRule {
  /// unnecessary_container
  static const code = LintCode(
    'unnecessary_container',
    'Do not use Containers unnecessarily.',
    correctionMessage: 'Use specialized widgets instead.',
  );

  /// Constructor
  UnnecessaryContainer()
    : super(name: code.lowerCaseName, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addInstanceCreationExpression(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  /// Type checker for `Container`
  static const containerTypeChecker = TypeChecker.typeNamed(
    TypeNamed('Container'),
    inPackage: 'flutter',
  );

  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final targetType = node.staticType;
    if (targetType == null || !containerTypeChecker.isExactlyType(targetType)) {
      return;
    }

    final length = node.argumentList.arguments.length;
    final hasChild = node.argumentList.argumentByName('child') != null;

    if (length < 2 ||
        (length == 2 && hasChild) ||
        _canBeSizedBox(node) ||
        _canBeTransform(node)) {
      rule.reportAtNode(node);
    }
  }
}

/// Fix for `unnecessary_container`
class UseSpecializedWidget extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.useSpecializedWidget',
    DartFixKindPriority.standard,
    'Use specialized widget',
  );

  /// Constructor
  UseSpecializedWidget({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! InstanceCreationExpression) return;

    final childArgument = node.argumentList.argumentByName('child');
    final otherArguments = node.argumentList.arguments.where(
      (argument) => argument != childArgument,
    );

    Future<void> build(String replacement) {
      return builder.addDartFileEdit(file, (builder) {
        builder.addSimpleReplacement(range.entity(node), replacement);
      });
    }

    if (otherArguments.isEmpty) {
      if (childArgument == null) {
        await build('const SizedBox.shrink()');
      } else {
        await build(childArgument.expression.toSource());
      }
    } else if (otherArguments.length == 1) {
      final otherArgument = otherArguments.single as NamedExpression;

      final widget = switch (otherArgument.name.label.name) {
        'alignment' => 'Align',
        'padding' || 'margin' => 'Padding',
        'color' => 'ColoredBox',
        'decoration' || 'foregroundDecoration' => 'DecoratedBox',
        'width' || 'height' => 'SizedBox',
        'constraints' => 'ConstrainedBox',
        'transform' => 'Transform',
        'clipBehavior' => 'ClipRRect',
        _ => null,
      };

      if (widget == null) return;

      final arguments = node.argumentList
          .toSource()
          .replaceFirst('foregroundDecoration:', 'decoration:')
          .replaceFirst('margin:', 'padding:');

      await build('$widget$arguments');
    } else if (_canBeSizedBox(node)) {
      await build('SizedBox${node.argumentList.toSource()}');
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
      await build('Transform($arguments)');
    }
  }
}
