// Convert file extension to .dart to see analysis issues

// prefer_single_quotes
const string = "";

void unawaitedFutures() async {
  // unawaited_futures
  Future.delayed(Duration.zero);
}

// require_trailing_commas
void requireTrailingCommas(
    int param1, int param2, int param3, int param4, int param5) {}

class UseSuperParametersBase {
  final int param;

  UseSuperParametersBase(this.param);
}

class UseSuperParameters extends UseSuperParametersBase {
  // use_super_parameters
  UseSuperParameters(int param) : super(param);
}

void preferFinal() {
  // prefer_final_in_for_each
  for (var i in []) {
    print(i);
  }

  // prefer_final_locals
  var i = 0;
  print(i);
}
