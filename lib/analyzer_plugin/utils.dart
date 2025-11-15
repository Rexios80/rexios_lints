import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Extension on [ArgumentList]
extension ArgumentListExtension on ArgumentList {
  /// Get an argument by name
  NamedExpression? argumentByName(String name) => arguments
      .whereType<NamedExpression>()
      .firstWhereOrNull((argument) => argument.name.label.name == name);
}

/// Create a Type class whose toString() method returns the name
///
/// Workaround for TypeChecker.typeNamed() not accepting a String.
@immutable
class TypeNamed implements Type {
  /// The name of the type
  final String name;

  /// Constructor
  const TypeNamed(this.name);

  @override
  String toString() => name;
}

/// Extension on [InterfaceElement]
extension InterfaceElementExtension on InterfaceElement {
  /// Get all supertypes (not interfaces or mixins)
  List<InterfaceType> get allSuperclasses => _allSuperclasses(this);

  List<InterfaceType> _allSuperclasses(
    InterfaceElement element, {
    List<InterfaceType> superclasses = const [],
  }) {
    final superclass = element.supertype;
    if (superclass == null) return superclasses;

    return _allSuperclasses(
      superclass.element,
      superclasses: [...superclasses, superclass],
    );
  }
}

/// Extension on [LibraryElement]
extension LibraryElementExtension on LibraryElement {
  /// Check if this library defines the given name
  bool definesName(String name) => fragments
      .expand((e) => e.libraryImports)
      .any((e) => e.namespace.definedNames2.values.any((e) => e.name == name));
}
