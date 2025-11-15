import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:rexios_lints/analyzer_plugin/utils.dart';
import 'package:source_gen/source_gen.dart';

/// Do not use StatefulBuilder
class DoNotUseStatefulBuilder extends AnalysisRule {
  /// do_not_use_stateful_builder
  static const code = LintCode(
    'do_not_use_stateful_builder',
    'StatefulBuilder usage indicates this widget should be encapsulated.',
    correctionMessage: 'Create a standalone StatefulWidget class.',
  );

  /// Constructor
  DoNotUseStatefulBuilder()
    : super(name: code.name, description: code.problemMessage);

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
  /// Type checker for `StatefulBuilder`
  static const statefulBuilderTypeChecker = TypeChecker.typeNamed(
    TypeNamed('StatefulBuilder'),
    inPackage: 'flutter',
  );

  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final targetType = node.staticType;
    if (targetType == null ||
        !statefulBuilderTypeChecker.isAssignableFromType(targetType)) {
      return;
    }

    rule.reportAtNode(node);
  }
}
