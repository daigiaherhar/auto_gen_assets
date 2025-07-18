# Watcher Setup Guide

Hướng dẫn thiết lập watcher để tự động generate assets khi có thay đổi sau khi install package từ pub.dev.

## 🚀 Quick Start

Sau khi install package `auto_gen_assets`, bạn có thể sử dụng watcher theo các cách sau:

### Cách 1: Sử dụng trực tiếp (Đơn giản nhất)

```bash
# Watch mode - tự động regenerate khi có thay đổi
dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart

# Generate một lần
dart run bin/auto_gen_assets.dart --assets-dir assets --output lib/generated/assets.dart
```

### Cách 2: Tạo scripts riêng (Khuyến nghị)

#### Bước 1: Tạo thư mục scripts
```bash
mkdir scripts
```

#### Bước 2: Tạo file `scripts/watch.sh`
```bash
#!/bin/bash
dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart
```

#### Bước 3: Tạo file `scripts/generate.sh`
```bash
#!/bin/bash
dart run bin/auto_gen_assets.dart --assets-dir assets --output lib/generated/assets.dart
```

#### Bước 4: Cấp quyền thực thi
```bash
chmod +x scripts/watch.sh scripts/generate.sh
```

#### Bước 5: Sử dụng
```bash
./scripts/watch.sh    # Bắt đầu watch
./scripts/generate.sh # Generate một lần
```

### Cách 3: Thêm vào pubspec.yaml

Thêm vào file `pubspec.yaml` của project:

```yaml
scripts:
  watch: dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart
  generate: dart run bin/auto_gen_assets.dart --assets-dir assets --output lib/generated/assets.dart
```

Sử dụng:
```bash
dart pub run watch
dart pub run generate
```

### Cách 4: Sử dụng Makefile

Tạo file `Makefile` trong project:

```makefile
.PHONY: watch generate

watch:
	dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart

generate:
	dart run bin/auto_gen_assets.dart --assets-dir assets --output lib/generated/assets.dart
```

Sử dụng:
```bash
make watch
make generate
```

## 📁 Cấu trúc thư mục đề xuất

```
your_flutter_project/
├── assets/
│   ├── images/
│   │   ├── logo.png
│   │   └── background.jpg
│   ├── animations/
│   │   └── loading.json
│   └── fonts/
│       └── roboto.ttf
├── lib/
│   ├── generated/
│   │   └── assets.dart  # File được generate tự động
│   └── main.dart
├── scripts/
│   ├── watch.sh
│   └── generate.sh
├── Makefile
└── pubspec.yaml
```

## ⚙️ Tùy chọn cấu hình

### Thay đổi thư mục assets
```bash
dart run bin/watch_assets.dart --assets-dir my_assets --output lib/generated/assets.dart
```

### Thay đổi file output
```bash
dart run bin/watch_assets.dart --assets-dir assets --output lib/core/app_assets.dart
```

### Xem help
```bash
dart run bin/watch_assets.dart --help
dart run bin/auto_gen_assets.dart --help
```

## 🔄 Workflow đề xuất

### Development
```bash
# Terminal 1: Chạy watcher
./scripts/watch.sh

# Terminal 2: Chạy Flutter app
flutter run
```

### Production
```bash
# Generate assets trước khi build
./scripts/generate.sh

# Build app
flutter build apk
```

## ❓ Troubleshooting

### Lỗi: "Assets directory not found"
```bash
# Kiểm tra thư mục assets có tồn tại không
ls assets/

# Tạo thư mục nếu chưa có
mkdir -p assets/images assets/animations assets/fonts
```

### Lỗi: "Permission denied"
```bash
# Cấp quyền thực thi cho scripts
chmod +x scripts/watch.sh scripts/generate.sh
```

### Watcher không hoạt động
```bash
# Kiểm tra watcher có đang chạy không
ps aux | grep watch_assets

# Restart watcher
pkill -f watch_assets
./scripts/watch.sh
```

## 🎯 Ví dụ thực tế

### 1. Setup project mới
```bash
# Install package
flutter pub add auto_gen_assets

# Tạo scripts
mkdir scripts
echo '#!/bin/bash' > scripts/watch.sh
echo 'dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart' >> scripts/watch.sh
chmod +x scripts/watch.sh

# Bắt đầu watch
./scripts/watch.sh
```

### 2. Thêm assets mới
```bash
# Thêm file vào assets (watcher sẽ tự động detect)
cp new_image.png assets/images/

# File sẽ tự động được thêm vào lib/generated/assets.dart
```

### 3. Sử dụng trong code
```dart
import 'generated/assets.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(Assets.images.newImage);
  }
}
```

## 📚 Tham khảo thêm

- [README.md](README.md) - Hướng dẫn sử dụng cơ bản
- [pub.dev](https://pub.dev/packages/auto_gen_assets) - Package page
- [GitHub](https://github.com/daigiaherhar/auto_gen_assets) - Source code 