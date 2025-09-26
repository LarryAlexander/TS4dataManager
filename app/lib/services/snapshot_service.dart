import 'dart:io';
import '../models/snapshot.dart';
import '../models/tracked_area.dart';

/// Service for creating and managing snapshots
class SnapshotService {
  static final SnapshotService _instance = SnapshotService._internal();
  factory SnapshotService() => _instance;
  SnapshotService._internal();

  final List<Snapshot> _snapshots = [];

  /// Get all snapshots, newest first
  List<Snapshot> get snapshots => List.unmodifiable(
    _snapshots..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
  );

  /// Create snapshot of current state for a profile
  Future<Snapshot> createSnapshot({
    required String label,
    required List<TrackedArea> areas,
    Map<String, dynamic>? metadata,
    String? description,
  }) async {
    // Calculate size and prepare areas list
    final sizeEstimate = await _estimateSize(areas);
    final areasCovered = areas.map((area) => area.name).toList();

    // Create snapshot with current state
    final snapshot = Snapshot(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      label: label,
      description: description,
      sizeEstimate: sizeEstimate,
      areasCovered: areasCovered,
      metadata: metadata,
    );

    _snapshots.add(snapshot);

    return snapshot;
  }

  /// Restore to a specific snapshot
  Future<void> restoreToSnapshot(String snapshotId) async {
    if (!_snapshots.any((s) => s.id == snapshotId)) {
      throw ArgumentError('Snapshot not found: $snapshotId');
    }

    // TODO: Implement restore logic with backup of current state
    throw UnimplementedError('Restore functionality pending implementation');
  }

  /// Delete a snapshot (soft delete with recovery option)
  Future<void> deleteSnapshot(String snapshotId) async {
    _snapshots.removeWhere((s) => s.id == snapshotId);
    // TODO: Move to recoverable staging area per FR-008
  }

  /// Estimate size of areas for snapshot planning
  Future<int> _estimateSize(List<TrackedArea> areas) async {
    int totalSize = 0;
    for (final area in areas) {
      try {
        final dir = Directory(area.rootPath);
        if (await dir.exists()) {
          await for (final entity in dir.list(recursive: true)) {
            if (entity is File) {
              final stat = await entity.stat();
              totalSize += stat.size;
            }
          }
        }
      } catch (e) {
        // Skip inaccessible directories
        continue;
      }
    }
    return totalSize;
  }
}
