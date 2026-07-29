# Plan — SearchCustomerQuickView and SearchCustomerFiscalView dark crystal update

## Scope

- `Sources/App/Snippits/SearchCustomerQuickView.swift`
- `Sources/App/Snippits/SearchCustomerFiscalView.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`

No account-search API, debounce, minimum-term validation, auto-selection, account creation, callback, focus, or removal behavior changes.

## Architecture

- `SWWEB-001` — changes remain in the browser UI layer.
- `SWWEB-002` — preserve existing modal lifecycle and account-selection behavior.

## Updated dark-crystal guidelines applied

1. Preserve the low-opacity blurred workspace veil.
2. Use a translucent macro shell rather than a flat opaque panel.
3. Separate the solid `#252c3b` header from the body by a visible 12px gap.
4. Use cyan titles, borders, focus accents, and left-edge result rails.
5. Use dark graphite result cards for readable account information.
6. Keep primary actions prominent and secondary/create actions restrained.
7. Keep both views responsive and viewport-safe.

## Implementation

1. Rebuild each legacy fixed-position popup with `VPopUp`, `VTitle`, and `VBodyGrid`.
2. Add shared semantic customer-lookup classes to `TCCrystalSurfaceTheme`.
3. Convert the search toolbar from floats to a responsive grid.
4. Style empty/results containers as independent crystal body surfaces.
5. Style dynamically generated account rows with clear business/name hierarchy and focused badges.
6. Keep all existing state bindings and callbacks unchanged.

## Completion Criteria

- Both views use the scoped `.customerSearch` crystal variant.
- Header and body are visibly separated by 12px.
- Search controls and results remain usable on narrow screens.
- Existing search/create/select behavior is unchanged.
- Build/test is not run without explicit user confirmation, per repository rules.
