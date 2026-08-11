import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:rexios_lints/rexios_lints.dart';

/// The rexios_lints analyzer plugin
final plugin = RexiosLintsPlugin();

/// The rexios_lints analyzer plugin
class RexiosLintsPlugin extends Plugin {
  @override
  String get name => 'rexios_lints';

  @override
  void register(PluginRegistry registry) {
    final rules = [
      doNotUseRawPaths,
      doNotUseStatefulBuilder,
      doubleLeadingZero,
      inlineContextLookups,
      notNullAssertion,
      preferAsyncAwait,
      preferImmutableClasses,
      preferTimestamps,
      unnecessaryContainer,
    ];

    for (final rule in rules) {
      rule.register(registry);
    }
  }
}
