#!/bin/bash

# Auto Gen Assets Watcher Script
# Copy this file to your project root and run: chmod +x watch.sh && ./watch.sh

echo "🚀 Starting auto_gen_assets watcher..."
echo "📁 Watching assets directory for changes..."
echo "⏹️  Press Ctrl+C to stop"
echo ""

# Check if assets directory exists
if [ ! -d "assets" ]; then
    echo "❌ Assets directory not found!"
    echo "   Please create an 'assets' directory first."
    echo "   Example: mkdir -p assets/images assets/animations assets/fonts"
    exit 1
fi

# Create generated directory if it doesn't exist
mkdir -p lib/generated

# Start the watcher
dart run bin/watch_assets.dart --assets-dir assets --output lib/generated/assets.dart 