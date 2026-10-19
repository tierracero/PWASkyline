# Additional trip destinations

Date: 2026-10-15

## PLAN

Continue in the main PWASkyline checkout used for the preceding work. Primary checklist: Swift Web UI; supporting API endpoint checklist. IDs: SWWEB-001/002/003 and API-001/002/003. User clarification: destinations are separate choices for individual asset items; keep per-asset selection and save all route stops together in one trip. TripViewBeta receives the adaptive presentation, not new saved-trip mutation endpoints.

Source scope:
1. TripControler+CreateTripView.swift: retain origin and first destination state, add ordered additional destinations. Show a crystal Agregar Destino action at the right of Ruta del viaje only when the first two stops exist. Reuse the Seleccionar Destino picker and existing location editor/creation paths with an explicit append intent. Preserve two columns until an additional stop exists; then show origin and all destinations in one vertical scrollable list, restoring two columns after the last extra is removed. Prevent removal of the first two stops while extras exist, including stale callbacks. Support extra edits, saved-base updates/deletions, duplicate-source/reference rejection, ordered adapter positions and cleanup of the new state listener.
2. Preserve individual merchandise/asset destination assignments when route stops change. Offer all eligible selected destinations through the existing merchandise editor, including linked asset destinations. Only missing/removed destination references fall back to an eligible remaining destination. Submit origin + first destination + ordered extras through the unchanged locations array; check unique nonempty placement references and existing linked-asset route validation before creating.
3. TripControler+ManageLocationItem.swift: add an optional deletion-policy closure, defaulting to current behavior. Creation passes a live policy protecting origin/first destination while extras exist; hide the delete button and guard both confirmation entry and confirmed API submission. Other callers retain existing behavior.
4. TripControler+TripViewBeta.swift: retain current route cards and sorted position order; use the existing grid for up to two stops and one column for more than two, recalculating on every render.
5. Update verified source facts in UI/API architecture, project memory and task archive. No architecture rule/path/module changes; router indexes/source map remain unchanged.

## Review before mutation

Self-reviewed: existing shared CreateTripRequest.locations is an array of TripLocation; server makeLocationItems enumerates that array into persisted snapshot positions. Existing AddCartaPorteMerchendise already lists all supplied destination snapshots, while CreateTripView currently restricts submission to two stops and overwrites each merchandise.to during synchronization. The new behavior must therefore preserve each still-valid chosen destination, not simply add UI cards. Existing linked asset route checks remain authoritative. Selection intent propagates through registered locations, store/subaccount picks, new base creation, and per-trip editing. Deletion policy closes the editor bypass of the primary-stop lock. All pending user work must be retained; no unrelated refactors or server/shared-contract changes.

## Audit / completion

Review the complete baseline-relative diff and visibility/append/edit/remove/update/delete/assignment/submission/refresh paths. Guard main-checkout writes against baseline changes, compare tracked-file fingerprints and final git status, and check added whitespace. Build/test/full compilation require explicit user confirmation under AGENTS.md and are not authorized; perform source review only. No staging, commits, deployment or generated-output changes. Completion is all described source paths implemented and source-audited; browser/build behavior remains explicitly unverified.
