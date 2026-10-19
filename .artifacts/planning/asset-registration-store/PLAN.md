# Asset registration store selection — 2026-10-09

## Scope and completion criteria

Complete InitiateAssetItemView's store TODO. The chosen physical store must reach CreateAssetItemView (single or each staged batch item), CreateAssetMultipleItemView and finally createAssettem's existing type argument. Default to the store embedded in the current view type. Preserve store/warehouse mode and any customer/subcustomer ownership. Show the registration store in child forms/summaries.

Source scope: CustAssets+InitiateAssetItemView.swift, CustAssets+AssetView.swift, CustAssets+CreateAssetItemView.swift and CustAssets+CreateAssetMultipleItemView.swift. IDs: SWWEB-001, SWWEB-002, SWWEB-003, API-001, API-002. No request/wire/API wrapper, dependency, generated asset, theme, routing or global cache changes. Preserve all existing user edits and prior serial scanner/upload/inventory behavior.

## Reviewed implementation

- Add client-only registrationStore and registering(in:) adapters for shared InitiateAssetItemViewType. Handle store, warehose, account(account:store:) and subAccount(subAccount:store:) explicitly, preserving the enum case and ownership records while replacing only the physical store snapshot. Computed client helpers add no serialized fields.
- Initiate owns a selected store UUID string and a sorted snapshot of the existing stores cache, retaining the embedded base store if absent from the cache. Use the cached record when already present. Prefill the embedded store's ID and add a required crystal USelectField in the TODO slot. Populate/reapply selection on mount and clear owned state listeners on removal.
- Extend the initiation callback with the resolved registration view type. Validate units and a concrete selected option; apply the existing numeric lat/lon map prerequisite to that chosen store. No additional coordinate/permission requirements are introduced.
- Remove AssetView's old pre-selection map switch, which can block choosing a valid replacement store. In the sole initiation callback, forward the returned registration type into both single and batch constructors instead of the original parent context.
- The batch already forwards its viewType to each child and its final createAssettem request; single create also already submits viewType. Preserve that existing propagation rather than introducing a duplicate store argument/wire field.
- Add a registration-store name to the single form and batch information panel, including account/subaccount flows where relationName names the owner rather than physical store.
- Update verified UI/API facts and completed task archive. No commit/staging.

## Plan review

Reviewed the exact TODO/user diff, all initiation/single/batch call sites, the existing store picker/cache and crystal native-select patterns, the selected-store map guard, classification filtering and the pinned shared create contract. Confirmed type already embeds a CustStore in every case; latitude/longitude derive from that physical snapshot, while account/subaccount relation IDs retain their owner. Batch children and both final requests reuse viewType unchanged. Updating the initiation callback and parent forwarding is sufficient to carry selection end-to-end; no backend support or API change is required. Review accepted before source mutation.

## Verification

Run frontend parsing for all four sources and the previously user-approved focused App build with current pins/cache. Review all four enum cases, unchanged/default choice, alternative store, missing choice, invalid selected-store map, invalid original store with valid replacement, single/batch propagation, staged item loops, displayed store, classification scope and preserved user edits. Confirm both API calls still submit the selected type and no code falls back to custCatchStore/original viewType. Review task-relative source/doc diffs, added-line whitespace, status/staging and unchanged Package.resolved. No test suite, live browser/server asset creation, generated outputs or deployment.

## Build-cache recovery review

The focused build stopped before compilation because two already-pinned dependency trees are absent: TCFundamentals 97229faa07b1fcb776c623b002a474bd95e906d1 and TCFireSignal eabefeb658dfe26409a9c93278bf5c6f80b05e01. Package.resolved still matches the task baseline; no pin was changed by this task. Restore only these exact revisions into their SwiftPM repository caches, let the focused build restore the pinned checkouts with automatic resolution disabled, and recheck the updated shared creation/type/store contracts. This is authorized build-cache recovery rather than a dependency-version change. If contract assumptions changed, stop and amend the source plan before further implementation; do not select another revision or edit the lockfile. Recovery reviewed before cache mutation.

Both exact commits were fetched successfully. Before retrying, reviewed the pinned creation contract through the repository object: all four enum cases, associated store/owner records, latitude/longitude derivation and CreateAssetItemRequest.type are unchanged. The pinned CustStore still provides UUID id, String name and optional String lat/lon. Source assumptions remain valid; no source or lockfile changes are needed for recovery.

## Native select correction review

The restored build reports an unsupported storeSelect.value(selectedStoreId) call: Select.value is a read-only String property, not a method. Stop source work and revise only initial-selection setup. Reviewed Web's Select initializer/change handler (merges its text state with the injected state and reads native value on change) and Option.selected(Bool). Mark the matching option selected during population, including the empty placeholder when applicable, and remove the invalid Select call. This keeps visible/default/state selection aligned without a DOM bridge or new callback. Await the failed build's completion, apply this narrow correction, parse the four sources and rerun the focused build. No speculative or unrelated fixes. Correction reviewed before mutation.
