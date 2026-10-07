# Subcustomer coordinate map — reviewed plan

Scope: `ManageSubCustomerAccountView.swift`, a scoped MapKit creator in source-owned `Sources/Service/skyline/js/main.js`, and owning architecture facts. Preserve the current address layout and all unrelated changes. Generated public assets, dependencies, API contracts and saving behavior are outside scope.

Architecture: SWWEB-001/002/003; supporting PWA-001/002/003. Existing global map/marker helper cannot safely own multiple maps; the new bridge returns a local read-only MapKit map instance to this view.

Implementation: replace the map TODO with a 280px map container. Observe both coordinate states after attachment, combine paired assignments with a short scheduled refresh, validate finite geographic ranges, and load existing edit coordinates initially. Only the latest JWT callback may render while attached; clear/destroy the previous map on refresh or removal. Required-address mode shows a Spanish empty hint, optional mode hides the map without valid coordinates. Redirect validation references to the removed coordinate inputs to address lookup.

Completion: inspect source flow for initial load, paired updates, invalid/cleared coordinates, token failure, stale callbacks and removal. Review task-only diffs and status; confirm staged work remains unchanged. User explicitly selected static checks only, so do not run builds, tests, JS syntax validation or regenerate assets.

Review: scope matches the requested TODO and reactive map lifecycle; read-only marker avoids mutating coordinates without matching address data. Approved for implementation by self-review within the user-authorized scope.

## Audit

- Reviewed the task-only snapshot diff: one Swift snippet, one source-owned JavaScript map creator, and two owning architecture fact updates. Removed the form-fields grid class from the map wrapper so the map uses the full address-column width.
- Initial edit values are assigned before attachment; attachment explicitly schedules a refresh. Listeners observe both coordinates. Each schedule supersedes previous timers and JWT callbacks; removal invalidates pending work and destroys the owned map.
- Finite/range checks accept zero coordinates and reject missing, NaN/infinite or out-of-range values. Empty/invalid values clear the old map; optional mode hides the section and required mode shows a Spanish hint. Token/helper failure shows a Spanish error hint. Marker dragging is disabled to preserve address/coordinate consistency.
- Checked the bridge against the existing MapKit initialization, region and marker API usage in main.js. The new creator uses local variables, returns the map object and cleans up partial initialization on synchronous failure. Checked JavaScriptKit function/object and receiver-bound method APIs from the local dependency source.
- Focused git diff --no-index --check produced no whitespace diagnostics for all four files (exit 1 means snapshots differ). Staged diff hash is unchanged; status gains only main.js and this task's planning/evidence files.
- User requested static checks only: no builds, tests, JavaScript syntax execution, browser validation or generated public assets refresh were run. Map rendering remains runtime-unverified and requires the normal app/resource build to reach DevPublic/DistPublic.
