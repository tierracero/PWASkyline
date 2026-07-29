# Plan — ConfirmationView dark crystal style

## Scope

- `Sources/App/Snippits/ConfirmationView.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`

No confirmation validation, callback, comment requirement, button meaning, or removal behavior changes.

## Architecture

- `SWWEB-001` — keep the change in the browser UI/theme layer.
- `SWWEB-002` — preserve the existing `VPopUp` lifecycle and `addToDom` behavior.

## Implementation

1. Add a dedicated `confirmation` crystal variant and narrowly scoped class names.
2. Apply `TCTripBetaTheme` first and `TCCrystalSurfaceTheme(.confirmation)` second.
3. Style the backdrop and panel as a centered, viewport-safe dark crystal modal.
4. Improve title, confirmation badge, message surface, comment field, and action spacing.
5. Give positive and negative actions distinct crystal treatments while preserving their current callbacks.
6. Stack actions cleanly on narrow screens.

## Completion Criteria

- `ConfirmationView` uses the dark crystal visual system.
- Comment-required and optional states remain unchanged.
- Positive, negative, close, and callback behavior remains unchanged.
- Styles are scoped to `ConfirmationView` and do not affect `ConfirmView` or unrelated popups.
- Build/test is not run without explicit user confirmation, per repository rules.
