.PHONY: help generate watch clean test

# Default target
help:
	@echo "Available commands:"
	@echo "  make generate  - Generate assets once"
	@echo "  make watch     - Watch assets directory and auto-generate on changes"
	@echo "  make clean     - Clean generated files"
	@echo "  make test      - Run tests"

# Generate assets once
generate:
	@echo "🔄 Generating assets..."
	dart run bin/auto_gen_assets.dart

# Watch assets directory for changes
watch:
	@echo "🚀 Starting asset watcher..."
	dart run bin/watch_assets.dart

# Clean generated files
clean:
	@echo "🧹 Cleaning generated files..."
	@rm -f lib/generated/assets.dart
	@echo "✅ Cleaned!"

# Run tests
test:
	@echo "🧪 Running tests..."
	dart test

# Install dependencies
get:
	@echo "📦 Getting dependencies..."
	dart pub get

# Format code
format:
	@echo "🎨 Formatting code..."
	dart format .

# Analyze code
analyze:
	@echo "🔍 Analyzing code..."
	dart analyze 