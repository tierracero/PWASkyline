# Nonblocking trip status image upload parity — 2026-10-08

## Reviewed plan

Primary checklist: Swift Web UI; supporting checklist: WebSocket. IDs SWWEB-001/002/003, WS-001/002, SEC-001. Context read: UI, WebSocket and security/state architecture, source map and ManagePOC's current request/local-upload/event flow. Scope: ConfirmTripStatusUpdate.swift, its verified UI fact and task documentation/evidence. ManagePOC, MediaViewer and API/shared contracts are read-only references.

1. Remove cameraEventId, isCameraPending and Cancelar cámara UI entirely. Request the asset camera with eventid:nil, multipleTakes:true, no loading veil or request-time pending upload entry.
2. Use the parent confirmation's current camera row to associate new server capture events with merchandise. Known event ownership remains with its original row when the camera target changes. Handle selected/initiate/complete/progress/fail/cancel like ManagePOC; completion must be for .asset. Remember terminal event IDs so duplicate/delayed messages cannot recreate images or failed captures. The shared selected/initiate protocol carries only event ID, so unbound captures follow the most recently requested merchandise row.
3. Keep per-file local XHR/progress/processing status checks, image-only/30 MB validation and unregistered .asset uploads. Completed HTTP/WebSocket results count once, preserve the first completed avatar and retain the existing numbered file count and MediaViewer gallery. No automatic editor, per-image cards or registered product media requirements are introduced.
4. Remove the pending-upload confirmation guard: confirmation stays available and snapshots only completed images. Existing transition, asset-route and cancellation-comment validation remains. Closing/submitting stops local pending uploads and ignores late events.
5. Verify parsing, the previously authorized focused App build, focused event scenarios (multiple captures, switching row ownership, duplicate/cancelled completion, HTTP/WS race and close), baseline-relative diff/whitespace/status/staging and unchanged dependencies/reference files. Browser/device upload validation is not authorized as a live API action and will remain unrun.

Plan reviewed before source mutation. Completion requires nil camera request event ID, no camera-pending fields/UI, nonblocking upload/confirmation flow, correct per-merchandise completed-image callback/counter/avatar/viewer and duplicate-safe lifecycle behavior. Preserve unrelated user edits; no staging or commits, package pin changes or architecture boundary changes.
