import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

/// Prefer async/await over using raw futures
class PreferAsyncAwait extends AnalysisRule {
  /// prefer_async_await
  static const code = LintCode(
    'prefer_async_await',
    'Prefer async/await over using raw futures.',
    severity: DiagnosticSeverity.INFO,
  );

  /// Constructor
  PreferAsyncAwait() : super(name: code.name, description: code.problemMessage);

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
  /// Type checker for `Future`
  static const futreTypeChecker = TypeChecker.typeNamed(
    Future,
    inPackage: 'async',
    inSdk: true,
  );

  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final targetType = node.target?.staticType;
    if (targetType == null ||
        node.methodName.name != 'then' ||
        !futreTypeChecker.isExactlyType(targetType)) {
      return;
    }

    rule.reportAtNode(node);
  }
}
