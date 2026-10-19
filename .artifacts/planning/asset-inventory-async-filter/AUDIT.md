# Asset inventory progressive rendering and filter audit — 2026-10-09

## Result and scope

CustAssets+AssetInventoryController.swift now uses a plain list and schedules creation of one AssetInventoryItemController per callback (0.01 seconds for its first row, 0.03 thereafter), following the existing order folio rendering pattern. UUID generations, weak capture and DOM guards cancel stale work after data/query updates or removal. Search-state changes debounce 0.2 seconds.

CustAssets+AssetView.swift now has a scoped UTextField in the inventory header and reuses one inventory controller/field across reloads. Filtering matches normalized folio, nullable serial or name without mutating the complete source items/count. Empty inventory and no matches have different messages. Shared child subscriptions are weak; parent removal clears owned item/search listeners. Controller reattachment rebuilds the same wrapper when Web recursive removal has cleared the list parent, preserving descendant cleanup ownership.

Other changes are the verified architecture fact, completed-task record and this transient evidence directory. Existing row opening, create-inventory API/reload behavior, data models, themes, source layout and architecture boundaries were preserved. No SourceMap/architecture-index update is required for unchanged paths/ownership.

## Verification

- Both source files passed frontend syntax parsing with exit 0; parse-final.log is empty.
- Final focused App build, already authorized by the user, exited 0: `CLANG_MODULE_CACHE_PATH=/private/tmp/pwaskyline-get-trip-module-cache SWIFTPM_MODULECACHE_OVERRIDE=/private/tmp/pwaskyline-get-trip-module-cache swift build --disable-sandbox --target App --jobs 4 --skip-update --disable-automatic-resolution`. build-final.log ends with `Build of target: 'App' complete! (79.28s)`. An earlier implementation snapshot also compiled successfully in 85.74 seconds. Existing cache/resource/deprecation/unused-value warnings remain.
- Initial build could not check out the already-pinned TCFireSignal commit 531d411e081d689cfe2efb6301882c6d358b1ce2 from the old local cache. Default-sandbox fetch was blocked by GitHub DNS; approved network fetch restored exactly that commit. No dependency version was chosen/changed. Package.resolved matches Package.resolved.before byte-for-byte after fetching and both builds.
- Reviewed inventory.diff/asset-view.diff against pre-mutation snapshots; after snapshots match the final sources. Source/document baseline-relative whitespace checks are clean.
- EVENT_REVIEW.md traces actual source behavior for large/empty inventories, normalized filtering, clearing, rapid typing, replacement/appends, creation reloads, recursive removal/reattachment and listener ownership. These are source traces, not runtime tests.
- Final status comparison shows only the intended previously-clean AssetInventoryController added to modified paths; AssetView/docs were already modified and task-only diffs preserve their earlier edits. Staged names remain unchanged and empty. No commits, staging or public asset regeneration.

## Practical limits

No test suite, running browser performance check or live server mutation was run. Expensive row/DOM construction now yields between browser event-loop callbacks; filtering the snapshot and clearing prior DOM still run synchronously. Actual frame responsiveness, large-list throughput and search-field wrapping remain unmeasured. The user-requested order-row rendering pattern is implemented without adding background threads or viewport virtualization.
