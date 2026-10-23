# ManagePOC staged camera completion

Reviewed: 2026-10-23. Primary checklist: Swift Web UI; supporting WebSocket. IDs: SWWEB-001/002/003, WS-001/002.

## Evidence and cause

The user-provided console sequence contains selected/progress followed by a first requestMobileCamaraComplete with image dimensions 0x0, several asyncFileUpdate processing stages (ending in Generate mobile image), then another requestMobileCamaraComplete for the same capture with valid 1200x1600 dimensions and the final media ID. Current code marks the first completion terminal, allows asyncFileUpdate to replace its cleared status, and rejects the valid final completion via finishedRemoteCameraEvents.

## Reviewed implementation

Keep zero-dimension remote image completions pending; do not assign temporary media metadata, load a premature thumbnail or select its avatar. Complete only when the remote image has positive dimensions. Apply the same terminal/readiness rules to the alternate asyncFileUpload completion path for already registered remote captures while retaining local upload behavior. Mark a completed remote image loaded, and ignore later progress/async upload duplicates for terminal captures so processing cannot reappear or overwrite final metadata. Keep cancellation/removal terminal and preserve the existing mounted/request checks and incoming capture UUID.

Scope: ManagePOC camera completion/processing handlers plus owning UI fact, project memory and task archive. Preserve other user edits, including the currently modified initiate block; no server/schema, image-container, asset-form or global event changes.

## Audit

Review the supplied event sequence against the updated handlers, final-first and async completion ordering, late updates/cancel/duplicates and ordinary local uploads. Focused task-relative diff, whitespace/status evidence only. Builds/tests/live uploads require confirmation and will not run. Do not copy raw console payloads or connection information into task evidence. No commit.
