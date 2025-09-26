/// A single detected change in tracked areas
class ChangeRecord {
  final String id;
  final DateTime timestamp;
  final String area;
  final String filePath;
  final ChangeType changeType;
  final String? previousStateRef;
  final String? newStateRef;
  final ChangeSource source;
  final Map<String, dynamic>? metadata;

  const ChangeRecord({
    required this.id,
    required this.timestamp,
    required this.area,
    required this.filePath,
    required this.changeType,
    this.previousStateRef,
    this.newStateRef,
    required this.source,
    this.metadata,
  });

  factory ChangeRecord.fromJson(Map<String, dynamic> json) {
    return ChangeRecord(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      area: json['area'] as String,
      filePath: json['filePath'] as String,
      changeType: ChangeType.values.byName(json['changeType'] as String),
      previousStateRef: json['previousStateRef'] as String?,
      newStateRef: json['newStateRef'] as String?,
      source: ChangeSource.values.byName(json['source'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'area': area,
      'filePath': filePath,
      'changeType': changeType.name,
      'previousStateRef': previousStateRef,
      'newStateRef': newStateRef,
      'source': source.name,
      'metadata': metadata,
    };
  }
}

enum ChangeType { add, modify, delete, move }

enum ChangeSource { user, app, external }
