import 'dart:io';
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main(List<String> args) async {
  // Parse command line arguments
  String? assetsDirectory;
  String? outputFile;
  String? className;
  bool isWatchMode = false;
  
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--watch':
      case '-w':
        isWatchMode = true;
        break;
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
      case '--class-name':
      case '-c':
        if (i + 1 < args.length) {
          className = args[i + 1];
          i++; // Skip next argument
        }
        break;
      case '--help':
      case '-h':
        _printHelp();
        return;
    }
  }

  if (isWatchMode) {
    // Watch mode
    final watcher = AssetWatcher(
      assetsDirectory: assetsDirectory ?? 'assets',
      outputFile: outputFile ?? 'lib/generated/assets.dart',
      className: className ?? 'Assets',
    );
    await watcher.watch();
  } else {
    // Generate once mode
    final generator = AssetGenerator(
      assetsDirectory: assetsDirectory ?? 'assets',
      outputFile: outputFile ?? 'lib/generated/assets.dart',
      className: className ?? 'Assets',
    );
    
    final success = generator.generate();
    exit(success ? 0 : 1);
  }
}

void _printHelp() {
  print('''
Auto Gen Assets - Generate strongly-typed asset references

Usage: dart run auto_gen_assets [options]

Options:
  -w, --watch              Watch mode - auto-regenerate on changes
  -a, --assets-dir <path>  Set assets directory path (default: assets)
  -o, --output <path>      Set output file path (default: lib/generated/assets.dart)
  -c, --class-name <name>  Set the main class name (default: Assets)
  -h, --help               Show this help message

Examples:
  # Generate once
  dart run auto_gen_assets
  
  # Watch mode
  dart run auto_gen_assets --watch
  
  # Custom paths
  dart run auto_gen_assets --watch --assets-dir assets --output lib/generated/assets.dart
  
  # Custom class name
  dart run auto_gen_assets --watch --class-name AppAssets
''');
}
