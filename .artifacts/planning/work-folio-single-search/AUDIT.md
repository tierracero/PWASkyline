# Work folio single submission audit — 2026-10-09

## Result

The overlapping immediate Enter and delayed key-up searches were corrected in WorkViewControler.swift. The controller now owns one current debounce generation; older timers are ignored after a subsequent input edit, any search submission, or removal. Enter/NumpadEnter and ignored keys do not enqueue automatic lookup timers. Automatic submission passes the captured normalized code and immediately clears the field, so a subsequent Enter cannot resubmit it. Empty searches return before minimizing the newly opened result. Fallback result views use the submitted query snapshot.

## Changed files

- Sources/App/ViewControlers/WorkViewControler.swift: search state, key-up handling, removal invalidation, searchFolio entry and fallback query snapshot.
- .agent/architecture/SWIFWEB_APP_ARCHITECTURE.md: verified search event behavior and runtime validation limit.
- .agent/TASKS_ARCHIVE.md: completed task record.
- .artifacts/planning/work-folio-single-search/: reviewed plan, baseline snapshots, source/event reviews and validation logs.

## Verification

- Swift syntax parsing passed with exit 0 and an empty parse.log: `swiftc -frontend -parse Sources/App/ViewControlers/WorkViewControler.swift`.
- The previously approved focused final App build passed with exit 0: `CLANG_MODULE_CACHE_PATH=/private/tmp/pwaskyline-get-trip-module-cache SWIFTPM_MODULECACHE_OVERRIDE=/private/tmp/pwaskyline-get-trip-module-cache swift build --disable-sandbox --target App --jobs 4 --skip-update --disable-automatic-resolution`.
- Final log: build-verified.log, `Build of target: 'App' complete! (142.10s)`. Earlier compilation snapshots also passed. Existing warnings remain for cache permissions, missing tutorial resource, deprecated build option and the unrelated unused level variable.
- EVENT_REVIEW.md traces the actual InputText/Web handler subscription and debounce transitions; these are source review, not runtime test results.
- Reviewed task-only source.diff and architecture.diff against pre-mutation snapshots. All formatted-code lookup branches, API wrappers, mobile-scanner dispatch, caches, themes and startup behavior remain unchanged.
- Baseline-relative `git diff --no-index --check` on the authored source snapshot produced no whitespace diagnostics (exit 1 indicates the intended file differences). Concurrent edits subsequently added blank-line spacing only in the key-up handler; concurrent-spacing.diff confirms no semantic change from the compiled snapshot. These edits were preserved, including two whitespace-only lines now reported at 1120/1122. Latest source parsing passed again (parse-current.log); another build was unnecessary for spacing alone. Documentation whitespace checks are clean.
- Final status/staging comparison confirms no new changed paths beyond task artifacts; previously modified source/docs and untracked user work are preserved. Package.swift/Package.resolved have no diff; staged names are unchanged and empty.

## Scope and limits

No test suite, browser, hardware-scanner or server mutation was run. Compilation and source evidence confirm the fix builds and removes the identified duplicate event paths; a live browser/scanner reproduction remains unverified. No commits, staging, dependency updates or public asset regeneration were performed. Architecture IDs/ownership and file layout are unchanged, so the architecture index/source-map routers require no changes.
