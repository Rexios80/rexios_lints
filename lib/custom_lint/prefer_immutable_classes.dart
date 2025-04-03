import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/custom_lint/utils.dart';

/// Prefer immutable classes
class PreferImmutableClasses extends DartLintRule {
  static const _code = LintCode(
    name: 'prefer_immutable_classes',
    problemMessage: 'Classes with only getters should be immutable.',
    correctionMessage: 'Add the @immutable annotation to the class.',
    errorSeverity: ErrorSeverity.INFO,
  );

  /// Constructor
  const PreferImmutableClasses() : super(code: _code);

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addClassDeclaration((node) {
      final isImmutable = node.metadata.any((e) => e.name.name == 'immutable');
      if (isImmutable) return;

      final fields = node.members.whereType<FieldDeclaration>();
      if (fields.isEmpty) return;

      final hasOnlyGetters = fields.every(
        (e) => !e.isStatic && e.fields.isFinal,
      );

      if (!hasOnlyGetters) return;

      reporter.atToken(node.name, _code);
    });
  }

  @override
  List<Fix> getFixes() => [_MakeImmutableFix()];
}

class _MakeImmutableFix extends DartFix {
  @override
  void run(
    CustomLintResolver resolver,
    ChangeReporter reporter,
    CustomLintContext context,
    AnalysisError analysisError,
    List<AnalysisError> others,
  ) async {
    final resolved = await resolver.getResolvedUnitResult();

    context.registry.addClassDeclaration((node) {
      if (!analysisError.sourceRange.intersects(node.sourceRange)) return;

      final builder = reporter.createChangeBuilder(
        message: 'Add the @immutable annotation to the class',
        // TODO: Is there a standard priority for lint fixes
        priority: 999,
      );

      builder.addDartFileEdit((builder) {
        final metaImport = resolved.importFromUri('package:meta/meta.dart');
        if (metaImport == null) {
          builder.addSimpleInsertion(
            resolved.lastImportEnd,
            resolved.createImportText('package:meta/meta.dart'),
          );
        }

        builder.addSimpleInsertion(node.offset, '@immutable\n');
      });
    });
  }
}
