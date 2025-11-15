import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

/// Prefer immutable classes
class PreferImmutableClasses extends AnalysisRule {
  static const code = LintCode(
    'prefer_immutable_classes',
    'Classes with only getters should be immutable.',
    correctionMessage: 'Add the @immutable annotation to the class.',
    severity: DiagnosticSeverity.INFO,
  );

  /// Constructor
  PreferImmutableClasses()
    : super(name: code.name, description: code.problemMessage);

  @override
  LintCode get diagnosticCode => code;

  @override
  void registerNodeProcessors(
    RuleVisitorRegistry registry,
    RuleContext context,
  ) {
    final visitor = _Visitor(this, context);
    registry.addClassDeclaration(this, visitor);
  }
}

/// Get all supertypes (not interfaces or mixins)
List<InterfaceType> _allSuperclasses(
  InterfaceElement element, {
  List<InterfaceType> supertypes = const [],
}) {
  final supertype = element.supertype;
  if (supertype == null) return supertypes;

  return _allSuperclasses(
    supertype.element,
    supertypes: [...supertypes, supertype],
  );
}

class _Visitor extends SimpleAstVisitor<void> {
  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final element = node.declaredFragment?.element;
    if (element == null) return;

    final hasConstructorWithParameters = node.members.any(
      (e) => e is ConstructorDeclaration && e.parameters.parameters.isNotEmpty,
    );
    if (!hasConstructorWithParameters) return;

    final isImmutable = [
      ...node.metadata.map((e) => e.name.name),
      ..._allSuperclasses(element)
          .expand((e) => e.element.metadata.annotations)
          .map((e) => e.element?.displayName)
          .whereType<String>(),
    ].any((e) => e == 'immutable');
    if (isImmutable) return;

    final hasOnlyGetters =
        node.members
            .whereType<FieldDeclaration>()
            .where((e) => !e.isStatic)
            .every((e) => e.fields.isFinal) &&
        element.allSupertypes.every((e) => e.setters.isEmpty);
    if (!hasOnlyGetters) return;

    rule.reportAtToken(node.name);
  }
}

/// Fix for `prefer_immutable_classes`

class MakeImmutable extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.makeImmutable',
    DartFixKindPriority.standard,
    'Add the @immutable annotation to the class',
  );

  /// Constructor
  MakeImmutable({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final node = this.node;
    if (node is! ClassDeclaration) return;

    await builder.addDartFileEdit(file, (builder) {
      builder.importLibraryElement(Uri.parse('package:meta/meta.dart'));

      builder.addSimpleInsertion(
        node.firstTokenAfterCommentAndMetadata.offset,
        '@immutable\n',
      );
    });
  }
}
