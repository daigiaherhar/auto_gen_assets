#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'package:watcher/watcher.dart';
import 'package:auto_gen_assets/auto_gen_assets.dart';

/// Watcher script for auto-generating assets when files change
///
/// Usage: dart run bin/watch_assets.dart
///
/// This script watches the assets directory and automatically
/// regenerates the assets.dart file whenever files are added,
/// modified, or removed.

void main(List<String> args) async {
  print('🚀 Starting auto_gen_assets watcher...');
  print('📁 Watching assets directory for changes...');
  print('⏹️  Press Ctrl+C to stop\n');

  // Parse command line arguments
  String? outputFile;
  String? assetsDirectory;

  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--output':
      case '-o':
        if (i + 1 < args.length) {
          outputFile = args[i + 1];
          i++; // Skip next argument
        }
        break;
      case '--assets-dir':
      case '-a':
        if (i + 1 < args.length) {
          assetsDirectory = args[i + 1];
          i++; // Skip next argument
        }
        break;
      case '--help':
      case '-h':
        _printHelp();
        return;
    }
  }

  final finalAssetsDirectory = assetsDirectory ?? 'assets';
  final finalOutputFile = outputFile ?? 'lib/generated/assets.dart';

  // Check if assets directory exists
  if (!Directory(finalAssetsDirectory).existsSync()) {
    print('❌ Assets directory not found: $finalAssetsDirectory');
    print('   Please create the assets directory first.');
    print('   Or specify a different directory with --assets-dir option.');
    exit(1);
  }

  // Generate assets initially
  await _generateAssets(finalAssetsDirectory, finalOutputFile);

  // Set up watcher
  final watcher = DirectoryWatcher(finalAssetsDirectory);

  // Debounce timer to avoid multiple rapid generations
  Timer? debounceTimer;

  watcher.events.listen((event) {
    // Cancel previous timer if it exists
    debounceTimer?.cancel();

    // Set new timer to debounce rapid changes
    debounceTimer = Timer(const Duration(milliseconds: 500), () {
      print('🔄 Detected change: ${event.path}');
      _generateAssets(finalAssetsDirectory, finalOutputFile);
    });
  });

  // // Handle graceful shutdown
  // ProcessSignal.sigint.watch().listen((_) {
  //   print('\n👋 Stopping watcher...');
  //   exit(0);
  // });

  // Keep the script running forever

  await Completer<void>().future;
}

void _printHelp() {
  print('''
Auto Gen Assets Watcher - Watch assets directory and auto-generate

Usage: dart run bin/watch_assets.dart [options]

Options:
  -a, --assets-dir <path>    Set assets directory path (default: assets)
  -o, --output <path>        Set output file path (default: lib/generated/assets.dart)
  -h, --help                 Show this help message

Examples:
  dart run bin/watch_assets.dart
  dart run bin/watch_assets.dart --assets-dir example/assets
  dart run bin/watch_assets.dart --assets-dir example/assets --output example/lib/generated/assets.dart
''');
}

/// Generates assets using the AssetGenerator
Future<void> _generateAssets(String assetsDirectory, String outputFile) async {
  try {
    final generator = AssetGenerator(
      assetsDirectory: assetsDirectory,
      outputFile: outputFile,
      ignoreHiddenFiles: true,
      ignoreEnvFiles: true,
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
