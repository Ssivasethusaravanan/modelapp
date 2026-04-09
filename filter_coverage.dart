import 'dart:io';

void main() {
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    print('Error: coverage/lcov.info not found.');
    return;
  }

  final lines = lcovFile.readAsLinesSync();
  final filteredLines = <String>[];
  bool skipFile = false;

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      // Exclude generated files
      if (line.contains('.g.dart') || line.contains('.freezed.dart')) {
        skipFile = true;
      } else {
        skipFile = false;
      }
    }

    if (!skipFile) {
      filteredLines.add(line);
    }

    if (line == 'end_of_record') {
      skipFile = false;
    }
  }

  final outputFile = File('coverage/filtered_lcov.info');
  outputFile.writeAsStringSync(filteredLines.join('\n'));
  print('Successfully created coverage/filtered_lcov.info');
}
