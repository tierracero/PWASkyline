# Active Tasks

Active, approved, executable work only. Completed tasks move to `TASKS_ARCHIVE.md`.

---

## BUILD-DOC-001 — Canonical PWA Build Documentation

- **Status**: Planned
- **Chunks/IDs**: `PWA-*`, `APP-*`
- **Goal**: Document the exact commands and expected artifacts for development and distribution builds.
- **Completion criteria**: Verified build commands, output mapping for `DevPublic`/`DistPublic`, and service-worker validation steps.

---

## STATE-AUDIT-001 — SkylineWeb Global State Inventory

- **Status**: Planned
- **Chunks/IDs**: `SEC-*`, `STATE-*`, `API-*`, `WS-*`
- **Goal**: Classify globals in `SkylineWeb.swift` as configuration, server-owned state, derived cache, browser session data, or UI/runtime temporary state.
- **Completion criteria**: Updated architecture/state docs and open decisions resolved or narrowed.

---

## STATE-INIT-001 — Prevent Duplicate Main Configuration Sequence

- **Status**: Planned
- **Chunks/IDs**: `STATE-*`, `APP-*`, `API-*`
- **Important finding**: When opening `/` with an existing session, the main configuration sequence can run twice: `SplashScreen` calls `loadBasicConfiguration()`, routes to Work, and `WorkViewControler` calls `loadBasicConfiguration()` again.
- **Goal**: Establish one owner for the authenticated startup configuration sequence, or safely reuse its completed/in-flight state when Work loads.
- **Completion criteria**: Opening `/` with an existing session runs the main configuration sequence only once while preserving direct Work-route initialization and session recovery behavior.
