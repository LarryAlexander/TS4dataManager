/// Preflight result for importing an ExportArchive
class ImportPlan {
  final String archiveVersion;
  final List<ImportValidationError> validationErrors;
  final String targetStoragePath;
  final int estimatedSize;
  final List<ImportConflict> conflicts;
  final List<String> resolutionSteps;
  final bool canProceed;

  const ImportPlan({
    required this.archiveVersion,
    required this.validationErrors,
    required this.targetStoragePath,
    required this.estimatedSize,
    required this.conflicts,
    required this.resolutionSteps,
    required this.canProceed,
  });

  factory ImportPlan.fromJson(Map<String, dynamic> json) {
    return ImportPlan(
      archiveVersion: json['archiveVersion'] as String,
      validationErrors: (json['validationErrors'] as List)
          .map((e) => ImportValidationError.fromJson(e as Map<String, dynamic>))
          .toList(),
      targetStoragePath: json['targetStoragePath'] as String,
      estimatedSize: json['estimatedSize'] as int,
      conflicts: (json['conflicts'] as List)
          .map((e) => ImportConflict.fromJson(e as Map<String, dynamic>))
          .toList(),
      resolutionSteps: List<String>.from(json['resolutionSteps']),
      canProceed: json['canProceed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'archiveVersion': archiveVersion,
      'validationErrors': validationErrors.map((e) => e.toJson()).toList(),
      'targetStoragePath': targetStoragePath,
      'estimatedSize': estimatedSize,
      'conflicts': conflicts.map((e) => e.toJson()).toList(),
      'resolutionSteps': resolutionSteps,
      'canProceed': canProceed,
    };
  }
}

class ImportValidationError {
  final String type;
  final String message;
  final String? path;

  const ImportValidationError({
    required this.type,
    required this.message,
    this.path,
  });

  factory ImportValidationError.fromJson(Map<String, dynamic> json) {
    return ImportValidationError(
      type: json['type'] as String,
      message: json['message'] as String,
      path: json['path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'message': message, 'path': path};
  }
}

class ImportConflict {
  final String type;
  final String existingPath;
  final String incomingPath;
  final String resolution;

  const ImportConflict({
    required this.type,
    required this.existingPath,
    required this.incomingPath,
    required this.resolution,
  });

  factory ImportConflict.fromJson(Map<String, dynamic> json) {
    return ImportConflict(
      type: json['type'] as String,
      existingPath: json['existingPath'] as String,
      incomingPath: json['incomingPath'] as String,
      resolution: json['resolution'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'existingPath': existingPath,
      'incomingPath': incomingPath,
      'resolution': resolution,
    };
  }
}
