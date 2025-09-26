import 'dart:io';
import 'package:crypto/crypto.dart';

/// Safe file operations with backup and recovery
class FileOperations {
  /// Copy file with progress callback
  static Future<void> copyFileWithProgress(
    String sourcePath,
    String destinationPath,
    Function(double progress)? onProgress,
  ) async {
    final sourceFile = File(sourcePath);
    final destFile = File(destinationPath);

    // Ensure destination directory exists
    await destFile.parent.create(recursive: true);

    final sourceStream = sourceFile.openRead();
    final destSink = destFile.openWrite();

    final totalSize = await sourceFile.length();
    int copiedBytes = 0;

    await for (final chunk in sourceStream) {
      destSink.add(chunk);
      copiedBytes += chunk.length;
      onProgress?.call(copiedBytes / totalSize);
    }

    await destSink.close();
  }

  /// Create backup of file before modification
  static Future<String> createBackup(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('File does not exist: $filePath');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final backupPath = '$filePath.backup.$timestamp';

    await file.copy(backupPath);
    return backupPath;
  }

  /// Restore from backup
  static Future<void> restoreFromBackup(
    String backupPath,
    String originalPath,
  ) async {
    final backupFile = File(backupPath);
    if (!await backupFile.exists()) {
      throw ArgumentError('Backup does not exist: $backupPath');
    }

    await backupFile.copy(originalPath);
  }

  /// Non-destructive delete (move to recoverable area)
  static Future<String> softDelete(
    String filePath,
    String recoveryAreaPath,
  ) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('File does not exist: $filePath');
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = filePath.split(Platform.pathSeparator).last;
    final recoveryPath =
        '$recoveryAreaPath${Platform.pathSeparator}deleted_$timestamp$fileName';

    final recoveryDir = Directory(recoveryAreaPath);
    await recoveryDir.create(recursive: true);

    await file.rename(recoveryPath);
    return recoveryPath;
  }

  /// Calculate file checksum for integrity verification
  static Future<String> calculateChecksum(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw ArgumentError('File does not exist: $filePath');
    }

    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify file integrity using checksum
  static Future<bool> verifyIntegrity(
    String filePath,
    String expectedChecksum,
  ) async {
    try {
      final actualChecksum = await calculateChecksum(filePath);
      return actualChecksum == expectedChecksum;
    } catch (e) {
      return false;
    }
  }

  /// Get directory size recursively
  static Future<int> getDirectorySize(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) return 0;

    int totalSize = 0;

    try {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }
    } catch (e) {
      // Handle permission errors gracefully
    }

    return totalSize;
  }

  /// Check if file is locked by another process
  static Future<bool> isFileLocked(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return false;

      // Try to open for write - if locked, this will fail
      final randomAccessFile = await file.open(mode: FileMode.append);
      await randomAccessFile.close();
      return false;
    } catch (e) {
      return true;
    }
  }

  /// Wait for file to become unlocked (with timeout)
  static Future<bool> waitForUnlock(
    String filePath, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < timeout) {
      if (!await isFileLocked(filePath)) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    return false;
  }
}
