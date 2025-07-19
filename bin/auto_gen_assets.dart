import 'dart:io';
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main(List<String> args) {
  // Parse command line arguments
  String? assetsDirectory;
  String? outputFile;
  
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--assets-dir':
      case '-a':
        if (i + 1 < args.length) {
          assetsDirectory = args[i + 1];
          i++; // Skip next argument
        }
        break;
      case '--output':
      case '-o':
        if (i + 1 < args.length) {
          outputFile = args[i + 1];
          i++; // Skip next argument
        }
        break;
      case '--help':
      case '-h':
        _printHelp();
        return;
    }
  }

  final generator = AssetGenerator(
    assetsDirectory: assetsDirectory ?? 'assets',
    outputFile: outputFile ?? 'lib/generated/assets.dart',
  );
  
  final success = generator.generate();
  exit(success ? 0 : 1);
}

void _printHelp() {
  print('''
Auto Gen Assets - Generate strongly-typed asset references

Usage: dart run bin/auto_gen_assets.dart [options]

Options:
  -a, --assets-dir <path>    Set assets directory path (default: assets)
  -o, --output <path>        Set output file path (default: lib/generated/assets.dart)
  -h, --help                 Show this help message

Examples:
  dart run bin/auto_gen_assets.dart
  dart run bin/auto_gen_assets.dart --assets-dir example/assets
  dart run bin/auto_gen_assets.dart --assets-dir example/assets --output example/lib/generated/assets.dart
''');
}
