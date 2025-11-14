import 'package:analyzer/dart/ast/ast.dart';
import 'package:collection/collection.dart';

/// Extension on [ArgumentList]
extension ArgumentListExtension on ArgumentList {
  /// Get an argument by name
  @Deprecated('still needed?')
  NamedExpression? argumentByName(String name) => arguments
      .whereType<NamedExpression>()
      .firstWhereOrNull((argument) => argument.name.label.name == name);
}
