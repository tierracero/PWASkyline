# Trip detail → mounted trip list status synchronization — 2026-10-09

## Verified problem

TripViewBeta already calls its injected status callback after API success. Trip-list cards and creation supply a callback, but Work folio search supplies an empty callback and followup entries update only their own list. Thus the mounted TripsControlerView is not updated consistently across detail entry points. An in-flight getTrips response also currently replaces locally updated statuses without reconciliation.

## Reviewed scope

- Sources/App/Snippits/TripControler/TripControler+TripViewBeta.swift: publish an acknowledged status change to the mounted trip dashboard, in the existing API-success/session-guarded path, preserving the injected callback and refresh.
- Sources/App/Snippits/TripControler/TripsControlerView.swift: own a private weak mounted-dashboard reference, updated on DOM mount/removal; expose a typed static forwarding method that uses the existing instance update and processItems paths. Work is the sole constructor of this dashboard in the current app, so one mounted dashboard is the verified ownership model.
- Make updateTripStatus mounted-only and idempotent, so dashboard-card callbacks plus central forwarding cannot regroup twice. Preserve status columns/counts and filter behavior; no forced network reload.
- Keep only status acknowledgements occurring during an existing list request in a local request-scoped dictionary. Merge them into that response before processItems, then clear the dictionary on completion (including errors) or removal. Requests begun after acknowledgement remain server-authoritative. Reject removed-view/changed-session list responses.
- Sync a verified architecture fact and completed-task entry. IDs: SWWEB-001, SWWEB-002, SWWEB-003, STATE-001, SEC-001. No architecture boundary/ownership changes; the weak reference is list-owned ephemeral presentation coordination, not a global trip-data cache.
- Preserve unrelated user edits. No changes to Work, Followup, API wrappers, dependencies, UI styling, assets, staging or commits.

## Completion and validation

Review all detail entry points; success versus failure/session change; duplicate callbacks; each status transition and derived counters; a stale list response arriving before/after acknowledgement; multiple changes during one request; unknown trip IDs; request errors; dashboard removal/replacement and detail closure during submission. Run frontend parsing and the previously user-approved focused App build with existing pins/cache. No test suite or server mutations. Inspect baseline-relative diffs/whitespace, status/staging and source snapshots. Record browser validation limits in AUDIT.md.

## Plan review

Confirmed the existing typed callback, API-success guard, processItems grouping, hourly/manual request scheduling and sole Work-owned dashboard construction. A weak mount-scoped reference covers Work/search/followup opens without introducing an event framework or retaining old workspaces. Request-scoped reconciliation prevents an older response from undoing a successful status change while preserving subsequent server refresh authority.
