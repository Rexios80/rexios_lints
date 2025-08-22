// ignore_for_file: document_ignores

import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';

// ignore: prefer_single_quotes
const string = "";

Future<void> future() async {}

void unawaitedFutures() async {
  // ignore: unawaited_futures
  future();
  await future();
  unawaited(future());
}

@immutable
class UseSuperParametersBase {
  final int param;

  const UseSuperParametersBase(this.param);
}

@immutable
class UseSuperParameters extends UseSuperParametersBase {
  // ignore: use_super_parameters
  const UseSuperParameters(int param) : super(param);
}

void preferFinal() {
  // ignore: prefer_final_in_for_each
  for (var i in []) {
    print(i);
  }

  // ignore: prefer_final_locals
  var i = 0;
  print(i);
}

void preferAsyncAwait() async {
  // expect_lint: prefer_async_await
  await Future.value().then((_) {});
}

void preferTimestamps() {
  // expect_lint: prefer_timestamps
  DateTime.now();
  DateTime.timestamp();
}

void doNotUseRawPaths() {
  // expect_lint: do_not_use_raw_paths
  Directory('path/to/directory');
  // expect_lint: do_not_use_raw_paths
  File('path/to/file');
  // expect_lint: do_not_use_raw_paths
  Link('path/to/entity');

  // expect_lint: do_not_use_raw_paths
  Directory('path\\to\\directory');
  File('file.txt');

  // expect_lint: do_not_use_raw_paths
  Directory(r'path\to\directory');
}

// expect_lint: prefer_immutable_classes
class PreferImmutableClasses {
  final int value;

  PreferImmutableClasses(this.value);
}

@immutable
class ImmutableSupertype {
  const ImmutableSupertype();
}

class ImmutableSubclass extends ImmutableSupertype {
  final String asdf;

  const ImmutableSubclass(this.asdf);
}

class MutableSupertype {
  int value;

  MutableSupertype(this.value);
}

class MutableSubclass extends MutableSupertype {
  MutableSubclass(super.value);
}

void inlineContextLookups(BuildContext context) {
  final navigator = Navigator.of(context);
  navigator.pop();

  // expect_lint: inline_context_lookups
  Navigator.of(context).pop();

  final accessibleNavigation = MediaQuery.maybeAccessibleNavigationOf(context);
  print(accessibleNavigation);

  // expect_lint: inline_context_lookups
  print(MediaQuery.maybeAccessibleNavigationOf(context));
}

void unnecessaryContainer() {
  // expect_lint: unnecessary_container
  Container();

  // expect_lint: unnecessary_container
  Container(child: Text('Hello'));

  // expect_lint: unnecessary_container
  Container(alignment: Alignment.center);

  // expect_lint: unnecessary_container
  Container(padding: EdgeInsets.zero);

  // expect_lint: unnecessary_container
  Container(color: Color(0x00000000));

  // expect_lint: unnecessary_container
  Container(decoration: BoxDecoration());

  // expect_lint: unnecessary_container
  Container(foregroundDecoration: BoxDecoration());

  // expect_lint: unnecessary_container
  Container(width: 0);

  // expect_lint: unnecessary_container
  Container(height: 0);

  // expect_lint: unnecessary_container
  Container(constraints: BoxConstraints());

  // expect_lint: unnecessary_container
  Container(margin: EdgeInsets.zero);

  // expect_lint: unnecessary_container
  Container(transform: Matrix4.identity());

  // expect_lint: unnecessary_container
  Container(clipBehavior: Clip.none);

  // expect_lint: unnecessary_container
  Container(width: 0, height: 0);

  // expect_lint: unnecessary_container
  Container(width: 0, height: 0, child: Text('Hello'));

  // expect_lint: unnecessary_container
  Container(
    transform: Matrix4.identity(),
    transformAlignment: Alignment.center,
  );

  // expect_lint: unnecessary_container
  Container(
    transform: Matrix4.identity(),
    transformAlignment: Alignment.center,
    child: Text('Hello'),
  );
}

void doNotUseStatefulBuilder() {
  // expect_lint: do_not_use_stateful_builder
  StatefulBuilder(builder: (_, _) => const SizedBox.shrink());
}

void doubleLeadingZero() {
  0.12345;
  // expect_lint: double_leading_zero
  .12345;
}
