#!/bin/bash

# Auto Gen Assets Generator Script
# Usage: ./scripts/generate.sh [options]

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
      echo "Auto Gen Assets Generator"
      echo ""
      echo "Usage: ./scripts/generate.sh [options]"
      echo ""
      echo "Options:"
      echo "  -a, --assets-dir <path>    Set assets directory path (default: example/assets)"
      echo "  -o, --output <path>        Set output file path (default: example/lib/generated/assets.dart)"

      echo "  -h, --help                 Show this help message"
      echo ""
      echo "Examples:"
      echo "  ./scripts/generate.sh"
      echo "  ./scripts/generate.sh --assets-dir assets --output lib/generated/assets.dart"

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

echo "🔄 Generating assets..."
echo "📁 Assets directory: $ASSETS_DIR"
echo "📄 Output file: $OUTPUT_FILE"

echo ""

# Run the generator
dart run bin/auto_gen_assets.dart \
  --assets-dir "$ASSETS_DIR" \
  --output "$OUTPUT_FILE" 