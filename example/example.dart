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
  // ignore: rexios_lints/prefer_async_await
  await Future.value().then((_) {});
}

void preferTimestamps() {
  // ignore: rexios_lints/prefer_timestamps
  DateTime.now();
  DateTime.timestamp();
}

void doNotUseRawPaths() {
  // ignore: rexios_lints/do_not_use_raw_paths
  Directory('path/to/directory');
  // ignore: rexios_lints/do_not_use_raw_paths
  File('path/to/file');
  // ignore: rexios_lints/do_not_use_raw_paths
  Link('path/to/entity');

  // ignore: rexios_lints/do_not_use_raw_paths
  Directory('path\\to\\directory');
  File('file.txt');

  // ignore: rexios_lints/do_not_use_raw_paths
  Directory(r'path\to\directory');
}

// ignore: rexios_lints/prefer_immutable_classes
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

  // ignore: rexios_lints/inline_context_lookups
  Navigator.of(context).pop();

  final accessibleNavigation = MediaQuery.maybeAccessibleNavigationOf(context);
  print(accessibleNavigation);

  // ignore: rexios_lints/inline_context_lookups
  print(MediaQuery.maybeAccessibleNavigationOf(context));
}

void unnecessaryContainer() {
  // ignore: rexios_lints/unnecessary_container
  Container();

  // ignore: rexios_lints/unnecessary_container
  Container(child: Text('Hello'));

  // ignore: rexios_lints/unnecessary_container
  Container(alignment: Alignment.center);

  // ignore: rexios_lints/unnecessary_container
  Container(padding: EdgeInsets.zero);

  // ignore: rexios_lints/unnecessary_container
  Container(color: Color(0x00000000));

  // ignore: rexios_lints/unnecessary_container
  Container(decoration: BoxDecoration());

  // ignore: rexios_lints/unnecessary_container
  Container(foregroundDecoration: BoxDecoration());

  // ignore: rexios_lints/unnecessary_container
  Container(width: 0);

  // ignore: rexios_lints/unnecessary_container
  Container(height: 0);

  // ignore: rexios_lints/unnecessary_container
  Container(constraints: BoxConstraints());

  // ignore: rexios_lints/unnecessary_container
  Container(margin: EdgeInsets.zero);

  // ignore: rexios_lints/unnecessary_container
  Container(transform: Matrix4.identity());

  // ignore: rexios_lints/unnecessary_container
  Container(clipBehavior: Clip.none);

  // ignore: rexios_lints/unnecessary_container
  Container(width: 0, height: 0);

  // ignore: rexios_lints/unnecessary_container
  Container(width: 0, height: 0, child: Text('Hello'));

  // ignore: rexios_lints/unnecessary_container
  Container(
    transform: Matrix4.identity(),
    transformAlignment: Alignment.center,
  );

  // ignore: rexios_lints/unnecessary_container
  Container(
    transform: Matrix4.identity(),
    transformAlignment: Alignment.center,
    child: Text('Hello'),
  );
}

void doNotUseStatefulBuilder() {
  // ignore: rexios_lints/do_not_use_stateful_builder
  StatefulBuilder(builder: (_, _) => const SizedBox.shrink());
}

void doubleLeadingZero() {
  0.12345;
  // ignore: rexios_lints/double_leading_zero
  .12345;
}

String? nullableString;
void notNullAssertion() {
  // ignore: rexios_lints/not_null_assertion
  nullableString!.split('');
}
