import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pub_semver/pub_semver.dart';

/// Check if this project is using Dart 3
bool isDart3(CustomLintContext context) {
  final sdkVersionConstraint = context.pubspec.environment?['sdk'];
  if (sdkVersionConstraint == null || sdkVersionConstraint is! VersionRange) {
    return false;
  }

  final minVersion = sdkVersionConstraint.min;
  if (minVersion == null) return false;

  return minVersion >= Version(3, 0, 0);
}
