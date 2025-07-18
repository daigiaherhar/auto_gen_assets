#!/bin/bash

# Auto Gen Assets Watcher Script
# Usage: ./scripts/watch.sh [options]

set -e

# Default values
ASSETS_DIR="example/assets"
OUTPUT_FILE="example/lib/generated/assets.dart"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --assets-dir|-a)
      ASSETS_DIR="$2"
      shift 2
      ;;
    --output|-o)
      OUTPUT_FILE="$2"
      shift 2
      ;;

    --help|-h)
      echo "Auto Gen Assets Watcher"
      echo ""
      echo "Usage: ./scripts/watch.sh [options]"
      echo ""
      echo "Options:"
      echo "  -a, --assets-dir <path>    Set assets directory path (default: example/assets)"
      echo "  -o, --output <path>        Set output file path (default: example/lib/generated/assets.dart)"

      echo "  -h, --help                 Show this help message"
      echo ""
      echo "Examples:"
      echo "  ./scripts/watch.sh"
      echo "  ./scripts/watch.sh --assets-dir assets --output lib/generated/assets.dart"

      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check if assets directory exists
if [ ! -d "$ASSETS_DIR" ]; then
  echo "❌ Assets directory not found: $ASSETS_DIR"
  echo "   Please create the assets directory first."
  exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$(dirname "$OUTPUT_FILE")"

echo "🚀 Starting auto_gen_assets watcher..."
echo "📁 Assets directory: $ASSETS_DIR"
echo "📄 Output file: $OUTPUT_FILE"

echo "⏹️  Press Ctrl+C to stop"
echo ""

# Run the watcher
dart run bin/watch_assets.dart \
  --assets-dir "$ASSETS_DIR" \
  --output "$OUTPUT_FILE" 