import 'dart:io';

/// Platform-specific utilities for discovering Sims 4 installation paths
class Sims4Discovery {
  /// Discover Sims 4 user data folder automatically per FR-014
  static Future<String?> discoverSims4UserFolder() async {
    if (Platform.isMacOS) {
      return await _discoverMacOSPath();
    } else if (Platform.isWindows) {
      return await _discoverWindowsPath();
    }
    return null;
  }

  /// Get all potential Sims 4 paths to check
  static Future<List<String>> getAllPotentialPaths() async {
    final paths = <String>[];

    if (Platform.isMacOS) {
      paths.addAll(_getMacOSPaths());
    } else if (Platform.isWindows) {
      paths.addAll(_getWindowsPaths());
    }

    return paths;
  }

  /// Validate if a path contains a valid Sims 4 user directory
  static Future<bool> isValidSims4Directory(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) return false;

    // Check for characteristic Sims 4 subdirectories
    final expectedDirs = ['Mods', 'Tray', 'saves'];
    int foundDirs = 0;

    for (final expectedDir in expectedDirs) {
      final subDir = Directory('$path/$expectedDir');
      if (await subDir.exists()) {
        foundDirs++;
      }
    }

    // Consider valid if at least 2 of 3 expected directories exist
    return foundDirs >= 2;
  }

  static Future<String?> _discoverMacOSPath() async {
    final paths = _getMacOSPaths();

    for (final path in paths) {
      if (await isValidSims4Directory(path)) {
        return path;
      }
    }

    return null;
  }

  static List<String> _getMacOSPaths() {
    final home = Platform.environment['HOME'] ?? '';
    return [
      '$home/Documents/Electronic Arts/The Sims 4',
      '$home/Library/Application Support/The Sims 4',
      // iCloud Drive locations
      '$home/Library/Mobile Documents/com~apple~CloudDocs/Documents/Electronic Arts/The Sims 4',
    ];
  }

  static Future<String?> _discoverWindowsPath() async {
    final paths = _getWindowsPaths();

    for (final path in paths) {
      if (await isValidSims4Directory(path)) {
        return path;
      }
    }

    return null;
  }

  static List<String> _getWindowsPaths() {
    final userProfile = Platform.environment['USERPROFILE'] ?? '';
    final documentsPath =
        Platform.environment['DOCUMENTS'] ?? '$userProfile\\Documents';

    return [
      '$documentsPath\\Electronic Arts\\The Sims 4',
      '$userProfile\\Documents\\Electronic Arts\\The Sims 4',
      // OneDrive locations
      '$userProfile\\OneDrive\\Documents\\Electronic Arts\\The Sims 4',
      '$userProfile\\OneDrive - Personal\\Documents\\Electronic Arts\\The Sims 4',
    ];
  }
}
