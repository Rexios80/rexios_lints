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

/// Create a Type class who's toString() method returns the name
///
/// Workaround for TypeChecker.typeNamed() not accepting a String.
class TypeNamed implements Type {
  /// The name of the type
  final String name;

  /// Constructor
  const TypeNamed(this.name);

  @override
  String toString() => name;
}
