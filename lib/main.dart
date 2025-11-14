import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:rexios_lints/analyzer_plugin/do_not_use_raw_paths.dart';
import 'package:rexios_lints/analyzer_plugin/do_not_use_stateful_builder.dart';
import 'package:rexios_lints/analyzer_plugin/double_leading_zero.dart';
import 'package:rexios_lints/analyzer_plugin/inline_context_lookups.dart';
import 'package:rexios_lints/analyzer_plugin/not_null_assertion.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_async_await.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_immutable_classes.dart';
import 'package:rexios_lints/analyzer_plugin/prefer_timestamps.dart';
import 'package:rexios_lints/analyzer_plugin/unnecessary_container.dart';

/// The rexios_lints analyzer plugin
final plugin = RexiosLintsPlugin();

/// The rexios_lints analyzer plugin
class RexiosLintsPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry
      ..registerWarningRule(DoNotUseRawPaths())
      ..registerFixForRule(DoNotUseRawPaths.code, UsePathJoin.new)
      ..registerWarningRule(DoNotUseStatefulBuilder())
      ..registerWarningRule(DoubleLeadingZero())
      ..registerWarningRule(InlineContextLookups())
      ..registerWarningRule(NotNullAssertion())
      ..registerWarningRule(PreferAsyncAwait())
      ..registerWarningRule(PreferImmutableClasses())
      ..registerWarningRule(PreferTimestamps())
      ..registerWarningRule(UnnecessaryContainer());
  }
}
