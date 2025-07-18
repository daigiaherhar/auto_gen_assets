# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-01-XX

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
