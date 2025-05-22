import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';

/// Extension on [ResolvedUnitResult]
extension ResolvedUnitResultExtension on ResolvedUnitResult {
  /// Get all imports
  Iterable<ImportDirective> get imports =>
      unit.directives.whereType<ImportDirective>();

  /// Get an import by uri string
  ImportDirective? importFromUri(String uri) =>
      imports.where((e) => e.uri.stringValue == uri).firstOrNull;

  /// Get the position where a new import should be added
  int get lastImportEnd => imports.lastOrNull?.end ?? 0;

  /// Create the text to add a new import
  String createImportText(String uri, {String? as}) {
    final alias = as != null ? ' as $as' : '';
    if (lastImportEnd == 0) {
      return "import '$uri'$alias;\n\n";
    } else {
      return "\nimport '$uri'$alias;";
    }
  }
}
