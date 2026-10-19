# TRIP-LOCATION-ITEM-DELETE-001 — reviewed plan

## Scope and verified contract
Primary Swift Web UI skill, supporting API skill. IDs SWWEB-001/002/003, API-001/002/003, SEC-001. Change only ManageLocationItem, its one CreateTripView call site and corresponding UI facts/memory/archive; preserve all existing edits. No API wrapper, shared payload, theme/global-state/dependency or source-boundary changes.

The requested endpoint takes DeleteLocationRequest.locationId and cancels a FiscalLocationBase. CreateTripView supplies a generated .v7() FiscalLocationItem.id to this editor; the saved source UUID is item.locationId and only .location sources represent FiscalLocationBase. Store, warehouse, subaccount and temporary entries cannot be deleted through this endpoint. The user confirmed: Delete the linked saved location (use deleteLocation).

## Implementation
1. Add an Eliminar crystal red button before the existing save action with margin-right:auto to place it bottom left. Show only when the editor ID exists and its source is a saved .location with a linked locationId. Keep existing save presentation.
2. Reuse ManageLocationBase's confirmation and existing deleteLocation response/error conventions. Send the linked source locationId, not the generated editor ID. Limit pending state to preventing duplicate deletions and saving during deletion. Retain the existing theme order.
3. Add an optional deletion callback while preserving the existing save callback API. After API success only, notify the parent and close. CreateTripView forwards deletion into its existing handleDestination(.delete), which removes the saved base from lists and clears matching route selections. Use same-session response handling; no server call during implementation validation.
4. Review saved/unlinked/other-source visibility, correct ID, cancellation, errors, repeated clicks and parent propagation. Parse changed files and run the already-approved focused App build with unchanged dependency pins; audit task-relative diffs, staging/status and documentation.

## Self-review
The linked-ID restriction is required by the verified endpoint, not an extra deletion feature. Parent cleanup is necessary so the deleted record is not left available for selection. Existing handleDestination provides this behavior; no new deletion subsystem/callback enum or source-ID conversion is needed. No actual saved location will be deleted by tools. Plan reviewed before source mutation.
