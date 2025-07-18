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

  const assetsDirectory = 'assets';
  const outputFile = 'lib/generated/assets.dart';

  // Check if assets directory exists
  if (!Directory(assetsDirectory).existsSync()) {
    print('❌ Assets directory not found: $assetsDirectory');
    print('   Please create the assets directory first.');
    exit(1);
  }

  // Generate assets initially
  await _generateAssets(assetsDirectory, outputFile);

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
      _generateAssets(assetsDirectory, outputFile);
    });
  });

  // Handle graceful shutdown
  ProcessSignal.sigint.watch().listen((_) {
    print('\n👋 Stopping watcher...');
    // watcher.();
    exit(0);
  });

  // Keep the script running
  await Future.delayed(Duration.zero);
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
