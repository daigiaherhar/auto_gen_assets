import 'dart:io';

class AssetGenerator {
  final String assetsDirectory;
  final String outputFile;
  final String className;
  final bool ignoreHiddenFiles;
  final bool ignoreEnvFiles;

  AssetGenerator({
    this.assetsDirectory = 'assets',
    this.outputFile = 'lib/generated/assets.dart',
    this.className = 'Assets',
    this.ignoreHiddenFiles = true,
    this.ignoreEnvFiles = true,
  });

  bool generate() {
    final assetsDir = Directory(assetsDirectory);
    final output = File(outputFile);
    final buffer = StringBuffer();

    buffer.writeln('/// This file is auto-generated. DO NOT EDIT.');
    buffer.writeln('class $className {');
    buffer.writeln('  const $className();\n');

    if (!assetsDir.existsSync()) {
      stderr.writeln('❌ Directory not found: $assetsDirectory');
      return false;
    }

    final grouped = <String, List<_AssetItem>>{};
    final allFiles = assetsDir.listSync(recursive: true).whereType<File>();

    for (var file in allFiles) {
      final path = file.path.replaceAll('\\', '/');
      final name = file.uri.pathSegments.last;

      if ((ignoreHiddenFiles && name.startsWith('.')) ||
          (ignoreEnvFiles &&
              (name.endsWith('.env') || name.contains('.env.')))) {
        continue;
      }

      final parts = path.split('/');
      if (parts.length < 3) continue;

      final folder = parts[1];
      grouped
          .putIfAbsent(folder, () => [])
          .add(
            _AssetItem(
              name: _toCamelCase(parts.last.split('.').first),
              path: path,
            ),
          );
    }

    grouped.forEach((folder, items) {
      final className = _toPascalCase(folder);
      buffer.writeln('  static const $className $folder = $className();');
    });

    buffer.writeln('}\n');

    grouped.forEach((folder, items) {
      final className = _toPascalCase(folder);
      buffer.writeln('class $className {');
      buffer.writeln('  const $className();');
      for (final item in items) {
        buffer.writeln("  final String ${item.name} = '${item.path}';");
      }
      buffer.writeln('}\n');
    });

    output.createSync(recursive: true);
    output.writeAsStringSync(buffer.toString());
    return true;
  }
}

class _AssetItem {
  final String name;
  final String path;
  _AssetItem({required this.name, required this.path});
}

String _toPascalCase(String text) => text
    .split(RegExp(r'[_\-\s]+'))
    .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
    .join();

String _toCamelCase(String text) {
  final parts = text.split(RegExp(r'[_\-\s]+'));
  if (parts.isEmpty) return '';
  final first = parts.first.toLowerCase();
  final rest = parts
      .skip(1)
      .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
      .join();
  return '$first$rest';
}
