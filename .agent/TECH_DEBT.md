# Technical Debt

Known technical debt and caution areas for PWASkyline.

## Legacy Naming

- Several directories and types use legacy spellings: `ViewControlers`, `Snippits`, `Structurs`, `Extentions`, and related class names.
- Preserve these names during normal work to avoid broad path churn.
- Any migration must be a dedicated task with build verification.

## Large Controller Files

- `WorkViewControler.swift` is very large and owns many UI/runtime responsibilities.
- Refactor only through small, tested extraction tasks.

## Global Runtime State

- `SkylineWeb.swift` contains many global variables and caches.
- Refactors require explicit ownership and invalidation rules.

## Generated/Public Output Risk

- `DevPublic` and `DistPublic` may be regenerated outputs.
- Avoid direct edits unless the task explicitly requires output changes.

## Dependency and Build Coupling

- The project depends on several private Tierra Cero packages and Swift Web nightly packages.
- Build failures may reflect external package access or local checkout state rather than the current source change.

