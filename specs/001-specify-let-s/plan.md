# Implementation Plan — Project Foundation (Profiles & Instances)

Status: Draft
Feature Branch: 001-specify-let-s
Spec: ./spec.md

## Constitution Gate Check (v1.0.0)

- User-centric UX: Profile labels, clear progress, cancel/rollback ✓
- Non-destructive operations: pre-change backups, export/import validation, safe restore ✓
- Git-style versioning: history, snapshots, revert ✓
- Mod manager coexistence: read-only detection, no locks ✓
- Safe file management: budget cap, preflight checks, path validation ✓

## Scope (Phase 0 → Phase 1)

- Phase 0 (Foundations)

  - Baseline folder discovery (Windows/macOS)
  - Change tracking pipeline skeleton (Mods, Saves, Options, Screenshots, Recordings)
  - Snapshot CRUD + retention budget skeleton
  - Profile model + selector UI skeleton (labels only)
  - Storage location chooser with validation
  - Diagnostic export to local issue draft

- Phase 1 (Profiles & Instances)
  - Profile create/select/delete (soft-delete only)
  - Instance capture (current full state) and size estimation
  - ExportArchive build with manifest + instructions
  - Import flow: validate → plan → place → activate
  - Long-running operation UX: progress, ETA, cancel, rollback

## Contracts

- Profile

  - Input: label, storagePath
  - Output: profileId
  - Errors: invalid path, no permission, insufficient space

- Export

  - Input: active profileId, areas selection
  - Output: ExportArchive path, manifest summary
  - Errors: low disk, permission, path conflicts, interrupted op

- Import
  - Input: archive path, target storagePath
  - Output: new profileId, activated profile
  - Errors: invalid archive, version mismatch, insufficient space, conflicts

## Edge Handling

- Path unavailability → relink flow, never auto-delete
- Disk pressure → estimate upfront, guardrails
- Archive corruption → fail-safe, leave prior state intact

## Milestones

1. Data model stubs (Profile, Instance, ExportArchive)
2. Profile selector UI (labels only), storage chooser
3. Instance capture + size estimate
4. Export archive and instructions generation
5. Import validation and guided placement
6. Progress/cancel/rollback framework

## Acceptance Alignment

- Maps to FR-026, FR-028–FR-031 and existing FR-001..023,025,027

## Risks & Decisions

- FR-024 privacy posture: Telemetry OFF by default; no analytics; manual diagnostic export only.
