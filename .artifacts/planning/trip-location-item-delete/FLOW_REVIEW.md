# Saved-location cancellation source review

User confirmed cancellation of the linked saved location with deleteLocation. This is a source review, not a runtime request.

- UI eligibility: editor id present, locationType == .location and linked locationId present. Store/warehouse/account/subaccount/temporary snapshots are outside the saved-base endpoint. New/unlinked entries expose no action.
- Bottom left: shared titleActions uses flex; the red crystal USmallButton is inserted before the unchanged save action and has margin-right:auto. Root keeps TCTripBetaTheme followed by crystal .trip; existing trip-specific red selectors win the cascade.
- Correct record: CreateTripView's legacy editor adapter generates a temporary item id, while retaining locationId. The request uses locationId. The existing API wrapper posts DeleteLocationRequest(locationId) and decodes APIResponse. The server marks the matching FiscalLocationBase status canceled and retains the row.
- Confirm/cancel: existing ConfirmationView convention retained; no request when declined or editor removed. A confirmed pending request disables the delete button and blocks repeated deletion/save.
- Failure: nil response or non-ok status shows existing errors; clears pending state and leaves the editor and selected base unchanged.
- Success: invokes onDelete only after ok, passes the saved UUID and closes. Parent reuses handleDestination(.delete): removes the base from both local lists and clears only matching .location selections. This is local new-trip presentation cleanup; no removeLocation call is introduced.
- Session/lifecycle: response must match the captured custCatchID. Late success may notify the weakly captured parent after editor closure; no new globals/cache ownership. Owned isDeleting listener cleaned up with existing state listeners.
- Save behavior: unchanged field validation, typed callback and item construction; optional onDelete has a default to preserve call compatibility.
- Exact pinned dependency contracts were re-read after cache recovery; DeleteLocationRequest and LocationType/FiscalLocationItem fields match the implementation.

No actual location, trip stop or server record was mutated by validation tools.
