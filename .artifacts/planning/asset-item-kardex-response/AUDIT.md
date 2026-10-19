# Kardex response projection audit — 2026-10-09

- Corrected the raw persistence-event array supplied to GetAssetItemKardexResponse. The endpoint now loads relations and passes an explicitly typed [CustCommercialAssetsItemKardexObject] projection.
- Reviewed all 14 constructor fields against the current local TCFireSignal definition: id, createdAt, images, eventType, toLinkType, toLinkedTo, toStatus, contextType, contextId, noteId, performedByUser, source, latitude and longitude.
- Retained each event and its position through events.map. Image lookup uses the original per-event ID order; missing file records are omitted.
- Each location case reads the matching tenant table. Store and warehouse share the store lookup without losing their case. Missing locations resolve nil while retaining toLinkType.
- Related IDs are collected from only the requested page; duplicates are deduplicated for queries. Empty ID sets return a completed empty future before SQL preparation/execution. All relation queries use the authenticated sitio and connection.
- Actual notes/actors take priority. Required missing values receive response-only placeholders; no UUID is randomly generated, no history is omitted, and no note/user is inserted. Existing missing relation IDs are retained; absent IDs use a zero UUID. Actorless events display their source; unresolved identified users display Usuario no disponible.
- Existing paging clamps, row overflow/hasMore, history filters, service ordering, integrity flag, session validation and route registration remain unchanged.
- PWA source consumes the shared response object; resolved location name, actor username, note text and ordered evidence use existing UI/MediaViewer APIs. Its API wrapper already decodes the updated contract.
- Server task-relative added-line whitespace check passed. Governance diff whitespace checks passed in both repositories. Preexisting endpoint whitespace and unrelated PWA source edits were preserved.
- The unrelated user-modified transition service remained byte-for-byte unchanged during this follow-up (SHA256 compared with saved baseline).
- Build confirmation requested separately because AGENTS.md requires explicit permission. No compile, build, test, live database, browser or deployment command ran during this fix.
- Git status reviewed: endpoint, focused governance/evidence files are task scope; transition-service changes are preexisting. No staging or commit performed.
