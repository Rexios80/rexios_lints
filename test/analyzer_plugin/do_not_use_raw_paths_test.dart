import 'package:rexios_lints/analyzer_plugin/do_not_use_raw_paths.dart';
import 'package:test/test.dart';

void main() {
  test('create path segments', () {
    expect(
      UsePathJoin.createSegmentsString("'path/to/entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString(r"'path\\to\\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString(r"r'path\to\entity'"),
      "'path', 'to', 'entity'",
    );

    expect(
      UsePathJoin.createSegmentsString('r"path/to/entity"'),
      "'path', 'to', 'entity'",
    );
  });
}
