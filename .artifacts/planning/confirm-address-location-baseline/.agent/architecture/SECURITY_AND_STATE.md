# Security and State Boundaries

Authoritative rules: `SEC-*`, `STATE-*`.

## Verified Facts

- `SkylineWeb.swift` contains many global variables for tokens, API mode, account/user/store context, caches, and feature configuration.
- `App.swift` reads and writes browser `localStorage` for language and session-control behavior.
- API and WebSocket flows use tokens and account/user context.
- `ErrorReportingControler` owns diagnostic persistence, retry scheduling, account-scoped delivery, and 60-day invalidation.
- Diagnostic records are stored in the `PWASkylineDiagnostics` IndexedDB database through the `PWASkylineErrorStore` JavaScript bridge.

## Rules

### SEC-001 — Explicit Token and Permission Handling

Token, session, permission, auth, and user/account identity changes require explicit review. Do not log or expose sensitive values.

### SEC-002 — Browser Storage Safety

Browser storage must be treated as user-controlled, stale, and security-sensitive. Validate and expire stored values before using them as authority.

### STATE-001 — Global Cache Ownership

Global caches must have clear ownership, refresh, and invalidation rules. Do not add new global mutable state unless it has an explicit owner and lifecycle.

## Implementation Guidance

- Avoid printing tokens, JWTs, session keys, or private URLs.
- On logout/session reset changes, audit all affected global caches and localStorage keys.
- Treat fiscal/payment/account state as server-owned unless a specific API contract says otherwise.
- Prefer targeted cache updates keyed by stable server identifiers.
- Persist only redacted token references; use the current live token only while constructing the reporting request.
- Redact sensitive JSON keys and URL query values before persistence, omit large encoded/file content, and cap request, response, and error text sizes.
- Pending diagnostics are delivered only under the username/account captured at occurrence time. Cross-account records remain pending until the matching session returns or the record expires.
- IndexedDB is diagnostic state, not server authority. Failed storage writes use a bounded in-memory fallback and do not block the originating user operation.
