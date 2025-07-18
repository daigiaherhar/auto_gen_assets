import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main() {
  group('AssetGenerator', () {
    late Directory tempDir;
    late Directory assetsDir;
    late File outputFile;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('auto_gen_assets_test');
      assetsDir = Directory('${tempDir.path}/assets');
      outputFile = File('${tempDir.path}/generated/assets.dart');
    });

    tearDown(() {
      tempDir.deleteSync(recursive: true);
    });

    test('should generate assets file when assets directory exists', () {
      // Create test assets structure
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/images').createSync();
      Directory('${assetsDir.path}/fonts').createSync();
      
      File('${assetsDir.path}/images/logo.png').createSync();
      File('${assetsDir.path}/images/background.jpg').createSync();
      File('${assetsDir.path}/fonts/roboto.ttf').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
      );

      final result = generator.generate();

      expect(result, isTrue);
      expect(outputFile.existsSync(), isTrue);

      final content = outputFile.readAsStringSync();
      expect(content, contains('class Assets'));
      expect(content, contains('class Images'));
      expect(content, contains('class Fonts'));
      expect(content, contains("final String logo = 'assets/images/logo.png'"));
      expect(content, contains("final String background = 'assets/images/background.jpg'"));
      expect(content, contains("final String roboto = 'assets/fonts/roboto.ttf'"));
    });

    test('should return false when assets directory does not exist', () {
      final generator = AssetGenerator(
        assetsDirectory: '${tempDir.path}/nonexistent',
        outputFile: outputFile.path,
      );

      final result = generator.generate();

      expect(result, isFalse);
      expect(outputFile.existsSync(), isFalse);
    });

    test('should ignore hidden files when ignoreHiddenFiles is true', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/images').createSync();
      
      File('${assetsDir.path}/images/logo.png').createSync();
      File('${assetsDir.path}/images/.hidden.png').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
        ignoreHiddenFiles: true,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains("final String logo = 'assets/images/logo.png'"));
      expect(content, isNot(contains('.hidden')));
    });

    test('should include hidden files when ignoreHiddenFiles is false', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/images').createSync();
      
      File('${assetsDir.path}/images/logo.png').createSync();
      File('${assetsDir.path}/images/.hidden.png').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
        ignoreHiddenFiles: false,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains("final String logo = 'assets/images/logo.png'"));
      expect(content, contains("final String hidden = 'assets/images/.hidden.png'"));
    });

    test('should ignore env files when ignoreEnvFiles is true', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/config').createSync();
      
      File('${assetsDir.path}/config/settings.env').createSync();
      File('${assetsDir.path}/config/app.env.local').createSync();
      File('${assetsDir.path}/config/normal.json').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
        ignoreEnvFiles: true,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains("final String normal = 'assets/config/normal.json'"));
      expect(content, isNot(contains('.env')));
    });

    test('should convert file names to camelCase correctly', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/images').createSync();
      
      File('${assetsDir.path}/images/my_file_name.png').createSync();
      File('${assetsDir.path}/images/user-avatar.jpg').createSync();
      File('${assetsDir.path}/images/logo.png').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains("final String myFileName = 'assets/images/my_file_name.png'"));
      expect(content, contains("final String userAvatar = 'assets/images/user-avatar.jpg'"));
      expect(content, contains("final String logo = 'assets/images/logo.png'"));
    });

    test('should convert folder names to PascalCase correctly', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/my_images').createSync();
      Directory('${assetsDir.path}/user_avatars').createSync();
      
      File('${assetsDir.path}/my_images/logo.png').createSync();
      File('${assetsDir.path}/user_avatars/profile.jpg').createSync();

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains('static const MyImages myImages = MyImages();'));
      expect(content, contains('static const UserAvatars userAvatars = UserAvatars();'));
      expect(content, contains('class MyImages'));
      expect(content, contains('class UserAvatars'));
    });

    test('should skip files not in subfolders', () {
      assetsDir.createSync(recursive: true);
      Directory('${assetsDir.path}/images').createSync();
      
      File('${assetsDir.path}/logo.png').createSync(); // Should be skipped
      File('${assetsDir.path}/images/logo.png').createSync(); // Should be included

      final generator = AssetGenerator(
        assetsDirectory: assetsDir.path,
        outputFile: outputFile.path,
      );

      final result = generator.generate();

      expect(result, isTrue);
      
      final content = outputFile.readAsStringSync();
      expect(content, contains("final String logo = 'assets/images/logo.png'"));
      expect(content, isNot(contains('assets/logo.png')));
    });
  });

  group('AssetItem', () {
    test('should create AssetItem with correct properties', () {
      const item = AssetItem(name: 'testName', path: 'test/path.png');
      
      expect(item.name, equals('testName'));
      expect(item.path, equals('test/path.png'));
    });

    test('should have correct equality', () {
      const item1 = AssetItem(name: 'test', path: 'path.png');
      const item2 = AssetItem(name: 'test', path: 'path.png');
      const item3 = AssetItem(name: 'different', path: 'path.png');
      
      expect(item1, equals(item2));
      expect(item1, isNot(equals(item3)));
    });

    test('should have correct toString', () {
      const item = AssetItem(name: 'testName', path: 'test/path.png');
      
      expect(item.toString(), equals('AssetItem(name: testName, path: test/path.png)'));
    });
  });
}
