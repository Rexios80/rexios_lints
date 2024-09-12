import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/lints/prefer_async_await.dart';

/// Create the linter plugin
PluginBase createPlugin() => _RexiosLinter();

class _RexiosLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        PreferAsyncAwait(),
      ];
}

// TODO: No raw futures
// TODO: DateTime.timestamp() instead of DateTime.now()
// TODO: File path string literal bad (not cross platform)
