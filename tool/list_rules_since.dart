import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';

/// List all rules since this version (inclusive)
final since = Version.parse('3.3.0');
const url =
    'https://raw.githubusercontent.com/dart-lang/site-www/main/src/_data/linter_rules.json';

void main() async {
  final response = await http.get(Uri.parse(url));
  final json = (jsonDecode(response.body) as List)
      .cast<Map>()
      .map((e) => e.cast<String, dynamic>())
      .map(Rule.fromJson);
  final rules = json
      .where((e) => e.sinceDartSdk >= since)
      // Do not show removed rules
      .where((e) => e.state != 'removed')
      // Only show rules that will not be included automatically
      .where((e) => e.sets.intersection({'recommended', 'flutter'}).isEmpty);
  print('${rules.length} rules since $since:');
  final groups = rules.groupSetsBy((e) => e.sinceDartSdk);
  for (final entry in groups.entries.sortedBy<VersionRange>((e) => e.key)) {
    print('${entry.key}:');
    for (final rule in entry.value) {
      print('  - ${rule.name}: ${rule.description}');
    }
  }
}

class Rule {
  final String name;
  final String description;
  final String state;
  final Set<String> sets;
  final Version sinceDartSdk;

  Rule({
    required this.name,
    required this.description,
    required this.state,
    required this.sets,
    required this.sinceDartSdk,
  });

  factory Rule.fromJson(Map<String, dynamic> json) => Rule(
        name: json['name'],
        description: json['description'],
        state: json['state'],
        sets: Set<String>.from(json['sets']),
        sinceDartSdk: Version.parse(json['sinceDartSdk']),
      );
}
