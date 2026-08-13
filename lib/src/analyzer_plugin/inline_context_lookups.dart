import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:rexios_lints/src/model/rexios_lint.dart';

/// Inline context lookups lint rule
final inlineContextLookups = RexiosLint(rule: InlineContextLookups());

/// Avoid inline context lookups
class InlineContextLookups extends AnalysisRule {
  /// inline_context_lookups
  static const code = LintCode(
    'inline_context_lookups',
    'Avoid inline context lookups.',
    correctionMessage:
        'Store the result of context lookups in reusable variables.',
  );

  /// Constructor
  new() : super(name: code.lowerCaseName, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addMethodInvocation(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const new(this.rule, this.context);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.parent is VariableDeclaration ||
        !node.methodName.name.toLowerCase().endsWith('of') ||
        node.argumentList.arguments.length != 1 ||
        node.argumentList.arguments.first.toSource() != 'context') {
      return;
    }

    rule.reportAtNode(node);
  }
}
