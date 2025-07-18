/// Represents an individual asset item with its name and path.
class AssetItem {
  /// Creates an [AssetItem] with the given [name] and [path].
  const AssetItem({
    required this.name,
    required this.path,
  });

  /// The camelCase name of the asset for use in code.
  final String name;

  /// The relative path to the asset file.
  final String path;

  @override
  String toString() => 'AssetItem(name: $name, path: $path)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssetItem && other.name == name && other.path == path;
  }

  @override
  int get hashCode => name.hashCode ^ path.hashCode;
} 