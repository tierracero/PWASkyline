# Confirm store address before Trip selection

Reviewed plan — 2026-10-06

Primary skill: `.agent/skills/swifweb_ui_skill.md`.
Architecture IDs: SWWEB-001/002/003 and STATE-001. No boundary rule changes.

## Scope

- Add `Sources/App/Snippits/ConfirmAdddressLocationView.swift` using the address section of `ManageSubCustomerAccountView` as the presentation reference.
- Update the store overload in `TripControler/TripControler+AddLocation.swift` to require complete address fields, a recognized Mexican state, and finite, in-range latitude/longitude before creating a Trip snapshot.
- Register the new crystal modal in `Functions/addToDom.swift`.
- Update verified facts and navigation in `.agent/architecture/SWIFWEB_APP_ARCHITECTURE.md`, `.agent/architecture/SECURITY_AND_STATE.md`, `.agent/SOURCE_MAP.md`, and `.agent/MODULES.md`.
- Record implementation and audit evidence in `.agent/TASKS_ARCHIVE.md`.

## Implementation

1. Prefill street, colony, city, state, country, postal code, and coordinates from the selected store. Preserve the spelling `ConfirmAdddressLocationView` requested by the user.
2. Reuse `ManualAddressSearch` for postal/coordinate lookup and the existing independently owned map-preview bridge. Include editable coordinates, required-field validation, and state validation. Keep failed/canceled confirmation in the picker; close child lookups/maps on removal.
3. Save using the existing `loadStore` and `saveStore` contracts. Load current store metadata/configuration first; carry every unrelated field and configuration value forward. Translate price modifiers from stored cents to the existing decimal request units. Reload after successful save; do not continue using merely optimistic address data.
4. Refresh the global `stores` dictionary and matching `OrderCatchControler` store/selected-store snapshots with the reloaded record, keyed by the store ID and guarded by the captured session `custCatchID`. Do not add a global cache or change browser storage.
5. Return the saved, complete store once and recall `renderLocation` with that record. Own the confirmation child in the picker; ignore late callbacks when the picker has been removed and prevent duplicate confirmations.

## Review

The current store snapshot has six address strings and optional string coordinates. `loadStore` returns `CustStore`, `ConfigStore`, and fiscal profile references. `saveStore` updates both store and configuration, so preserving loaded non-address fields is necessary. Order caches use `CustStoreBasic` and must also be refreshed. Country/state selection remains consistent with the existing Mexico-specific Trip conversion. `0` coordinates remain valid; nil, invalid numbers, infinities, out-of-range coordinates, whitespace-only fields, and unknown states are incomplete.

Completion criteria: complete stores continue directly; incomplete stores open a prefilled modal; validation/save/reload failures do not emit a Trip snapshot; successful saves refresh caches before resuming; cancellation and removal do not continue or leak maps/child views. Preserve all existing user edits and staging.

Audit: review task-only source diff and API argument mappings, inspect cancellation/failure paths, inspect whitespace and final git status. Builds/tests require the user's explicit confirmation, requested separately; otherwise report non-build verification only.

## Audit result

- The user explicitly selected **Use non-build checks only**. No builds, compiler checks, tests, or browser execution were run; compilation/runtime behavior remains unverified.
- Reviewed all task-file deltas against the saved pre-edit working files. Source changes are the new confirmation snippet, focused picker lifecycle/validation/resumption changes, shared state normalization delegation, and one additional glass-host view classification. The user-owned, previously untracked picker and all pre-existing staged changes were preserved.
- Required completeness covers street, colony, city, state, country, and zip; state matching preserves the existing raw-value/code/description normalization. Coordinate guards reject missing/unparseable/nonfinite/out-of-range values and allow zero. Both initial selection and the reloaded server record use the same completeness check.
- Save argument review confirms address/coordinates come from the validated form snapshot; all remaining store/configuration arguments come from the freshly loaded server record. Printing settings, both decimal price modifiers converted from cents, operation settings, all seven schedules, fiscal profile identity/display label, and inventory locking are preserved through the existing endpoint.
- Reload validates store identity and captured session before updating the global store and matching order-cache records; the callback runs after those writes. Failed validation/load/save/reload does not create a Trip snapshot. Removed confirmation/picker callbacks cannot resume selection. Successful late saves still refresh same-session caches without a visible dialog.
- Reviewed map request invalidation, paired-coordinate refresh coalescing, stale JWT result guards, invalid-coordinate map clearing, and dialog-owned map/search cleanup.
- Focused tracked-file `git diff --check` completed with exit 0. No-index whitespace reviews of the new snippet and the picker baseline delta produced no diagnostics; exit 1 indicates differing file contents.
- Final working-tree status comparison found no unexpected status changes and no changes to pre-existing staging. The task-only diff is saved in `confirm-address-location.diff`; source-map, module, architecture/state facts, and task archive are synchronized. No commit was made.
