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
import 'package:rexios_lints/src/utils.dart';
import 'package:rexios_lints/src/model/rexios_lint.dart';
import 'package:source_gen/source_gen.dart';

/// Prefer timestamps lint rule
final preferTimestamps = RexiosLint(
  rule: PreferTimestamps(),
  fixes: [UseDateTimeTimestamp.new, UseClockNowUtc.new],
);

/// Prefer UTC timestamps
class PreferTimestamps extends AnalysisRule {
  /// prefer_timestamps
  static const code = LintCode(
    'prefer_timestamps',
    'Prefer creating UTC timestamps. Local time should only be used for display purposes.',
    correctionMessage:
        'Use DateTime.timestamp() or clock.now().toUtc() instead.',
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
    registry
      ..addInstanceCreationExpression(this, visitor)
      ..addMethodInvocation(this, visitor);
  }
}

@immutable
class _Visitor extends SimpleAstVisitor<void> {
  /// Type checker for `DateTime`
  static const dateTimeTypeChecker = TypeChecker.typeNamed(
    DateTime,
    inPackage: 'core',
    inSdk: true,
  );

  /// Type checker for `Clock` from `package:clock`
  static final clockTypeChecker = TypeChecker.typeNamed(
    TypeNamed('Clock'),
    inPackage: 'clock',
  );

  final AnalysisRule rule;
  final RuleContext context;

  const new(this.rule, this.context);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final targetType = node.staticType;
    if (targetType == null ||
        node.constructorName.name?.name != 'now' ||
        !dateTimeTypeChecker.isExactlyType(targetType)) {
      return;
    }

    rule.reportAtNode(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    final targetType = node.target?.staticType;
    if (targetType == null ||
        node.methodName.name != 'now' ||
        !clockTypeChecker.isExactlyType(targetType)) {
      return;
    }

    // Allow clock.now().toUtc()
    final parent = node.parent;
    if (parent is MethodInvocation &&
        parent.target == node &&
        parent.methodName.name == 'toUtc') {
      return;
    }

    rule.reportAtNode(node);
  }
}

/// Fix for `prefer_timestamps` that replaces `DateTime.now()` with
/// `DateTime.timestamp()`
class UseDateTimeTimestamp extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.useTimestamp',
    DartFixKindPriority.standard,
    'Use DateTime.timestamp()',
  );

  /// Constructor
  new({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! InstanceCreationExpression) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleReplacement(range.entity(node), 'DateTime.timestamp()');
    });
  }
}

/// Fix for `prefer_timestamps` that appends `.toUtc()` to `clock.now()`
class UseClockNowUtc extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.useClockNowUtc',
    DartFixKindPriority.standard,
    'Use clock.now().toUtc()',
  );

  /// Constructor
  new({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! MethodInvocation) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.addSimpleInsertion(node.end, '.toUtc()');
    });
  }
}
