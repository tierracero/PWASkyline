# Swift Web App Architecture

Authoritative rules: `SWWEB-*`.

## Verified Facts

- `Sources/App/App.swift` is the `@main` app entry point.
- The app registers `./service.js` during launch.
- The app uses Swift Web `Routes`, `Page`, lifecycle hooks, `@State`, and style declarations.
- Theme switching currently selects between `MainStyle`, `SKMainStyle`, and `SKLogInStyle`.
- Browser speech recognition is centralized in `SpeechRecognitionManager`; it retains the JavaScript callback for the active session and routes transcripts to one weak `SpeechRecognitionTarget`.
- `WorkViewControler` owns one authenticated-session `TCSpeechRecognitionFloatingButton` and shuts it down when the work shell leaves the DOM.

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
- Speech-enabled inputs opt in by registering as the active `SpeechRecognitionTarget`. Final transcripts may update that target, but speech infrastructure must not submit or persist user content automatically.
- Keep browser speech bridge calls and callback ownership inside `SpeechRecognitionManager`; keep floating-control DOM and theme rules inside `TCSpeechRecognitionFloatingButton` rather than dispersing them through page controllers.
