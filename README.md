# auto_gen_assets

A Flutter package for automatically generating strongly-typed asset references from your assets directory.

## Features

- 🔄 **Automatic Generation**: Scans your assets directory and generates Dart code
- 📁 **Folder Organization**: Groups assets by folder structure
- 🎯 **Type Safety**: Provides strongly-typed asset references
- ⚙️ **Configurable**: Customize output location and file filtering
- 🚀 **Easy to Use**: Simple API with sensible defaults

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  auto_gen_assets: ^1.0.4
```

## Usage

### Basic Usage

1. **Create an assets directory structure** in your Flutter project:

```
assets/
├── images/
│   ├── logo.png
│   ├── background.jpg
│   └── icons/
│       ├── home.png
│       └── settings.png
├── animations/
│   ├── loading.json
│   └── success.json
└── fonts/
    ├── roboto.ttf
    └── opensans.ttf
```

2. **Run the generator**:

```bash
# Generate once
dart run auto_gen_assets

# Or with watch mode (auto-regenerate on changes)
dart run auto_gen_assets --watch
```

3. **Use the generated assets** in your Flutter code:

```dart
import 'generated/assets.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Assets.images.logo),
        Image.asset(Assets.images.icons.home),
        Lottie.asset(Assets.animations.loading),
      ],
    );
  }
}
```

### Using Watcher (Auto-regenerate on changes)

After installing the package, you can use the watcher functionality:

#### Option 1: Simple Watcher (Recommended)

**For macOS/Linux** - Copy `simple_watcher.sh` to your project:
```bash
# Copy the simple watcher script
curl -o simple_watcher.sh https://raw.githubusercontent.com/daigiaherhar/auto_gen_assets/main/simple_watcher.sh
chmod +x simple_watcher.sh

# Start watcher (foreground)
./simple_watcher.sh
```

**For Windows** - Copy `simple_watcher.bat` to your project:
```batch
# Copy the simple watcher script
curl -o simple_watcher.bat https://raw.githubusercontent.com/daigiaherhar/auto_gen_assets/main/simple_watcher.bat

# Start watcher (foreground)
simple_watcher.bat
```

#### Option 2: Background Watcher

**For macOS/Linux** - Copy `watcher.sh` to your project:
```bash
# Copy the background watcher script
curl -o watcher.sh https://raw.githubusercontent.com/daigiaherhar/auto_gen_assets/main/watcher.sh
chmod +x watcher.sh

# Start watcher in background
./watcher.sh start

# Check status
./watcher.sh status

# View logs
./watcher.sh logs

# Stop watcher
./watcher.sh stop
```

**For Windows** - Copy `watcher.bat` to your project:
```batch
# Copy the watcher script
curl -o watcher.bat https://raw.githubusercontent.com/daigiaherhar/auto_gen_assets/main/watcher.bat

# Start watcher in background
watcher.bat start

# Check status
watcher.bat status

# View logs
watcher.bat logs

# Stop watcher
watcher.bat stop
```

#### Option 2: Foreground Watcher

**For macOS/Linux** - Create `watch.sh`:
```bash
#!/bin/bash
dart run auto_gen_assets --watch
```

**For Windows** - Create `watch.bat`:
```batch
dart run auto_gen_assets --watch
```

Then use:
```bash
# macOS/Linux
chmod +x watch.sh && ./watch.sh

# Windows
watch.bat
```

#### Option 3: Direct commands
```bash
# Watch for changes and auto-regenerate
dart run auto_gen_assets --watch

# Generate once
dart run auto_gen_assets
```

#### What the watcher does:
- ✅ **Monitors** your `assets/` directory for changes
- 🔄 **Auto-regenerates** `lib/generated/assets.dart` when files are added/removed/modified
- ⏱️ **Debounces** rapid changes to avoid excessive regeneration
- 🛑 **Graceful shutdown** with Ctrl+C (foreground) or stop command (background)

#### Example workflow with background watcher:
```bash
# Start watcher in background
./watcher.sh start

# Add new assets (watcher runs in background)
cp new_image.png assets/images/
# Watcher automatically updates lib/generated/assets.dart

# Check if watcher is running
./watcher.sh status

# View watcher logs
./watcher.sh logs

# Stop watcher when done
./watcher.sh stop

## Troubleshooting

### Common Issues

**❌ "Could not find file `bin/watch_assets.dart`"**
- **Solution**: Use the new CLI command: `dart run auto_gen_assets --watch`
- **Or**: Use the simple watcher script: `./simple_watcher.sh`

**❌ "auto_gen_assets not found in pubspec.yaml"**
- **Solution**: Add to your `pubspec.yaml`:
```yaml
dependencies:
  auto_gen_assets: ^1.0.5
```

**❌ "Assets directory not found"**
- **Solution**: Create the assets directory: `mkdir assets`

**❌ Watcher not detecting changes**
- **Solution**: Make sure you're running from project root with `pubspec.yaml`
- **Try**: Restart watcher with `./simple_watcher.sh`

### Quick Fix Commands

```bash
# 1. Add package to pubspec.yaml
echo "  auto_gen_assets: ^1.0.5" >> pubspec.yaml

# 2. Get dependencies
dart pub get

# 3. Create assets directory
mkdir -p assets

# 4. Start watcher
dart run auto_gen_assets --watch
```

### Programmatic Usage

You can also use the generator programmatically:

```dart
import 'package:auto_gen_assets/auto_gen_assets.dart';

void main() {
  const generator = AssetGenerator(
    assetsDirectory: 'assets',
    outputFile: 'lib/generated/assets.dart',
    ignoreHiddenFiles: true,
    ignoreEnvFiles: true,
  );
  
  final success = generator.generate();
  if (success) {
    print('Assets generated successfully!');
  }
}
```

### Configuration Options

The `AssetGenerator` class accepts the following configuration options:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `assetsDirectory` | `String` | `'assets'` | The directory containing assets to scan |
| `outputFile` | `String` | `'lib/generated/assets.dart'` | The output file path |
| `ignoreHiddenFiles` | `bool` | `true` | Whether to ignore hidden files (starting with '.') |
| `ignoreEnvFiles` | `bool` | `true` | Whether to ignore environment files (containing '.env') |

## Generated Code Structure

The generator creates a structured Dart file with the following organization:

```dart
/// This file is automatically generated. DO NOT EDIT.
/// Generated by auto_gen_assets package.

class Assets {
  Assets._();

  static const Images images = Images();
  static const Animations animations = Animations();
  static const Fonts fonts = Fonts();
}

class Images {
  const Images();
  final String logo = 'assets/images/logo.png';
  final String background = 'assets/images/background.jpg';
}

class Icons {
  const Icons();
  final String home = 'assets/images/icons/home.png';
  final String settings = 'assets/images/icons/settings.png';
}

class Animations {
  const Animations();
  final String loading = 'assets/animations/loading.json';
  final String success = 'assets/animations/success.json';
}

class Fonts {
  const Fonts();
  final String roboto = 'assets/fonts/roboto.ttf';
  final String opensans = 'assets/fonts/opensans.ttf';
}
```

## Naming Conventions

- **Folder names** are converted to **PascalCase** for class names
- **File names** are converted to **camelCase** for property names
- **Underscores and hyphens** in names are properly handled

Examples:
- `my_folder` → `MyFolder` (class name)
- `my_file_name.png` → `myFileName` (property name)
- `user-avatar.jpg` → `userAvatar` (property name)

## Integration with Build Process

### Using Watcher (Recommended)

The package includes a built-in watcher that automatically regenerates assets when files change:

```bash
# Start watching for changes
make watch

# Or directly with dart
dart run bin/watch_assets.dart
```

The watcher will:
- ✅ Monitor the `assets` directory for any changes
- 🔄 Automatically regenerate `assets.dart` when files are added/modified/removed
- ⏱️ Debounce rapid changes to avoid excessive regeneration
- 🛑 Gracefully handle Ctrl+C to stop watching

### Using build_runner

Add to your `pubspec.yaml`:

```yaml
dev_dependencies:
  build_runner: ^2.4.7
  build: ^2.4.1
```

Create a build script:

```dart
// build.yaml
targets:
  $default:
    builders:
      auto_gen_assets|asset_builder:
        enabled: true
        options:
          assets_directory: assets
          output_file: lib/generated/assets.dart
```

### Using Makefile

The project includes a `Makefile` with convenient commands:

```bash
# Generate assets once
make generate

# Watch for changes (auto-regenerate)
make watch

# Clean generated files
make clean

# Run tests
make test

# Show all available commands
make help
```

## Examples

### Complete Example Project

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'generated/assets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Gen Assets Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Gen Assets Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.images.logo,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              'Assets loaded successfully!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes and version history.
