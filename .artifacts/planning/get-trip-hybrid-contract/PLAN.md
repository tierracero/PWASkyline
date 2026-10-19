# GetTrip HybridIdentifier usage — 2026-10-08

## Reviewed plan

Primary checklist: API endpoint; supporting checklist: Swift Web UI. Architecture IDs API-001/002/003 and SWWEB-001/002/003. Scope: GetTrip wrapper, beta detail presenter/status refresh, trip-list and followup detail-opening callers, focused docs/evidence. Preserve all pre-existing edits.

Verified contract delta: local TCFireSignal GetTripRequest and request helper take HybridIdentifier instead of UUID. GetTripItem/GetTripResponse, the tripId wire key, POST getTrip route and existing transport/decoding remain unchanged. TCFundamentals defines .id(UUID) and .folio(String).

1. Change the app getTrip wrapper's parameter to HybridIdentifier.
2. Change TripViewBeta.loadAndPresent to accept HybridIdentifier, retaining the server-returned trip and UUID-based status callback. Wrap the post-status-refresh trip UUID in .id(...). Wrap both trip-list and followup opening UUIDs in .id(...). No new search UI or duplicate DTOs.
3. Parse all four files and review every exact getTrip/loadAndPresent usage, task-only diff, whitespace, staging and status. Run a focused App build under the existing explicit user approval if feasible; preserve Package.resolved and do not modify dependencies to fix unrelated failures. If resolution blocks compilation, use a limited compile-only check of the exact updated shared request/wrapper/presenter and .id/.folio argument types and report limits.
4. Sync the owning API/UI fact, source map and completed-task archive. No architecture boundary/path/module ownership change, staging or commit.

Plan reviewed against the exact local shared contract, unchanged response, and the complete caller search before mutation. Completion means every app use matches HybridIdentifier while UUID status updates, error paths and UI behavior are preserved.
