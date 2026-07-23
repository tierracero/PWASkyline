# App and Platform Boundaries

Authoritative rules: `APP-*`.

## Verified Facts

- PWASkyline is a Swift Web / WebAssembly PWA project.
- The Swift Package defines executable targets `App` and `Service`.
- The package declares macOS 11 tooling support.
- Browser/PWA output is represented by `DevPublic` and `DistPublic` trees.

## Rules

### APP-001 — Swift Web PWA Identity

PWASkyline is a browser/PWA application built with Swift Web and WebAssembly. Do not treat it as a native iOS/macOS UIKit application unless a future architecture decision explicitly adds that target.

### APP-002 — Target Separation

The `App` target owns browser UI and client runtime behavior. The `Service` target owns service-worker manifest/runtime behavior and copied resource packaging.

### APP-003 — Verified vs Planned State

Stable docs must clearly distinguish verified codebase facts from planned refactors, future migrations, and unresolved decisions.

## Legacy Naming Boundary

Legacy directory spellings are part of the current source layout. Preserve them during normal tasks until `DEC-LEGACY-NAMES-001` is resolved.

