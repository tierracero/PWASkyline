# Asset Kardex map history — source audit

Date: 2026-10-22. Scope: the eight files in snapshot-paths.json. Reviewed plan: PLAN.md. Task-relative source/doc evidence: task.diff (working-file snapshots preserve earlier uncommitted work).

## Results

- `node --check Sources/Service/skyline/js/main.js`: exit 0, no diagnostics (run again after annotation anchor adjustment).
- `git diff --check --` the eight scoped files: exit 0, no diagnostics.
- Final `git status --short`: same pre-existing modified/untracked file set as the pre-edit inspection, including this task's evidence directory. Mutations limited to two source files, six documentation files and this evidence directory; nothing staged or committed.
- Manual source/contract review: typed Kardex request defaults to 50 rows; response has page/hasMore/events. Companion server CustCommercialAssetsItemTransitionService.loadKardex sorts createdAt/id ascending, so all pages are scanned. The first response is retained for the existing Kardex tab; no wrapper/server/model changes.
- Manual selection trace: invalid/missing coordinates and current's exact coordinate pair are skipped; duplicate historical pairs retain their newest timestamp/UUID; each page reduces candidates to the latest nine. Dropped candidates cannot displace a newer top-nine candidate later. Final order is reversed to oldest-first before rendering; current is appended only to the line, with its original saved coordinate and default marker style.
- Manual lifecycle trace: both map-first and history-first completion call applyMapHistory; incomplete/failed scans never publish partial history. Tab selection retries a failed scan without duplicate simultaneous requests. Refresh/close invalidate request identities; callbacks also check mount/session/editor/item. Maps are destroyed before DOM replacement and on removal. The helper captures its own map and does not write shared map/marker globals.
- Manual rendering/API review: historical elements use a 26px gray circle with opacity 0.50 + 0.40 * rank / (count - 1), or 0.90 for one history point. A five-point history therefore uses 50/60/70/80/90 percent alpha. Center anchor offset is (0, -13) for the custom circles. Light gray chronological polyline ends at current; showItems frames all points. Existing note rows, event-card content/map modal/evidence and unrelated JS resource content are preserved in the task-relative diff.

## Primary API references consulted

- https://developer.apple.com/documentation/mapkitjs/annotation
- https://developer.apple.com/documentation/mapkitjs/annotation/anchoroffset
- https://developer.apple.com/documentation/mapkitjs/annotation/displaypriority-data.property
- https://developer.apple.com/documentation/mapkitjs/style
- https://developer.apple.com/documentation/mapkitjs/polylineoverlay
- https://developer.apple.com/documentation/mapkitjs/map/showitems
- https://developer.apple.com/documentation/mapkitjs/padding

## Limits

Builds, tests and browser/live MapKit execution were not authorized or run under the repository confirmation rule. This is source/contract/syntax/diff validation, not compiled or visual runtime verification. Generated DevPublic/DistPublic outputs were not regenerated; the normal build/resource refresh must include both the Swift change and the updated skyline/js/main.js resource.
