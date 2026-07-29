# Plan — ViewHighPriorityNote dark crystal style

## Scope

- `Sources/App/Snippits/ViewHighPriorityNote.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`

No note loading, user lookup, priority-lowering API, confirmation, state, callback, or removal behavior changes.

## Architecture

- `SWWEB-001` — keep the change in the browser UI layer.
- `SWWEB-002` — preserve the existing modal lifecycle and note actions.

## Implementation

1. Add a `highPriorityNote` crystal variant and narrowly scoped semantic classes.
2. Replace the fixed legacy gray popup with a centered, viewport-safe dark crystal alert panel.
3. Create a clear alert header, metadata row, readable note body, and aligned actions.
4. Restyle the close, lower-priority, and confirmation actions while preserving their callbacks.
5. Add responsive sizing for narrow screens.

## Completion Criteria

- The note modal uses the dark crystal visual system.
- The alert context remains visually prominent without changing note data or behavior.
- The panel remains readable and viewport-safe on desktop and mobile.
- Existing API and state behavior is untouched.
- Build/test is not run without explicit user confirmation, per repository rules.
