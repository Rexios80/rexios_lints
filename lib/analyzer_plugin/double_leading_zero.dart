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

/// Do use leading zeros in double literals
class DoubleLeadingZero extends AnalysisRule {
  /// double_leading_zero
  static const code = LintCode(
    'double_leading_zero',
    'Doubles with no integer component should have a leading zero.',
    correctionMessage: 'Add a leading zero.',
    severity: DiagnosticSeverity.INFO,
  );

  /// Constructor
  DoubleLeadingZero()
    : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addDoubleLiteral(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  const _Visitor(this.rule, this.context);

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    if (!node.toSource().startsWith('.')) return;
    rule.reportAtNode(node);
  }
}

/// Fix for `double_leading_zero`
class AddLeadingZero extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.addLeadingZero',
    DartFixKindPriority.standard,
    'Add leading zero',
  );

  /// Constructor
  AddLeadingZero({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! DoubleLiteral) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(range.entity(node), node.value.toString());
    });
  }
}
