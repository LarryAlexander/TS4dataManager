/// Top-level container for a user's setup with hidden internal ID
class Profile {
  final String id; // Internal ID, hidden from UI
  final String label; // User-facing label
  final String storagePath; // User-chosen storage location
  final DateTime createdAt;
  final String? activeInstanceId;
  final int retentionBudget; // Storage budget in bytes
  final bool isActive;

  const Profile({
    required this.id,
    required this.label,
    required this.storagePath,
    required this.createdAt,
    this.activeInstanceId,
    this.retentionBudget = 5 * 1024 * 1024 * 1024, // 5 GB default
    this.isActive = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      label: json['label'] as String,
      storagePath: json['storagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      activeInstanceId: json['activeInstanceId'] as String?,
      retentionBudget:
          json['retentionBudget'] as int? ?? 5 * 1024 * 1024 * 1024,
      isActive: json['isActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'storagePath': storagePath,
      'createdAt': createdAt.toIso8601String(),
      'activeInstanceId': activeInstanceId,
      'retentionBudget': retentionBudget,
      'isActive': isActive,
    };
  }

  Profile copyWith({
    String? label,
    String? storagePath,
    String? activeInstanceId,
    int? retentionBudget,
    bool? isActive,
  }) {
    return Profile(
      id: id,
      label: label ?? this.label,
      storagePath: storagePath ?? this.storagePath,
      createdAt: createdAt,
      activeInstanceId: activeInstanceId ?? this.activeInstanceId,
      retentionBudget: retentionBudget ?? this.retentionBudget,
      isActive: isActive ?? this.isActive,
    );
  }
}
