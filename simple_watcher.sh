#!/bin/bash

# Simple Auto Gen Assets Watcher
# This script works in any Flutter project directory

echo "🚀 Starting auto_gen_assets watcher..."
echo "📁 Current directory: $(pwd)"
echo "⏹️  Press Ctrl+C to stop"
echo ""

# Check if we're in a Flutter project
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: pubspec.yaml not found in current directory"
    echo "   Please run this script from your Flutter project root"
    exit 1
fi

# Check if auto_gen_assets is in dependencies
if ! grep -q "auto_gen_assets:" pubspec.yaml; then
    echo "❌ Error: auto_gen_assets not found in pubspec.yaml"
    echo "   Please add it to your dependencies first:"
    echo "   dependencies:"
    echo "     auto_gen_assets: ^1.0.4"
    exit 1
fi

# Check if assets directory exists
if [ ! -d "assets" ]; then
    echo "⚠️  Warning: assets directory not found"
    echo "   Creating assets directory..."
    mkdir -p assets
fi

# Start watcher
echo "👀 Starting watcher..."
dart run auto_gen_assets --watch 