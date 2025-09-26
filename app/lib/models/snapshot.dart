/// A labeled, restorable point-in-time state for tracked areas
class Snapshot {
  final String id;
  final DateTime createdAt;
  final String label;
  final String? description;
  final int sizeEstimate;
  final List<String> areasCovered;
  final Map<String, dynamic>? metadata;

  const Snapshot({
    required this.id,
    required this.createdAt,
    required this.label,
    this.description,
    required this.sizeEstimate,
    required this.areasCovered,
    this.metadata,
  });

  factory Snapshot.fromJson(Map<String, dynamic> json) {
    return Snapshot(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      label: json['label'] as String,
      description: json['description'] as String?,
      sizeEstimate: json['sizeEstimate'] as int,
      areasCovered: List<String>.from(json['areasCovered']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'label': label,
      'description': description,
      'sizeEstimate': sizeEstimate,
      'areasCovered': areasCovered,
      'metadata': metadata,
    };
  }
}
