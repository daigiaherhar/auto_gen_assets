# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2024-07-18

### Added
- Background watcher functionality with `watcher.sh` and `watcher.bat` scripts
- Integrated watcher directly into package (no need for separate bin files)
- Background process management with start/stop/status/logs commands
- Cross-platform support (macOS/Linux/Windows)

### Fixed
- Watcher now works after installing package from pub.dev
- Improved command line interface with `--watch` flag
- Better error handling and process management

## [1.0.2] - 2024-07-18

### Added
- Shell scripts for easy asset generation and watching
- Improved watcher with better error handling and graceful shutdown
- Command line options for customizing assets directory and output path
- Enhanced AssetGenerator with proper folder structure organization

### Fixed
- Fixed watcher to keep running indefinitely
- Removed invalid executables section from pubspec.yaml
- Improved generated code structure with proper class organization

## [1.0.1] 

### Added
- Asset watcher functionality for automatic regeneration
- Makefile with convenient commands (watch, generate, clean, test)
- GitHub repository integration
- Improved documentation and examples

### Fixed
- Moved watcher dependency to main dependencies section
- Updated package metadata for pub.dev publishing

## [1.0.0] 

### Added
- Initial release of auto_gen_assets package
- `AssetGenerator` class for automatically generating Dart code from assets directory
- Support for folder-based asset organization
- Configurable file filtering (hidden files, env files)
- Automatic naming conversion (camelCase for properties, PascalCase for classes)
- Comprehensive test coverage
- Example project demonstrating usage
- Detailed documentation and README

### Features
- Scans assets directory recursively
- Groups assets by folder structure
- Generates strongly-typed asset references
- Handles hidden files (files starting with '.')
- Handles environment files (files containing '.env')
- Converts file names to camelCase for property names
- Converts folder names to PascalCase for class names
- Configurable output file location
- Configurable assets directory path

### Technical Details
- Clean Architecture implementation
- Proper error handling
- Immutable data structures
- Comprehensive unit tests
- Flutter package structure
- Command-line tool support