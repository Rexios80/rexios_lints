import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:rexios_lints/custom_lint/do_not_use_raw_paths.dart';
import 'package:rexios_lints/custom_lint/do_not_use_stateful_builder.dart';
import 'package:rexios_lints/custom_lint/double_leading_zero.dart';
import 'package:rexios_lints/custom_lint/inline_context_lookups.dart';
import 'package:rexios_lints/custom_lint/not_null_assertion.dart';
import 'package:rexios_lints/custom_lint/prefer_async_await.dart';
import 'package:rexios_lints/custom_lint/prefer_immutable_classes.dart';
import 'package:rexios_lints/custom_lint/prefer_timestamps.dart';
import 'package:rexios_lints/custom_lint/unnecessary_container.dart';

/// Create the linter plugin
PluginBase createPlugin() => _RexiosLinter();

class _RexiosLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
    DoNotUseRawPaths(),
    DoNotUseStatefulBuilder(),
    DoubleLeadingZero(),
    InlineContextLookups(),
    NotNullAssertion(),
    PreferAsyncAwait(),
    PreferImmutableClasses(),
    PreferTimestamps(),
    UnnecessaryContainer(),
  ];
}
