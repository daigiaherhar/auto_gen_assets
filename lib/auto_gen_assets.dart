library auto_gen_assets;

export 'src/auto_gen_assets.dart';
export 'src/asset_generator.dart';
export 'src/models/asset_item.dart';

// Add watcher functionality
import 'dart:io';
import 'dart:async';
import 'package:watcher/watcher.dart';
import 'src/asset_generator.dart';

/// Watcher class for auto-generating assets when files change
class AssetWatcher {
  final String assetsDirectory;
  final String outputFile;
  final String className;
  final bool ignoreHiddenFiles;
  final bool ignoreEnvFiles;

  AssetWatcher({
    this.assetsDirectory = 'assets',
    this.outputFile = 'lib/generated/assets.dart',
    this.className = 'Assets',
    this.ignoreHiddenFiles = true,
    this.ignoreEnvFiles = true,
  });

  /// Start watching the assets directory for changes
  Future<void> watch() async {
    print('🚀 Starting auto_gen_assets watcher...');
    print('📁 Watching assets directory for changes...');
    print('⏹️  Press Ctrl+C to stop\n');

    // Check if assets directory exists
    if (!Directory(assetsDirectory).existsSync()) {
      print('❌ Assets directory not found: $assetsDirectory');
      print('   Please create the assets directory first.');
      exit(1);
    }

    // Generate assets initially
    await _generateAssets();

    // Set up watcher
    final watcher = DirectoryWatcher(assetsDirectory);
    
    // Debounce timer to avoid multiple rapid generations
    Timer? debounceTimer;
    
    watcher.events.listen((event) {
      // Cancel previous timer if it exists
      debounceTimer?.cancel();
      
      // Set new timer to debounce rapid changes
      debounceTimer = Timer(const Duration(milliseconds: 500), () {
        print('🔄 Detected change: ${event.path}');
        _generateAssets();
      });
    });

    // Handle graceful shutdown
    ProcessSignal.sigint.watch().listen((_) {
      print('\n👋 Stopping watcher...');
      exit(0);
    });

    // Keep the script running
    await Future.delayed(Duration.zero);
    
    // Keep the script alive indefinitely
    await Future.delayed(Duration(days: 365));
  }

  /// Generate assets using the AssetGenerator
  Future<void> _generateAssets() async {
    try {
      final generator = AssetGenerator(
        assetsDirectory: assetsDirectory,
        outputFile: outputFile,
        className: className,
        ignoreHiddenFiles: ignoreHiddenFiles,
        ignoreEnvFiles: ignoreEnvFiles,
      );

      final success = generator.generate();
      
      if (success) {
        final timestamp = DateTime.now().toLocal().toString().split('.')[0];
        print('✅ Assets regenerated at $timestamp');
      } else {
        print('❌ Failed to generate assets');
      }
    } catch (e) {
      print('❌ Error generating assets: $e');
    }
  }
}

/// Command line interface for the watcher
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
