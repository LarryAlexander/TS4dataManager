/// Represents a Sims 4 directory group for tracking
class TrackedArea {
  final String id;
  final String name;
  final String rootPath;
  final List<String> includedPaths;
  final List<String> excludedPaths;
  final bool isEnabled;

  const TrackedArea({
    required this.id,
    required this.name,
    required this.rootPath,
    this.includedPaths = const [],
    this.excludedPaths = const [],
    this.isEnabled = true,
  });

  factory TrackedArea.fromJson(Map<String, dynamic> json) {
    return TrackedArea(
      id: json['id'] as String,
      name: json['name'] as String,
      rootPath: json['rootPath'] as String,
      includedPaths: List<String>.from(json['includedPaths'] ?? []),
      excludedPaths: List<String>.from(json['excludedPaths'] ?? []),
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rootPath': rootPath,
      'includedPaths': includedPaths,
      'excludedPaths': excludedPaths,
      'isEnabled': isEnabled,
    };
  }
}
