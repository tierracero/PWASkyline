# Asset inventory progressive rows and search — 2026-10-09

## Request and verified behavior

AssetInventoryController currently creates every AssetInventoryItemController synchronously through ForEach. Replace this with progressive UI rendering like OrderCatchControler.asyncAddOrder (0.01-second first row, 0.03-second following rows), and implement the search TODO in AssetView's inventory header.

## Reviewed implementation

- Source scope: CustAssets+AssetInventoryController.swift and CustAssets+AssetView.swift. IDs: SWWEB-001, SWWEB-002, SWWEB-003. Preserve the API payload, complete parent items array, total count, row controller/open behavior, other fields and existing user edits.
- Controller owns a UUID render generation and plain rows Div; no ForEach over the full payload. Each timer constructs/appends only the next row. Changes/replacement/removal invalidate older work, and weak captures plus isInDOM guard ignore closed views.
- Accept a shared search State with an empty default. Items updates schedule a refresh; search changes debounce 0.2 seconds. Filter by normalized folio/name/optional serial using the existing pseudo convention. Clearing restores all items. Distinguish empty inventory from no matching results.
- AssetView owns one search state/field and one persistent inventory controller reused during reload/redraw. This avoids accumulating child listeners on shared parent states. Weak child state subscriptions are registered once; child removal cancels rendering without removing parent-owned listeners. Parent removal clears items/search listeners it owns.
- Add a crystal UTextField at the header TODO, preserving existing controls/layout and total inventory count. No server searches or new asset mutations.
- Sync a verified architecture fact and completed-task record. No path/target/dependency/architecture-boundary changes or commits/staging.

## Completion and verification

Review source traces for initial large payloads, empty inventory, case/accent-insensitive folio/name/serial searches, typing/debounce/clearing, source replacement/appends, reload during rendering, no-match results and removal/replacement. Confirm old timers cannot append stale rows and the full parent inventory stays unchanged by filtering. Run frontend parsing and the previously approved focused App build with current pins/cache; no test suite or live server mutations. Review baseline-relative diffs/whitespace, source snapshots and git status/staging. Record browser performance validation limits.

## Plan review

Reviewed order row rendering, the inventory's sole AssetView constructor, header count, create-inventory reload callbacks, Web innerHTML recursive removal and shared State listener ownership. Yielding per row directly addresses the synchronous DOM cost while retaining existing row construction. Persistent controller/field ownership and render generations cover redraws, updates and removal without modifying shared API/business data.

Reload review: Web recursive removal clears descendant parent references and ownership arrays, while re-appending a reused root only mounts that root. Before mutation, amend the implementation to extract the existing inventory wrapper into a helper and rebuild it on controller reattachment when list.superview is nil. This restores the same DOM structure and cleanup ownership without creating a new controller or extra shared-state subscriptions; initial mount retains its already connected content.

## Build-cache recovery review

The focused build failed before compilation because Package.resolved pins TCFireSignal 531d411e081d689cfe2efb6301882c6d358b1ce2, while the local checkout still uses b19e06f11391d473a88b028d34db43432d490b36 and the required tree is absent. Restore only the exact already-pinned commit into its SwiftPM repository cache, then repeat the focused build with automatic resolution disabled. Snapshot Package.resolved before recovery and verify its contents remain unchanged. This is dependency-cache repair for the previously approved build, not a version/contract update. If the revision is unavailable, retain the completed UI source and report compilation blocked; do not choose another pin or stack speculative source changes.
