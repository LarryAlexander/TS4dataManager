/// Portable artifact produced during profile export
class ExportArchive {
  final String version;
  final String profileLabel;
  final String instanceId;
  final ExportManifest manifest;
  final int size;
  final String archivePath;
  final String? instructionsPath;

  const ExportArchive({
    required this.version,
    required this.profileLabel,
    required this.instanceId,
    required this.manifest,
    required this.size,
    required this.archivePath,
    this.instructionsPath,
  });

  factory ExportArchive.fromJson(Map<String, dynamic> json) {
    return ExportArchive(
      version: json['version'] as String,
      profileLabel: json['profileLabel'] as String,
      instanceId: json['instanceId'] as String,
      manifest: ExportManifest.fromJson(
        json['manifest'] as Map<String, dynamic>,
      ),
      size: json['size'] as int,
      archivePath: json['archivePath'] as String,
      instructionsPath: json['instructionsPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'profileLabel': profileLabel,
      'instanceId': instanceId,
      'manifest': manifest.toJson(),
      'size': size,
      'archivePath': archivePath,
      'instructionsPath': instructionsPath,
    };
  }
}

/// Manifest containing checksums, paths, and areas for export validation
class ExportManifest {
  final Map<String, String> checksums; // path -> checksum
  final List<String> areas;
  final DateTime exportedAt;
  final String exporterVersion;

  const ExportManifest({
    required this.checksums,
    required this.areas,
    required this.exportedAt,
    required this.exporterVersion,
  });

  factory ExportManifest.fromJson(Map<String, dynamic> json) {
    return ExportManifest(
      checksums: Map<String, String>.from(json['checksums']),
      areas: List<String>.from(json['areas']),
      exportedAt: DateTime.parse(json['exportedAt'] as String),
      exporterVersion: json['exporterVersion'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checksums': checksums,
      'areas': areas,
      'exportedAt': exportedAt.toIso8601String(),
      'exporterVersion': exporterVersion,
    };
  }
}
