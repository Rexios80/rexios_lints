import 'package:analysis_server_plugin/edit/dart/correction_producer.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:analyzer/analysis_rule/analysis_rule.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:meta/meta.dart';

/// A function that can be executed to create a [CorrectionProducer].
/// 
/// Copied from [analysis_server_plugin] since it is not exported.
typedef ProducerGenerator =
    CorrectionProducer<ParsedUnitResult> Function({
      required CorrectionProducerContext context,
    });

/// Wrapper for a lint rule and its fixes
@immutable
class RexiosLint {
  /// The lint rule
  final AnalysisRule rule;

  /// The fixes for the lint rule
  final List<ProducerGenerator> fixes;

  /// Constructor
  const RexiosLint({required this.rule, this.fixes = const []});

  /// Register the lint rule and its fixes with the analyzer
  void register(PluginRegistry registry) {
    registry.registerWarningRule(rule);
    for (final fix in fixes) {
      registry.registerFixForRule(rule.diagnosticCode, fix);
    }
  }
}
