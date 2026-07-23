# Open Decisions

Central unresolved architecture and product decision index for PWASkyline.

## Record Format

Each active record contains:

- **Decision ID**
- **Status**: Active / Resolved
- **Owning architecture chunk**
- **Question**
- **Why it matters**
- **Blocking**: Blocking / Non-blocking
- **Related tasks**

## Active Decisions

---

### DEC-BUILD-001

- **Status**: Active
- **Owning chunk**: `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md`
- **Question**: What is the canonical build command sequence for producing `DevPublic` and `DistPublic` outputs?
- **Why it matters**: Prevents accidental partial or stale PWA output updates.
- **Blocking**: Non-blocking for docs bootstrap; blocking for output regeneration tasks.
- **Related tasks**: `DOC-001`, future build-doc task.

---

### DEC-API-AUTH-001

- **Status**: Active
- **Owning chunk**: `architecture/SECURITY_AND_STATE.md`
- **Question**: Which tokens belong in memory only, which may be stored in browser localStorage, and how are they invalidated?
- **Why it matters**: Affects account security, session recovery, and stale-login behavior.
- **Blocking**: Blocking for session/auth refactors.
- **Related tasks**: Future auth/session hardening task.

---

### DEC-WS-IDEMPOTENCY-001

- **Status**: Active
- **Owning chunk**: `architecture/WEBSOCKET_AND_REALTIME.md`
- **Question**: Which WebSocket messages can be replayed or duplicated, and what idempotency keys should each handler use?
- **Why it matters**: Prevents duplicate chat messages, duplicate task approvals, stale status updates, and repeated async job UI changes.
- **Blocking**: Blocking for broad WebSocket reliability changes.
- **Related tasks**: Future WebSocket audit task.

---

### DEC-GLOBAL-STATE-001

- **Status**: Active
- **Owning chunk**: `architecture/SECURITY_AND_STATE.md`
- **Question**: Which globals in `SkylineWeb.swift` are authoritative state, derived cache, configuration, or temporary UI/runtime state?
- **Why it matters**: Guides safe cache invalidation, logout behavior, and refactoring.
- **Blocking**: Blocking for large state-management refactors.
- **Related tasks**: Future state inventory task.

---

### DEC-LEGACY-NAMES-001

- **Status**: Active
- **Owning chunk**: `architecture/APP_AND_PLATFORM.md`
- **Question**: Should legacy directory/type spellings such as `ViewControlers`, `Snippits`, `Structurs`, and `Extentions` be preserved permanently or migrated in a dedicated compatibility task?
- **Why it matters**: Prevents accidental broad file renames and import/path breakage.
- **Blocking**: Non-blocking; preserve existing names until resolved.
- **Related tasks**: Future source-organization task.
