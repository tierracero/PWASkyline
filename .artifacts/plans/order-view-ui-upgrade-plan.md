# OrderView UI Upgrade Plan

## Runtime correction — 2026-07-21

Browser validation exposed a Swift/Wasm `memory access out of bounds` failure while the Web `@Rules` result builder materialized the complete OrderView theme. The theme contains substantially more top-level rules than the working repository themes. Preserve the approved selectors and presentation, but register them through several bounded stylesheet-builder closures so each generated `RulesContent` tuple remains small. Rebuild and audit the focused theme diff after the change.

## Scope

- Add a scoped `TCOrderViewTheme` under `Sources/App/TierraCeroCustomUI/Theme/`.
- Add semantic presentation classes to `AccoutOverview`, `OrderView`, and `OrderView.EquipmentView`.
- Recompose the existing account/order toolbar into breadcrumb, centered order identity, and compact action groups.
- Reuse the existing OrderView controls and handlers for notification, send-to-mobile, minimize/handoff, edit, close, priority, alert, project, print, notes, files, charges, payments, status, address, and finalization.
- Preserve existing API, WebSocket, cache, payment, upload, and order-state behavior.

## Architecture IDs

- `SWWEB-001`: changes remain under `Sources/App/**`.
- `SWWEB-002`: no route, lifecycle, service-worker, or deep-link changes.
- `SWWEB-003`: presentation classes and layout do not become business-data authority.

## Existing User Work Review

- `AccoutOverview.swift` already contains asynchronous cached-order loading changes; retain them unchanged.
- `OrderView.swift` already contains deferred message loading, weak captures, payment receipt, and location changes; retain them unchanged.
- The new theme is scoped to the OrderView root so account, fiscal, metrics, and other application views are not globally restyled.

## Completion Criteria

- Order mode matches the approved dark two-column mockup at desktop widths.
- Toolbar contains the approved compact actions without duplicating behavior.
- Equipment, notes/files, charges/payments, summary, rewards, surveys, contracts, address, and outcome controls remain interactive through their existing handlers.
- The App target builds successfully.
- Final diff review shows only intended presentation changes plus this transient plan and mockup artifacts.
- Git status is reviewed for unintended files.

## Review Result

Reviewed against `.agent/SYSTEM_RULES.md`, `.agent/WORKFLOW.md`, `.agent/COMMIT_RULES.md`, `SWWEB-*`, the current source, and the dirty worktree. The plan is focused and implementation may proceed.
