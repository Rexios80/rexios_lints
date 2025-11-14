// import 'package:analyzer/dart/ast/token.dart';
// import 'package:analyzer/error/error.dart' hide LintCode;
// import 'package:analyzer/error/listener.dart';
// import 'package:custom_lint_builder/custom_lint_builder.dart';

// /// Do not use not-null assertion operators
// class NotNullAssertion extends DartLintRule {
//   static const _code = LintCode(
//     name: 'not_null_assertion',
//     problemMessage: 'Do not use not-null assertion operators.',
//     correctionMessage: 'Use null-aware operators instead.',
//     url:
//         'https://dart.dev/null-safety/understanding-null-safety#working-with-nullable-types',
//     errorSeverity: DiagnosticSeverity.WARNING,
//   );

//   /// Constructor
//   const NotNullAssertion() : super(code: _code);

//   @override
//   void run(
//     CustomLintResolver resolver,
//     DiagnosticReporter reporter,
//     CustomLintContext context,
//   ) {
//     context.registry.addPostfixExpression((node) {
//       if (node.operator.type != TokenType.BANG) return;

//       reporter.atNode(node, _code);
//     });
//   }
// }
