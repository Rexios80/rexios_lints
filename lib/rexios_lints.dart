import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/lints/do_not_use_raw_paths.dart';
import 'package:rexios_lints/lints/prefer_async_await.dart';
import 'package:rexios_lints/lints/prefer_timestamps.dart';

/// Create the linter plugin
PluginBase createPlugin() => _RexiosLinter();

class _RexiosLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        DoNotUseRawPaths(),
        PreferAsyncAwait(),
        PreferTimestamps(),
      ];
}
