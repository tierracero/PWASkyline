# List asset items — updated location scopes

## PLAN (reviewed before source mutation)

- Request: adapt PWASkyline to the updated `TCFireSignal/CustAssets+ListAssetItems.swift`.
- Authority: `API-001`, `API-002`, `SWWEB-001`, `SWWEB-003`. API endpoint checklist is primary; UI checklist supports picker/caller edits.
- Contract verified in local TCFireSignal and GitHub main revision `726840464fdc2fd1ec390f06ca715cb4ae0edee7`. Store/warehouse cases now have `storeId` and optional `account`; account scope has account/store/subaccount-link filters. Request/response structs and POST route are unchanged.
- Local server source confirms store/warehouse scope filters `owningAccount` by the supplied account, and nil means unowned items. Subaccount scope filters `owningSubAccount`, not current custody location.
- Source scope: `Sources/App/Snippits/TripControler/TripControler+CreateTripView.swift` and `Sources/App/Snippits/SearchComertialAsset.swift`. Keep the already-compatible API wrapper untouched.
- Documentation scope: owning API/UI architecture facts and `.agent/TASKS_ARCHIVE.md`. No new module, path or architecture boundary; existing architecture index/source map remain valid.
- Preserve existing working/staged edits using file baselines and git-status evidence. No dependency, backend, package-lock, generated-output, theme, cache, staging, commit or push mutations.

## IMPLEMENT

1. Construct store/warehouse scopes with the new labels and the trip's `account.id`.
2. Match both associated values in the picker and validate current location/ID plus owner for store/warehouse items.
3. Validate subaccount results with `owningSubAccount` to preserve server-selected owned items even when their current custody differs.
4. Keep unsupported account picker scope rejected, existing `.available`/department/category request filters, selection identity, popup frame, cancellation and late-response guards.
5. Synchronize docs with implemented behavior.

## AUDIT / completion criteria

- Review all app usages of shared listing types and the task-only diff against baselines.
- Trace store/warehouse account parameters and picker predicates against the shared contract and server query.
- Confirm nil-account and subaccount ownership semantics, unsupported scope rejection, and unchanged transport/selection flow.
- Inspect added-line whitespace and focused `git diff --check`; compare status/staging with baseline to confirm intended scope only.
- No builds, compiler commands or tests: user requested non-build checks only. Runtime behavior remains unverified.

## Review

Plan reviewed against the shared types, server source, and all three app consumers. Changes are limited to adapting existing scoped listing behavior; no new API abstractions or UI flows are needed.

## AUDIT results

- App-wide searches found the wrapper, one trip caller, and the picker as the complete listing-type consumer set. Both changed enum constructors and picker patterns now match the shared associated values.
- Store/warehouse request scopes use `account.id`; picker predicates match backend current location/ID and `owningAccount` equality. Optional equality also preserves nil-account/unowned semantics. Subaccount picker predicate matches the backend's `owningSubAccount` query, including different current custody.
- Available-status filtering, nil department/category filters, duplicate item exclusion, concrete item UUID, callback guards, unsupported picker scope rejection, cancellation/cleanup, and the prior modal frame are unchanged in the task-only diff.
- API wrapper, `Package.swift`, and `Package.resolved` match byte-for-byte baselines. The resolved revision already contains the shared enum contract; no dependency resolution was run.
- All task-only added lines are whitespace-clean. Focused documentation `git diff --check` passes. Controller tracked diff reports whitespace on lines 223 and 1844; both lines are identical to the pre-task baseline and were preserved.
- Final git-status comparison reports only task evidence additions; existing staging is unchanged. Source/docs were already dirty before this task and the saved task-only diff isolates the edits.
- Evidence: `list-asset-items-account-scope-baseline/`, `list-asset-items-account-scope.diff`, `list-asset-items-account-scope-status.txt` in this directory.
- Shared-package note: its conditional CodyFire convenience function still uses the legacy `type`/`id` initializer. The app wrapper directly constructs the current shared request and does not use that helper; no external package source was modified.
- No builds, compiler commands, tests, or browser execution were run, per user preference. Compilation and runtime behavior remain unverified.
