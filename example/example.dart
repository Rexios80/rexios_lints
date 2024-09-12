// ignore_for_file: document_ignores

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

void dateTime() {
  DateTime.now();
}

void preferAsyncAwait() {
  // expect_lint: prefer_async_await
  Future.value().then((_) {});
}
