#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';
import 'package:watcher/watcher.dart';
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main(List<String> args) async {
  final watcher = DirectoryWatcher('assets');
  final generator = AssetGenerator();

  print('📁 Watching assets directory...');
  generator.generate();

  Timer? debounce;
  watcher.events.listen((event) {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 300), () {
      print('🟡 Detected change: ${event.path}');
      final success = generator.generate();
      if (success) {
        final ts = DateTime.now().toLocal().toString().split('.')[0];
        print('✅ Regenerated at $ts');
      }
    });
  });

  // Keep alive
  await Completer<void>().future;
}
