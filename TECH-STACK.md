# Tech Stack Proposal — TS4 Data Manager

Status: Draft
Date: 2025-09-26

## Recommendation (TL;DR)

- Primary: Flutter + Dart for cross-platform desktop GUI (Windows/macOS) and app logic.
- Optional accelerator: Rust micro-helpers (via FFI) for heavy I/O/hash tasks (large directory scans, checksums) if/when profiling shows Dart becomes a bottleneck.
- Packaging: Flutter desktop builds per OS; no background services; portable mode support where possible.

## Why Flutter/Dart

- Cross-platform desktop parity with a single codebase; great UI toolkit and theming.
- Strong developer velocity and hot-reload during early prototyping.
- Mature ecosystem for desktop (file pickers, windowing, accessibility) and flexible for custom widgets like diff/history views.
- Easy to build installers/bundles for Windows (.exe/.msix) and macOS (.app/.dmg).

## Where Dart shines vs where it may strain

- Great for: UI, state management, orchestration, non-blocking I/O, moderate hashing, progress/cancellation UX.
- Potential strain: Extremely large file trees with deep hashing or many small file I/Os; CPU-intensive checksumming over tens of GB.

## Rust helper (optional, phased)

- Scope: A tiny CLI/FFI library for parallelized hashing and directory traversal with backpressure.
- Trigger: Only add after a profiler shows hot spots (e.g., initial scan on huge Mods/Recordings directories).
- Benefits: Predictable performance and low memory overhead; keeps Flutter responsive.
- Cost: Build pipeline complexity (cargo + FFI bindings per OS); extra testing.

## Data storage & formats (non-binding at this stage)

- App config: Human-readable (e.g., JSON/TOML) stored per-profile location.
- Manifests: JSON with checksums (xxHash/Blake3) for speed; compression for export archives (zip/zstd). Choice is deferrable until prototype tests.
- Logging: Text files in profile storage; included in manual diagnostic export.

## Integration & OS specifics

- Path discovery: Platform-specific user directories (Windows: Documents\Electronic Arts\The Sims 4; macOS: ~/Documents/Electronic Arts/The Sims 4), plus manual override.
- Coexistence: No file locks; watch for external changes (polling + file events); no in-kernel hooks needed.
- Accessibility: Flutter supports scaling, contrast, keyboard navigation; we’ll enforce minimums in UI.

## Alternatives considered (brief)

- Tauri (Rust + web UI): Excellent footprint and native speed; more moving parts for a small team; UI dev slower without Flutter’s widgets/hot reload.
- Electron (JS/TS + Node): Ubiquitous but heavier runtime; we don’t need web stack depth here.
- Native Swift/C# desktop: Best native feel but doubles codebases; slower feature parity across Windows/macOS.

## Minimal project layout (initial)

- app/
  - lib/
    - main.dart (entry)
    - ui/ (screens, widgets: history, profiles, export/import)
    - state/ (providers/blocs)
    - services/
      - tracking_service.dart
      - snapshot_service.dart
      - profile_service.dart
      - export_import_service.dart
      - diagnostics_service.dart
    - models/ (TrackedArea, Snapshot, ChangeRecord, Profile, Instance, ExportArchive, ImportPlan, UserSettings)
    - platform/ (fs utils, path discovery)
  - test/ (unit tests for services/models)
- tools/ (optional future rust helper)

## Success criteria for the stack

- Build both Windows and macOS from the same codebase.
- UI stays responsive during long scans/exports (progress, cancel, rollback).
- No background telemetry; manual diagnostics only.
- Easy packaging and updates.

## Next steps

- Approve Flutter/Dart primary stack.
- I’ll scaffold the Flutter project structure and stub models/services per spec (no heavy logic yet), then add a tiny smoke test.
