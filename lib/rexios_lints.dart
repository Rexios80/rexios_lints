import 'package:custom_lint_builder/custom_lint_builder.dart';

/// Create the linter plugin
PluginBase createPlugin() => _RexiosLinter();

class _RexiosLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [];
}

// TODO: Dart SDK version lint (must be 3+ etc)
// TODO: No raw futures
