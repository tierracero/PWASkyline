# Trip summary status — 2026-10-09

## Scope and request

Add a current-status metric immediately before Creado in TripControler+TripViewBeta.swift's top summary. Use the existing Spanish FiscalTripFollowupStatus.description values and summary styling. Preserve existing user edits and API/status behavior.

## Reviewed implementation

- Add one lazy status value Div bound to the existing $status state, so successful updates appear immediately even if the follow-up trip refresh fails. Reuse that Div across summary redraws.
- Add an Estatus metric before Creado. Extend summaryMetric with a Div value overload; existing string callers delegate to it, preserving common styling without duplication.
- Account plus five metrics have six explicit grid columns: minmax(240px, 1fr) repeat(5, auto), preserving gaps and alignment.
- Source scope: Sources/App/Snippits/TripControler/TripControler+TripViewBeta.swift. Sync one architecture verified fact and completed-task archive entry. No dependency, theme, asset, API, route or ownership changes.
- Architecture IDs: SWWEB-001, SWWEB-002, SWWEB-003. Existing state initializes from the trip, updates only after API success and on server refresh, and removes listeners on DOM removal.

## Completion and validation

Review ordering, reused metric style, all four shared labels and state-update/removal paths. Run frontend syntax parsing and the previously approved focused App build with current dependency pins/cache. No test suite or server/browser mutation. Review baseline-relative source/docs diff, whitespace, staging and git status. Record compilation evidence and the browser-rendering limit in AUDIT.md.

## Plan review

Reviewed the summary's existing grid/metric helper, state initialization, renderTrip, changeStatus success/error/refresh paths and removal cleanup. A persistent bound value avoids snapshot lag and accumulating new status value listeners on summary redraws. Changes stay within the requested summary field.
