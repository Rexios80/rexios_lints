// ignore_for_file: document_ignores

import 'dart:io';

// ignore: prefer_single_quotes
const string = "";

void unawaitedFutures() async {
  // ignore: unawaited_futures
  Future.delayed(Duration.zero);
}

void requireTrailingCommas(
    int param1,
    int param2,
    int param3,
    int param4,
    // ignore: require_trailing_commas
    int param5) {}

class UseSuperParametersBase {
  final int param;

  UseSuperParametersBase(this.param);
}

class UseSuperParameters extends UseSuperParametersBase {
  // ignore: use_super_parameters
  UseSuperParameters(int param) : super(param);
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

void preferAsyncAwait() {
  // expect_lint: prefer_async_await
  Future.value().then((_) {});
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
}
