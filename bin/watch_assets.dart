import 'dart:async';
import 'dart:io';
import 'package:watcher/watcher.dart';
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main() async {
  print('📡 Watching assets...');
  final generator = AssetGenerator();

  generator.generate();

  final watcher = DirectoryWatcher(generator.assetsDirectory);
  Timer? debounceTimer;

  watcher.events.listen((event) {
    debounceTimer?.cancel();
    debounceTimer = Timer(Duration(milliseconds: 300), () {
      print('🟡 Change detected: ${event.path}');
      final success = generator.generate();
      if (success) {
        print('✅ Regenerated at ${DateTime.now()}');
      }
    });
  });
}
