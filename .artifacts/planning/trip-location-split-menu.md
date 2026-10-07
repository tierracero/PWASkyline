# Trip location split action menu

Date: 2026-10-02

## PLAN — reviewed before mutation

- Source scope: `TripControler+AddLocation.swift` and dedicated scoped rules in `TCCrystalSurfaceTheme.swift`. Restore this task's interim changes in CreateTripView while preserving its pre-existing edits.
- Documentation: update the existing picker fact in `SWIFWEB_APP_ARCHITECTURE.md`; retain file ownership in `SOURCE_MAP.md`.
- IDs: SWWEB-001/002/003; API-003 supports focused fiscal review. No API contract or architecture boundary changes.
- Replace the header action with two native buttons: Agregar always invokes the existing creation callback; the separate arrow toggles an anchored dropdown with Agregar ubicación, Seleccionar tienda, Buscar cliente.
- Use presentation state for open/closed behavior, native keyboard activation, Escape/outside-click dismissal, and accessible expanded/controls attributes. Keep the menu above the location list without clipping, scoped only to the dedicated picker. Preserve Trip beta then crystal `.trip` theme order and reuse goodButton plus the established picker action gradient.
- The user's latest scope requires empty `selectStore()` and `searchCustomer()` methods on the dedicated picker. These actions close the menu and leave the picker open. Do not implement store/customer loading, selection, prefilling, or persistence.
- Both main Agregar and menu Agregar ubicación invoke the unchanged create callback and dismiss the picker, preserving current behavior. Keep the initializer/caller contract unchanged.
- The newly found tabs call is an invalid placeholder using type names as arguments. Comment that call so tabs remain pending; retain the user's tabs property and leave tabsContainer.swift untouched.
- Keep empty-state actions in the header, removing the duplicated body Agregar control.
- Audit: compare pre-edit snapshots, review callback/close propagation, compare referenced shared model fields, run scoped diff/whitespace checks, inspect git status. Builds/tests require user confirmation and will not be run without it.

## Review

Reviewed the final plan after the user's clarification: store/customer behavior is explicitly pending. Keep all changes in presentation and the two requested empty methods, with the existing create callback as the only active workflow.

## AUDIT — source and diff review

- The final source scope is the dedicated picker and its scoped crystal styles; the architecture fact was updated. `CreateTripView.swift` matches the pre-task snapshot exactly after removing interim flow work.
- Reviewed main action and menu creation: both call the existing `create()` callback and remove the picker. The other two actions call empty methods, close the menu, and return focus to the arrow without removing the picker.
- Reviewed event propagation: arrow/menu/main handlers stop click bubbling; the picker root handles outside clicks; Escape closes an open menu and returns focus to the arrow. The state listener is cleaned up on removal.
- Verified native Button, onKeyDown, and focus APIs against the local Web package source. No browser or Swift runtime result is implied by this source review.
- Dedicated crystal selectors outrank legacy title-button borders and mobile overflow/grid rules. Only the location picker changes clipping; other generic pickers keep their established rules.
- The incomplete tabs call was commented, retaining its draft for later work; tabsContainer.swift and the generic picker were untouched.
- Focused tracked-file whitespace checks passed; the untracked picker diff against its snapshot reported no whitespace errors. Git status preserves the initial unrelated edits, with the theme file and this planning artifact as this task's additions to that status set.
- No builds/tests, browser validation, generated outputs, staging, or commits. User confirmation for builds/tests was not provided.
