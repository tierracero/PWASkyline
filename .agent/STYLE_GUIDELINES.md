# Style Guidelines

Concise documentation and code style rules for PWASkyline.

## Documentation Style

- Use concise Markdown.
- Keep one authority per rule; link instead of duplicating.
- Label status clearly: **Verified**, **Planned**, **Deferred**, **Active**, **Resolved**.
- Do not create filler-heavy placeholder docs.
- Keep transient evidence in `.artifacts/**`.

## Swift Code Style

- Follow existing project conventions before introducing new patterns.
- Preserve current directory naming when editing nearby code, even where spelling is legacy (`ViewControlers`, `Snippits`, `Structurs`, `Extentions`).
- Use UpperCamelCase for types and Swift filenames; use lowerCamelCase for properties, methods, parameters, local variables, and enum cases.
- Keep wire-format naming exactly as required by external APIs.
- Prefer small extensions or focused helper functions over large rewrites.
- Avoid changing public API payload names unless the backend contract is included in scope.

## Swift Web UI Style

- Prefer Swift Web declarative elements and existing project snippets.
- Keep UI state in `@State` only when it is presentation or browser-runtime state.
- Do not allow UI-only state to become the independent authority for server-owned business data.
- Keep localized text using existing `LString`/`Localization` patterns when user-facing.

### Active Visual Hierarchy

- Popup title bars use surface contrast and spacing for separation; do not add a persistent accent-colored divider beneath the title.
- Single-item surfaces use neutral structural borders. Reserve orange for meaningful emphasis instead of outlining the entire content surface.
- Shared single-item instructional copy and field labels use a minimum `15px` font size.
- UI buttons communicate affordance through fill, typography, and interaction states rather than a persistent border. Preserve a visible keyboard-focus outline.
- Content-sized popups should derive their height from their contents and remain capped by the viewport. Use fixed heights only when the interaction requires a stable canvas or internal scrolling region.

## API and WebSocket Style

- Keep endpoint files focused by API domain and action.
- Preserve existing endpoint naming patterns such as `CustOrder+Action.swift`, `Fiscal+Action.swift`, and `WS+Message.swift`.
- Explicitly document callback/error behavior when adding new request helpers.
- Treat WebSocket handlers as event processors; keep ordering and idempotency in mind.

## Asset and Output Style

- Source assets live under `Sources/Service/**` or `WebSources/**` depending on ownership.
- `DevPublic/**` and `DistPublic/**` are generated or deployable outputs; edit only when the task explicitly asks.
- Keep service worker and manifest paths aligned with copied resources.

## Attribution

- Do not add coding-agent attribution to source headers, docs, or commit messages.
