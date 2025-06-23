import 'package:rexios_lints/custom_lint/do_not_use_raw_paths.dart';
import 'package:test/test.dart';

void main() {
  test('create path segments', () {
    expect(
      UsePathJoinFix.createSegmentsString("'path/to/entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoinFix.createSegmentsString(r"'path\\to\\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoinFix.createSegmentsString(r"r'path\to\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoinFix.createSegmentsString('r"path/to/entity"'),
      "'path', 'to', 'entity'",
    );
  });
}
