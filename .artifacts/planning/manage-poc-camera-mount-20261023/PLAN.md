# ManagePOC continuous camera event reception

Reviewed: 2026-10-23. Primary checklist: Swift Web UI; supporting: WebSocket. IDs: SWWEB-001/002, WS-001/002.

## Verified cause

ManagePOC already requests multipleTakes:true/eventid:nil and creates/reuses one ImagePOCContainer per incoming selected/initiate event UUID. Both its WebSocket listener and remoteCameraImage helper require isInDOM. Its didAddToDOM override omits super.didAddToDOM(). Web's BaseElement.didAddToDOM is what sets private(set) isInDOM=true. CreateAssetItemView correctly calls super. Consequently the POC listener exits before handling any capture events.

## Scope and completion

Add the missing super.didAddToDOM() call before the existing product-brand loading branch. Preserve camera event registration, duplicate/terminal guards, manual editing, local uploads, save metadata and all existing user edits. Synchronize the owning UI fact, memory and task archive. No protocol, model, server, global WebSocket or asset-form mutation is needed.

Audit the exact task-relative diff and framework lifecycle path; record whitespace/status results. Builds/tests are not authorized and will not run. No commit.
