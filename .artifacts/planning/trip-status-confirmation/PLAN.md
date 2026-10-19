# Trip status confirmation plan — 2026-10-08

## Reviewed scope
- Primary checklist: `.agent/skills/swifweb_ui_skill.md`.
- Architecture IDs: SWWEB-001/002/003; API-001/002 and SEC-001 preserved. No boundary rules change.
- Preserve all initial user changes, particularly the existing right-side data/status grids.
- Change only TripControler+TripViewBeta.swift, a new TripControler/ConfirmTripStatusUpdate.swift, MediaViewer.swift, and focused documentation/evidence.

## Implementation
1. Remove the beta status selector. Put compact crystal start/complete/cancel actions in the existing 35px status grid. Pending: start + cancel; in progress: complete + cancel; terminal states: none. Keep data height calc(100% - 35px).
2. Add a crystal modal with side-by-side status/comment and merchandise panels, responsive via existing VGrid. Require trimmed cancellation comments. Return typed status, comment and shared ChangeTripStatusMedia entries for merchandise with completed uploads.
3. Reuse uploadManager and requestMobileCamara with unregistered asset-image staging (no related server ID). Correlate every event to its row, accept images only, deduplicate completion, block confirmation during pending work, ignore late responses after removal. Each row has the requested clip/camera icons, first completed image avatar and count.
4. Extend MediaViewer to honor currentView, navigate multiple images/videos with bottom thumbnails and previous/next controls, and use the selected file for deletion. Preserve existing call sites and add an explicit read-only mode for staged evidence. Support per-file URL bases for upload responses.
5. Replace the beta changeStatus API implementation with a typed status/comment/media placeholder. Do not update API wrapper or shared dependencies; do not mutate server-owned status or announce success.

## Completion evidence
- Review task diff against initial file snapshots and git status; preserve unrelated user work.
- Swift syntax validation and a focused App build authorized by the user. Cached TCFireSignal is missing ChangeTripStatusMedia although the local package has it; report dependency limitations without changing dependencies.
- Update source map/module navigation and verified UI facts; record build/manual-check limits in AUDIT.md.

## Plan review
Reviewed against the request and repository lifecycle, theme, status authority and upload contracts before source mutation. Existing public MediaViewer initializer remains source-compatible. The pending API handoff is intentionally inert. No subagents, commits, generated assets, or dependency edits.

## Focused review amendment
Local Swift Web source confirms that custom CSS and arbitrary attributes do not accept State values, InputFile has no value setter, and TextArea is not Selectable. Replace only those assumptions with explicit thumbnail updates, browser-guarded file-input value reset and normal input focus. This is a reviewed compatibility correction within the original scope; no new subsystem or dependency change. Build resolution also fails on unavailable pinned TCFundamentals revision 25fd6294b7ccbca6a5542769e9dadbb709121988, so compile success cannot be claimed.

## Theme audit refinement
The trip theme declares inline-flex buttons and a 30px !important height for all controls. Use explicit state-driven display for status actions, and an inline !important height for the multiline comment field. Only render the viewer thumbnail strip when multiple files exist. This keeps the requested conditional actions and comment area visible as intended under the existing cascade.
