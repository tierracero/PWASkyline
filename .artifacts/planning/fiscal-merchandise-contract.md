# Fiscal merchandise contract migration

Reviewed plan — 2026-10-04

Primary skill: API endpoint checklist; supporting Swift Web UI checklist. Architecture IDs API-002/API-003 and SWWEB-001/SWWEB-003. No architecture boundary changes.

## Contract review

- TCFundamentals: bb71765 adds MerchandiseType (.merchandise/.commercialAsset) and required merchandiseType/optional merchandiseId to FiscalMercanciaProtocable and FiscalMercanciaItem. Decoding legacy records defaults the type and leaves the source ID nil. 9c44f37 shortens the temporary-location description; a733e77 makes CustSubAcct Payloadable.
- TCFireSignal: e7a1ec3 adds merchandiseType to TripMerchandise, with a .merchandise default. cd0b774 adds shared subaccount endpoints; 7840b75 adds location coordinates. The app already uses the latter two contracts.
- CreateTripView already creates independent item UUIDs with linked base IDs and forwards type/linked ID in its submission, retaining an item-ID fallback. Preserve these existing user changes.

## Scope and implementation

1. Sources/App/Snippits/AddCartaPorte/AddCartaPorteMerchendise.swift: pass the existing merchandiseType and merchandiseId when reconstructing the saved item. New manually entered merchandise defaults to .merchandise with no linked ID. Retain all existing fiscal fields, route, callback, and dismissal behavior.
2. Sources/App/Snippits/TripControler/TripControler+CreateTripView.swift: deleting a saved base removes selected .merchandise items whose linked source ID matches that base; retain item-ID matching only for legacy unlinked merchandise. Commercial assets must remain unaffected by saved-merchandise deletion. Individual row removal still uses item UUID.
3. .agent/architecture/API_AND_BACKEND.md: record the verified type/source-ID propagation and identity distinction.

Plan review: repository-wide searches found two FiscalMercanciaItem construction paths and one TripMerchandise mapping. The base-to-item helper and request mapping already use the new fields; only editor reconstruction and saved-base deletion need source changes. Preserve item UUID generation and existing selection behavior, with no new asset selection UI, dependency changes, staging, or commits.

## Completion criteria

- Review task-only diffs against pre-edit backups and all affected constructor/deletion/request paths.
- Run non-build whitespace/diff checks and confirm the staged index and unrelated work are preserved.
- Builds/tests require explicit user confirmation; do not run them without it.
- Record audit findings and compilation/runtime limitations here.

## Audit result

- Inspected the latest three local commits from each shared package. The current app already implements subaccount payloads, location coordinates, and the updated trip merchandise request mapping; preserved those existing changes.
- Reviewed both FiscalMercanciaItem constructors. The saved-base adapter retains a distinct item UUID and its source ID; the editor now supplies every required initializer argument and retains existing type/ID, including commercial assets and nil legacy IDs. New manual entries have .merchandise/nil metadata.
- Reviewed deletion behavior: linked merchandise matches its base UUID even when its item UUID differs; legacy unlinked merchandise retains item-ID matching; commercialAsset items are excluded. Individual card removal remains item-ID based.
- Reviewed the task-only diff recorded in fiscal-merchandise-contract.diff. All three before/after no-index whitespace checks returned exit 1 (files differ) with no diagnostics. The broad working-tree git diff --check reports whitespace already present in unrelated/user changes (including the unchanged account argument in CreateTripView); these were not modified.
- Git status comparison shows only the intended existing source/document changes and new task artifacts. A SHA-256 comparison of the complete cached binary diff confirmed the staged index is unchanged.
- No builds, tests, or live browser/API validation were run; explicit user confirmation is required by repository instructions. Compilation and runtime behavior remain unverified.
