/// Complete state representation suitable for export/import
class Instance {
  final String id;
  final DateTime createdAt;
  final int sizeEstimate;
  final List<String> areasIncluded;
  final String? manifestRef;
  final Map<String, dynamic>? metadata;

  const Instance({
    required this.id,
    required this.createdAt,
    required this.sizeEstimate,
    required this.areasIncluded,
    this.manifestRef,
    this.metadata,
  });

  factory Instance.fromJson(Map<String, dynamic> json) {
    return Instance(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sizeEstimate: json['sizeEstimate'] as int,
      areasIncluded: List<String>.from(json['areasIncluded']),
      manifestRef: json['manifestRef'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'sizeEstimate': sizeEstimate,
      'areasIncluded': areasIncluded,
      'manifestRef': manifestRef,
      'metadata': metadata,
    };
  }
}
