import 'dart:io';

/// Path validation and file system utilities
class PathUtils {
  /// Validate that a path is suitable for profile storage
  static Future<PathValidationResult> validateProfileStoragePath(
    String path,
  ) async {
    final issues = <String>[];
    final warnings = <String>[];

    // Check if path exists or can be created
    final dir = Directory(path);
    if (!await dir.exists()) {
      try {
        await dir.create(recursive: true);
        warnings.add('Directory will be created: $path');
      } catch (e) {
        issues.add('Cannot create directory: $e');
        return PathValidationResult(
          isValid: false,
          issues: issues,
          warnings: warnings,
        );
      }
    }

    // Check write permissions
    try {
      final testFile = File('${dir.path}/.ts4dm_write_test');
      await testFile.writeAsString('test');
      await testFile.delete();
    } catch (e) {
      issues.add('No write permission: $e');
    }

    // Check available disk space (rough estimate)
    try {
      final stat = await dir.stat();
      // TODO: Get actual available space - this is a placeholder
      if (stat.size == 0) {
        warnings.add('Could not determine available disk space');
      }
    } catch (e) {
      warnings.add('Could not check disk space: $e');
    }

    // Warn about special locations
    if (_isSpecialSystemPath(path)) {
      warnings.add(
        'Using system directory - consider choosing a user directory instead',
      );
    }

    return PathValidationResult(
      isValid: issues.isEmpty,
      issues: issues,
      warnings: warnings,
    );
  }

  /// Get available disk space for a path (placeholder implementation)
  static Future<int?> getAvailableDiskSpace(String path) async {
    try {
      // TODO: Implement actual disk space calculation
      // This is a placeholder - would need platform-specific implementation
      return 1024 * 1024 * 1024; // 1GB placeholder
    } catch (e) {
      return null;
    }
  }

  /// Normalize path separators for current platform
  static String normalizePath(String path) {
    if (Platform.isWindows) {
      return path.replaceAll('/', '\\');
    } else {
      return path.replaceAll('\\', '/');
    }
  }

  /// Check if path is a special system directory
  static bool _isSpecialSystemPath(String path) {
    final normalizedPath = path.toLowerCase();

    if (Platform.isWindows) {
      return normalizedPath.contains('\\windows\\') ||
          normalizedPath.contains('\\program files') ||
          normalizedPath.contains('\\system32');
    } else if (Platform.isMacOS) {
      return normalizedPath.startsWith('/system/') ||
          normalizedPath.startsWith('/library/') ||
          normalizedPath.startsWith('/applications/');
    }

    return false;
  }

  /// Get default storage path for user data
  static String getDefaultStoragePath() {
    final home =
        Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';

    if (Platform.isWindows) {
      return '$home\\Documents\\TS4DataManager';
    } else {
      return '$home/Documents/TS4DataManager';
    }
  }

  /// Clean up path for display (hide sensitive parts)
  static String sanitizePathForDisplay(String path) {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home != null && path.startsWith(home)) {
      return path.replaceFirst(home, '~');
    }
    return path;
  }
}

class PathValidationResult {
  final bool isValid;
  final List<String> issues;
  final List<String> warnings;

  const PathValidationResult({
    required this.isValid,
    required this.issues,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasIssues => issues.isNotEmpty;
}
