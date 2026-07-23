# Reference Projects

Guidance for using external/local reference projects while working on PWASkyline.

## Rules

- Reference projects are optional and task-specific.
- Do not copy unrelated architecture from a reference project.
- Prefer verified behavior from PWASkyline first.
- When a dependency is active source code, inspect only the relevant files.

## Known References

### Swift Web

- Package dependency: `https://github.com/swifweb/web` from `2.0.0-nightly.5`.
- Use for Swift Web element, lifecycle, router, service worker, style, and WebAssembly behavior.
- Do not duplicate framework documentation in PWASkyline docs.

### Tierra Cero Private Packages

These are active dependencies declared in `Package.swift`:

- `TCFundamentals`
- `TCFireSignal`
- `MailAPICore`
- `TCSocialCore`
- `TaecelAPICore`
- `LanguagePack`
- `WaWebAPICore`
- `SkylineDocumentationCore`

Use them only when the task depends on their types, request/response payloads, localization behavior, WebSocket contracts, or generated API models.

### Supplied AGENTS Example Archive

The bootstrap structure was adapted from the uploaded AGENTS example archive. The pattern is useful for governance shape only; project facts and rules must remain specific to PWASkyline.

