# Plan — TripControlerAddElement dark crystal style

## Scope

- `Sources/App/Snippits/TripControler/TripControler+AddElement.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`

No API, session, routing, trip data, callback, create/select behavior, or generated asset changes.

## Architecture

- `SWWEB-001` — keep the change inside the browser UI layer.
- `SWWEB-002` — preserve the existing modal lifecycle and `addToDom` behavior.

## Implementation

1. Preserve the existing `TCTripBetaTheme` then `TCCrystalSurfaceTheme(.trip)` application order.
2. Replace legacy inline gray popup styling with named Trip picker classes.
3. Present a responsive centered dark-crystal panel with a compact header, Add action, close action, scrollable list, and viewport-safe sizing.
4. Restyle selectable rows as dark crystal interactive cards with clear title/subtitle hierarchy.
5. Restyle the empty state without changing its Add behavior.
6. Add narrowly scoped selectors to `TCCrystalSurfaceTheme` so no unrelated screens are changed.

## Completion Criteria

- `TripControlerAddElement` no longer uses the legacy `backGroundGraySlate`, `roundBlue`, or `roundGrayBlackDark` presentation.
- Selection and creation callbacks still execute exactly as before and remove the modal.
- The panel is responsive and capped by the viewport.
- Only the two scoped source files and this transient plan are changed by this task.
- Build/test is not run without explicit user confirmation, per repository rules.
