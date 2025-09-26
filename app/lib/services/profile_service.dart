import 'dart:io';
import '../models/profile.dart';
import '../models/user_settings.dart';

/// Service for managing user profiles with hidden internal IDs
class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final List<Profile> _profiles = [];
  Profile? _activeProfile;
  final UserSettings _settings = const UserSettings();

  /// Initialize with default profile if none exist
  Future<void> initialize() async {
    await _loadProfiles();
    if (_profiles.isEmpty) {
      await _createDefaultProfile();
    }
    _activeProfile = _profiles.firstWhere(
      (p) => p.isActive,
      orElse: () => _profiles.first,
    );
  }

  /// Create a new profile with user-chosen storage path
  Future<Profile> createProfile({
    required String label,
    required String storagePath,
  }) async {
    // Validate storage path per plan requirements
    await _validateStoragePath(storagePath);

    final profile = Profile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      label: label,
      storagePath: storagePath,
      createdAt: DateTime.now(),
      retentionBudget: _settings.retentionPolicy,
    );

    _profiles.add(profile);
    await _saveProfiles();
    return profile;
  }

  /// Get all profiles (UI shows labels only, IDs hidden per FR-028)
  List<Profile> get profiles => List.unmodifiable(_profiles);

  /// Get active profile
  Profile? get activeProfile => _activeProfile;

  /// Switch to a different profile
  Future<void> activateProfile(String profileId) async {
    final profile = _profiles.firstWhere(
      (p) => p.id == profileId,
      orElse: () => throw ArgumentError('Profile not found: $profileId'),
    );

    // Deactivate current profile
    if (_activeProfile != null) {
      final index = _profiles.indexWhere((p) => p.id == _activeProfile!.id);
      if (index != -1) {
        _profiles[index] = _activeProfile!.copyWith(isActive: false);
      }
    }

    // Activate new profile
    final index = _profiles.indexWhere((p) => p.id == profileId);
    _profiles[index] = profile.copyWith(isActive: true);
    _activeProfile = _profiles[index];

    await _saveProfiles();
  }

  /// Soft delete a profile (recoverable per FR-008)
  Future<void> deleteProfile(String profileId) async {
    if (_profiles.length <= 1) {
      throw StateError('Cannot delete the last profile');
    }

    _profiles.removeWhere((p) => p.id == profileId);

    if (_activeProfile?.id == profileId) {
      _activeProfile = _profiles.first;
      await activateProfile(_activeProfile!.id);
    }

    await _saveProfiles();
    // TODO: Move profile data to recoverable staging area
  }

  /// Relink profile with new storage path if original becomes unavailable
  Future<void> relinkProfile(String profileId, String newStoragePath) async {
    await _validateStoragePath(newStoragePath);

    final index = _profiles.indexWhere((p) => p.id == profileId);
    if (index == -1) throw ArgumentError('Profile not found: $profileId');

    _profiles[index] = _profiles[index].copyWith(storagePath: newStoragePath);
    await _saveProfiles();
  }

  /// Validate storage path has proper permissions and space
  Future<void> _validateStoragePath(String path) async {
    final dir = Directory(path);

    // Check if directory exists or can be created
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
      } catch (e) {
        throw ArgumentError('Cannot create directory: $path. Error: $e');
      }
    }

    // Check write permissions
    try {
      final testFile = File('$path/.ts4dm_test');
      await testFile.writeAsString('test');
      await testFile.delete();
    } catch (e) {
      throw ArgumentError('No write permission to: $path');
    }

    // TODO: Check available disk space
  }

  Future<void> _createDefaultProfile() async {
    // Use default Documents/TS4DataManager for initial profile
    final homeDir =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    final defaultPath = '$homeDir/Documents/TS4DataManager';

    await createProfile(label: 'Default', storagePath: defaultPath);
  }

  Future<void> _loadProfiles() async {
    // TODO: Implement profile persistence
    // For now, profiles exist only in memory
  }

  Future<void> _saveProfiles() async {
    // TODO: Implement profile persistence to user-chosen locations
    // Each profile stores its metadata in its own storagePath
  }
}
