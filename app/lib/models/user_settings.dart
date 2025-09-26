/// User preferences and application settings
class UserSettings {
  final List<String> trackedAreas;
  final SnapshotSchedule snapshotSchedule;
  final int retentionPolicy;
  final AccessibilitySettings accessibility;
  final String? defaultProfileId;
  final bool telemetryEnabled; // Always false per FR-024
  final Map<String, dynamic>? customSettings;

  const UserSettings({
    this.trackedAreas = const [
      'mods',
      'saves',
      'options',
      'screenshots',
      'recordings',
    ],
    this.snapshotSchedule = SnapshotSchedule.manual,
    this.retentionPolicy = 5368709120, // 5 GB in bytes
    this.accessibility = const AccessibilitySettings(),
    this.defaultProfileId,
    this.telemetryEnabled = false, // Hard-coded per privacy requirement
    this.customSettings,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      trackedAreas: List<String>.from(
        json['trackedAreas'] ??
            ['mods', 'saves', 'options', 'screenshots', 'recordings'],
      ),
      snapshotSchedule: SnapshotSchedule.values.byName(
        json['snapshotSchedule'] as String? ?? 'manual',
      ),
      retentionPolicy: json['retentionPolicy'] as int? ?? 5368709120,
      accessibility: AccessibilitySettings.fromJson(
        json['accessibility'] as Map<String, dynamic>? ?? {},
      ),
      defaultProfileId: json['defaultProfileId'] as String?,
      telemetryEnabled: false, // Always false
      customSettings: json['customSettings'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trackedAreas': trackedAreas,
      'snapshotSchedule': snapshotSchedule.name,
      'retentionPolicy': retentionPolicy,
      'accessibility': accessibility.toJson(),
      'defaultProfileId': defaultProfileId,
      'telemetryEnabled': telemetryEnabled,
      'customSettings': customSettings,
    };
  }

  UserSettings copyWith({
    List<String>? trackedAreas,
    SnapshotSchedule? snapshotSchedule,
    int? retentionPolicy,
    AccessibilitySettings? accessibility,
    String? defaultProfileId,
    Map<String, dynamic>? customSettings,
  }) {
    return UserSettings(
      trackedAreas: trackedAreas ?? this.trackedAreas,
      snapshotSchedule: snapshotSchedule ?? this.snapshotSchedule,
      retentionPolicy: retentionPolicy ?? this.retentionPolicy,
      accessibility: accessibility ?? this.accessibility,
      defaultProfileId: defaultProfileId ?? this.defaultProfileId,
      telemetryEnabled: telemetryEnabled, // Always false
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

enum SnapshotSchedule { manual, daily, weekly }

class AccessibilitySettings {
  final double textScale;
  final bool highContrast;
  final bool keyboardNavigation;

  const AccessibilitySettings({
    this.textScale = 1.0,
    this.highContrast = false,
    this.keyboardNavigation = true,
  });

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) {
    return AccessibilitySettings(
      textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
      highContrast: json['highContrast'] as bool? ?? false,
      keyboardNavigation: json['keyboardNavigation'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'textScale': textScale,
      'highContrast': highContrast,
      'keyboardNavigation': keyboardNavigation,
    };
  }
}
