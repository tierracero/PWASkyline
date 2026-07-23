# Swift Web UI Skill

Checklist for tasks involving Swift Web UI, routes, page controllers, snippets, styles, and localization.

## When to Use

Use before changing files under:

- `Sources/App/App.swift`
- `Sources/App/ViewControlers/**`
- `Sources/App/Pages/**`
- `Sources/App/Snippits/**`
- `Sources/App/Styles/**`
- UI-related `Functions`, `Extentions`, `Enums`, or `Structurs`

## Checklist

1. Read `architecture/SWIFWEB_APP_ARCHITECTURE.md`.
2. Read `SOURCE_MAP.md` for exact file ownership.
3. Identify route, page, snippet, CSS class, and asset dependencies.
4. Preserve lifecycle behavior in `App.swift` unless explicitly scoped.
5. Keep presentation state separate from server-owned data.
6. Use existing localization patterns for visible text.
7. Run focused build or browser validation when feasible.

## Common Search Targets

- Route path: `Page("work")`, `Page("login")`, `Page("hotline")`.
- Theme: `MainStyle`, `SKMainStyle`, `SKLogInStyle`, `toggalStyles`.
- View/snippet class name.
- CSS class name or asset path.

