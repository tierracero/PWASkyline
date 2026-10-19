# ManagePOC remote camera parity

## Reviewed plan

Scope: Sources/App/Snippits/ManagePOC/ManagePOC.swift, owning UI architecture verified fact, task evidence only. Preserve the user change multipleTakes: true and all unrelated edits. CreateAssetItemView is read-only reference.

Architecture IDs: SWWEB-001/002/003, WS-001/002. No boundary, endpoint, path or dependency changes.

Findings: Reference requests eventid:nil and creates placeholders on selected/initiate events. ManagePOC preallocates one view, cannot accept new event IDs, and complete/async uploads use auto-edit. Initiate/selected payloads contain only eventid; complete also contains destination. ImagePOCContainer uses viewid for editing/removal and product save iterates imageRefrence. Incoming event IDs must therefore equal remote card viewid, avoiding duplicate registration and broken manual editing. Only a visible manager that requested camera should create remote cards.

Implementation: Remove request-time placeholder and send eventid:nil. Create/reuse one remote card per incoming capture with the existing product callbacks and event ID as viewid. Handle selected/initiate/progress/complete/fail/cancel; retain terminal-event IDs so duplicates/delayed events cannot resurrect cards. On completion load without auto-edit, retain first-avatar behavior, and suppress auto-edit for remote async completions while preserving local upload settings. Ignore events after removal and use weak callbacks. Keep product relation/relatedid.

Completion: Static comparison proves multiple cards are stored once and available to product persistence/manual editor; cancelled/removed cards cannot return; remote direct and async completion never auto-edit; local file upload remains unchanged. Snapshot diff/whitespace/status and staged hash reviewed. No builds/tests/browser execution per user static-only preference.

Review: Contracts and existing card callbacks inspected; plan is focused and implementable without endpoint changes.

## Audit

- Local file-upload flow unchanged from user baseline: True
- Manual image-editor flow unchanged from user baseline: True
- Unexpected status additions: []
- Removed user status paths: []
- Staged diff unchanged: True
- Reference view diff is empty: True
- Focused whitespace review exit: 0
- Reviewed selected/initiate duplication: helper reuses by event ID without appending or resetting progress. Complete creates a missing product card if needed, records completion, and explicitly loads with edit:false; remote asyncFileUpload disables edit through event-set membership. Fail/cancel records terminal IDs before removal, and manual removal records the same card ID. Late progress/selected/initiate/complete cannot revive terminal cards. Manual crop and product-save loops still use the same imageRefrence ID.
- Visible/requested-camera gating limits creation to a manager that initiated remote upload; initiate/selected wire payloads carry only event ID, so this retains the reference protocol rather than adding new routing contracts.
- Owning UI verified fact updated; architecture boundaries and paths unchanged. No builds, tests, browser interaction, package resolution, or generated output refresh was run under the existing static-only preference. Multiple-capture browser/device behavior remains unverified.
