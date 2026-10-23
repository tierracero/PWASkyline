# Asset location history styling

Reviewed: 2026-10-22. IDs: PWA-001/002/003, SWWEB-001/002.

Scope: createAssetItemLocationMap in Sources/Service/skyline/js/main.js and the five affected documentation files in snapshot-paths.json. Apply black text and a 3px solid black border to historical annotations. Set the connecting polyline to orange rgb(255,165,0), width 4px. Preserve marker gray fill, age-based opacity, current marker, history selection, route ordering and lifecycle. Use source-owned resources under the PWA resource checklist; generated outputs remain for normal refresh.

Completion: review the focused task-relative diff, JavaScript syntax lint and whitespace/status audit. Builds/tests require separate confirmation and will not run for this source styling edit. No commit.
