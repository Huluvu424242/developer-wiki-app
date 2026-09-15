import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const modules = <String>[
    'agent-rules/01-workflow-collaboration.md',
    'agent-rules/02-project-bootstrap.md',
    'agent-rules/03-structure.md',
    'agent-rules/03-implementation.md',
    'agent-rules/04-ux-accessibility.md',
    'agent-rules/05-security-access.md',
    'agent-rules/05-security-data.md',
    'agent-rules/05-security-tooling.md',
    'agent-rules/05-security-ci.md',
    'agent-rules/06-quality.md',
    'agent-rules/06-documentation.md',
    'agent-rules/07-release.md',
    'agent-rules/08-wiki-integration.md',
  ];

  test('AGENTS lists every mandatory module once and in order', () {
    final agents = File('AGENTS.md').readAsStringSync();
    var previous = -1;

    for (final module in modules) {
      final marker = ']($module)';
      expect(RegExp(RegExp.escape(marker)).allMatches(agents).length, 1);
      final index = agents.indexOf(marker);
      expect(index, greaterThan(previous));
      previous = index;
      expect(File(module).existsSync(), isTrue, reason: module);
    }

    final listed = RegExp(r'\]\((agent-rules/[^)]+\.md)\)')
        .allMatches(agents)
        .map((match) => match.group(1)!)
        .toList();
    expect(listed, modules);
    expect(listed.toSet().length, listed.length);
  });

  test(
    'local markdown links inside the harness resolve without entry cycles',
    () {
      final harnessFiles = <String>['AGENTS.md', ...modules];
      final linkPattern = RegExp(r'\[[^\]]+\]\(([^)]+)\)');

      for (final path in harnessFiles) {
        final file = File(path);
        final parent = file.parent;
        final text = file.readAsStringSync();
        for (final match in linkPattern.allMatches(text)) {
          final target = match.group(1)!;
          if (target.startsWith('http') || target.startsWith('#')) {
            continue;
          }
          final cleanTarget = target.split('#').first;
          final resolved = File('${parent.path}/$cleanTarget');
          expect(
            resolved.existsSync(),
            isTrue,
            reason: '$path -> $cleanTarget',
          );
          if (path != 'AGENTS.md') {
            expect(
              cleanTarget,
              isNot('../AGENTS.md'),
              reason: '$path must not require AGENTS.md recursively',
            );
          }
        }
      }
    },
  );
}
