# Dedicated trip merchandise picker

Reviewed plan — 2026-10-04

Primary skill: Swift Web UI checklist. Architecture IDs SWWEB-001/SWWEB-002/SWWEB-003. No architecture boundary changes.

## Scope

- Add Sources/App/Snippits/TripControler/TripControler+AddMerchandise.swift with TripControlerAddMerchandise, derived from the existing generic picker's presentation.
- Update only CreateTripView.addMerchendise() to use the new account-aware picker.
- Synchronize SOURCE_MAP.md, MODULES.md and architecture/SWIFWEB_APP_ARCHITECTURE.md.

## Implementation

1. Inject CustAcctSearch, mutable merchendises: [FiscalMercanciaBase], a typed FiscalMercanciaBase selection callback and the existing creation callback. Fix the view's title/icon and fiscal-code/description/unit/weight formatting to merchandise.
2. Preserve the current list, empty state, selection dismissal, creation dismissal and close behavior. Other generic pickers and the specialized location picker remain unchanged.
3. Before + Agregar in the header, render Buscar Activo only for account.isConcessionaire. Use a decorative magnifying-glass SVG icon and the existing goodButton/tripPickerCreate classes. The button calls a dedicated guarded searchAsset() placeholder and retains the picker; no asset endpoint or selection flow was requested.
4. Apply TCTripBetaTheme first and TCCrystalSurfaceTheme(.trip) second. Reuse scoped picker and responsive header styles; avoid unrelated theme changes.

Plan review: CustAcctSearch exposes isConcessionaire, and the current merchandise caller passes FiscalMercanciaBase to configureMerchendise. The dedicated picker can preserve that callback and creation flow directly without converting source IDs or changing trip request payloads.

Completion criteria: reviewed source and task-only diff, button visibility/order/icon/callback checks, constructor/caller compatibility, focused non-build whitespace checks, status and staged-index preservation. Builds/tests require user confirmation and are not authorized.

## Audit result

- Reviewed the full new source and the task-only diff in trip-merchandise-picker.diff. The caller change is confined to addMerchendise's picker initializer; origin/destination validation and existing configureMerchendise/manageMerchendise callbacks remain intact.
- Verified the shared CustAcctSearch declaration exposes isConcessionaire. Buscar Activo is conditionally emitted before + Agregar, includes a decorative cyan SVG magnifying glass, uses goodButton/tripPickerCreate, and invokes only the guarded searchAsset placeholder without dismissing the picker. Both header and empty-state creation buttons call the existing create callback and dismiss the picker.
- FiscalMercanciaBase selection returns the original base item and dismisses the view. Merchandise code/description, fiscal unit name, and weight formatting remain the same as the original caller. No merchandise identity or request mapping changed.
- Verified theme registration order and reuse of the existing picker list/panel/header classes. The existing <=760px Trip header rule places actions on a separate header row, preserving the narrow-screen treatment without adding theme rules.
- All five new/changed source and stable-document task-only whitespace comparisons emitted no diagnostics (no-index exit 1 indicates differing files). The cached binary diff SHA-256 is unchanged. Git status comparison shows only intended existing-file modifications and new task source/artifacts; unrelated source and the original generic picker are unchanged.
- No builds, tests, or browser/runtime checks were run because repository instructions require explicit confirmation. Compilation, rendered appearance, and runtime behavior remain unverified. Asset search itself is intentionally pending.
