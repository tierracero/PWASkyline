# Asset serial mobile scanner — 2026-10-09

## Scope and completion criteria

Complete CreateAssetItemView.addSeries using WorkViewControler.requestMobileScanner's mobile-notification scanner request. The existing serial icon must send requestMobileCamara with type .scanner, current connid, a correlated eventid, relatedid nil, relatedfolio empty, and multipleTakes false. A matching requestMobileScannerComplete result must fill the existing serial state/input without submitting the form or performing a folio search.

Source scope: Sources/App/Snippits/CustAssetsView/CustAssets+CreateAssetItemView.swift only. IDs: SWWEB-001, SWWEB-002, SWWEB-003, WS-001, WS-002, SEC-001. No API/WS wrapper changes, dependencies, themes, routes, generated outputs or global caches. Preserve existing user edits, camera/media handling, warranty-card flow and create payload.

## Reviewed implementation

- Add instance-owned optional scanner event/session IDs and an API-request-pending flag. Allocate a new UUID for each scanner request; register correlation before sending. The existing computed static viewid is unused and remains unchanged; use the concrete request UUID for consistent matching.
- addSeries guards mount and repeated request initiation, calls the same typed API with Work's scanner arguments, and displays its success instruction or existing transport/API errors. Keep the form usable while scanning; no global loading overlay. After acknowledgement, another click starts a new request and invalidates the previous scanner result.
- Add requestMobileScannerComplete to the existing WS switch. Decode with the existing helper, validate event ID and captured custCatchID, consume the IDs before applying the result, and trim only outer whitespace/newlines from text. Preserve arbitrary serial formats (including internal spaces, case and hyphens); do not reuse Work's folio/URL conversion. Empty scans report an error and leave the current serial untouched.
- Make the existing WS subscription weak and mount-guarded so the new handler cannot retain the closed form or process events after removal. Do not remove listeners from the shared app-wide WS state. Retain all existing media branches.
- Centralize local scanner reset for failure, matching completion and removal. Weak/API mount/request/session guards reject old results. A completion before its API acknowledgement consumes the request, making the later acknowledgement harmless. Removal continues all existing owned-state cleanup.
- Sync one verified UI architecture fact and a completed task archive record. No commit/staging.

## Plan review

Reviewed the exact user diff, existing serial input/icon, Work's request and completion paths, current RequestMobileCamaraRequst and scanner payload contracts, CreateAssetItemView's existing WS subscription/removal, and the create serial payload. The scanner completion provides eventid/text, so request UUID matching can isolate simultaneous forms and replays. Writing the existing serial state is sufficient to update the UI and preserve single/multi-item create behavior. Review accepted before source mutation.

## Verification

Run frontend parsing and the previously user-approved focused App build with existing pins/module cache. Review success/error, manual entry, empty scan, duplicate click/event, old/new requests, multiple forms, completion before acknowledgement, removal and session-change traces. Check source/doc task-relative diffs, added-line whitespace, source snapshots, git status/staging and unchanged Package.resolved. No test suite, live mobile notification/scanner session, server mutation or deployment.
