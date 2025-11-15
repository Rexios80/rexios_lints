import 'dart:io';

import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/edit/dart/dart_fix_kind_priority.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/analysis_rule/rule_context.dart';
import 'package:analyzer/analysis_rule/rule_visitor_registry.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer_plugin/utilities/fixes/fixes.dart';

final _pathSeparatorRegex = RegExp(r'[\\\/]');
final _stringInterpolation1 = RegExp(r'^\${(.+?)}(.+?)?$');
final _stringInterpolation2 = RegExp(r'^\$(\w+?)$');

/// Do not use raw paths
class DoNotUseRawPaths extends AnalysisRule {
  /// do_not_use_raw_paths
  static const code = LintCode(
    'do_not_use_raw_paths',
    'Raw path strings are platform-specific.',
    correctionMessage: 'Use the join method from the path package instead.',
    severity: DiagnosticSeverity.WARNING,
  );

  /// Constructor
  DoNotUseRawPaths() : super(name: code.name, description: code.problemMessage);

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

class _Visitor extends SimpleAstVisitor<void> {
  /// Type checker for `FileSystemEntity`
  static final fileSystemEntityTypeChecker = TypeChecker.typeNamed(
    FileSystemEntity,
    inPackage: 'io',
    inSdk: true,
  );

  final AnalysisRule rule;
  final RuleContext context;

  _Visitor(this.rule, this.context);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    final targetType = node.staticType;
    if (targetType == null ||
        !fileSystemEntityTypeChecker.isAssignableFromType(targetType)) {
      return;
    }

    final arguments = node.argumentList.arguments;
    if (arguments.isEmpty) return;

    final pathArgument = arguments.first;
    if (pathArgument is! StringLiteral) return;

    // Strip leading/trailing quotes
    final pathSource = pathArgument.toSource();
    if (!_pathSeparatorRegex.hasMatch(pathSource)) return;

    rule.reportAtNode(pathArgument);
  }
}

/// Fix for `do_not_use_raw_paths`
class UsePathJoin extends ResolvedCorrectionProducer {
  static const _kind = FixKind(
    'rexios_lints.fix.usePathJoin',
    DartFixKindPriority.standard,
    'Use path.join(...)',
  );

  /// Constructor
  UsePathJoin({required super.context});

  @override
  CorrectionApplicability get applicability =>
      CorrectionApplicability.singleLocation;

  @override
  FixKind get fixKind => _kind;

  @override
  Future<void> compute(ChangeBuilder builder) async {
    final path = node.toSource();
    final segmentsString = createSegmentsString(path);

    await builder.addDartFileEdit(file, (builder) {
      final result = builder.importLibraryElement(
        Uri.parse('package:path/path.dart'),
        prefix: 'path',
      );

      final pathAlias = result.prefix ?? 'path';
      builder.addSimpleReplacement(
        range.entity(node),
        '$pathAlias.join($segmentsString)',
      );
    });
  }

  /// Split the given path into a list of segments
  static String createSegmentsString(String path) {
    final sanitized = path
        // Replace escaped backslashes with forward slashes
        .replaceAll(r'\\', '/')
        // Replace unescaped backslashes with forward slashes
        .replaceAll(r'\', '/')
        // Remove leading raw string prefix
        .replaceFirst(RegExp("^r'"), "'")
        .replaceFirst(RegExp('^r"'), '"');

    return sanitized
        // Strip leading/trailing quotes
        .substring(1, sanitized.length - 1)
        .split('/')
        .skip(path.startsWith('/') ? 1 : 0)
        .map((segment) {
          final si1Match = _stringInterpolation1.firstMatch(segment);
          if (si1Match != null) {
            if (si1Match[2] == null) {
              // Strip interpolation
              return si1Match[1];
            } else {
              // Do not strip interpolation
              return "'$segment'";
            }
          }

          final si2Match = _stringInterpolation2.firstMatch(segment);
          if (si2Match != null) return si2Match[1];

          return "'$segment'";
        })
        .join(', ');
  }
}
