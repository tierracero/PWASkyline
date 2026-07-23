# Swift Web App Architecture

Authoritative rules: `SWWEB-*`.

## Verified Facts

- `Sources/App/App.swift` is the `@main` app entry point.
- The app registers `./service.js` during launch.
- The app uses Swift Web `Routes`, `Page`, lifecycle hooks, `@State`, and style declarations.
- Theme switching currently selects between `MainStyle`, `SKMainStyle`, and `SKLogInStyle`.

## Rules

### SWWEB-001 — Browser UI Ownership

Browser-facing UI, routes, page controllers, snippets, and styles belong to the `App` target under `Sources/App/**`.

### SWWEB-002 — Lifecycle and Routing Preservation

Route, theme, and lifecycle changes must preserve service-worker registration, localization initialization, session-control behavior, and existing deep-link paths unless the task explicitly changes them.

### SWWEB-003 — UI State Is Not Server Authority

`@State` and DOM/browser state may drive presentation and interaction, but server-owned business data must remain synchronized through API/WebSocket contracts. UI-only state must not become hidden authoritative business state.

## Implementation Guidance

- Prefer focused snippet extraction over broad controller rewrites.
- Keep localized visible strings in the existing localization pattern.
- When touching `WorkViewControler.swift`, read only the relevant section and supporting snippet files.
- Keep CSS class changes aligned with `Sources/App/Styles/**` and static CSS resources where applicable.

