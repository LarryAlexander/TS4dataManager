# Tasks — Project Foundation (Profiles & Instances)

Status: Draft
Feature Branch: 001-specify-let-s
Spec: ./spec.md
Plan: ./plan.md

## Phase 0: Foundations

- UX: Onboarding to locate Sims 4 folder (auto + manual)
- Tracking: initial scan skeleton for Mods/Saves/Screenshots/Recordings
- Snapshots: create/restore stubs; retention budget setting (default 5 GB)
- Settings: accessibility, tracked areas, schedule, retention
- Coexistence: verify no locks with Vortex/MO2/CurseForge/Generic
- Diagnostics: local issue draft export
- Privacy: ensure no telemetry by default; only manual diagnostic export is present

## Phase 1: Profiles & Instances

- Data: Define Profile, Instance, ExportArchive, ImportPlan models
- UI: Profile selector (labels only), create profile, choose storage path
- UX: Progress + ETA pattern; cancel + rollback infrastructure
- Export: Build portable archive with manifest and instructions
- Import: Validate archive → preflight plan → guided placement → activate
- Safety: Path validation, disk space estimation, conflict detection/resolution
- Edge: Relink missing profile storage, handle duplicate labels
- Options: include Options (game settings/config) in instance capture and manifests

## Validation

- Happy paths: create/select profile; export/import round-trip
- Edge: low disk, permission denied, corrupted archive, moved storage path
- Regression: coexistence with mod managers; snapshot history unaffected
