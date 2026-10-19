# Registration store — source flow review

These are source/contract traces, not live browser or server tests.

## Context preservation matrix

| Incoming context | Chosen store | Callback/child/API context |
|---|---|---|
| .store(S0) | S1 | .store(S1); store mode retained and relation/store identity becomes S1. |
| .warehose(S0) | S1 | .warehose(S1); warehouse mode retained and physical store snapshot becomes S1. |
| .account(account: A, store: S0) | S1 | .account(account: A, store: S1); original customer/ownership record and relation ID remain A. |
| .subAccount(subAccount: C, store: S0) | S1 | .subAccount(subAccount: C, store: S1); original subcustomer/ownership record and parent-account classification ID remain unchanged. |

Shared latitude/longitude properties derive from the selected physical store in every case. Helpers are client-only computed methods and add no Codable/wire fields.

## Entry and selector

- Options come from the existing store cache, sorted by name. If the embedded base store is absent it is appended; if present, the cache record is used. The base UUID is the initial selected state. Option.selected marks the matching option on population; Web Select's native change handler merges the selected UUID into that state.
- The selector uses USelectField under the existing .assets crystal root, so shared native-select/option dark styling applies. It carries a required field label and accessible name.
- Invalid units retain the existing error. Missing/unknown store ID rejects progression. The existing numeric lat/lon prerequisite now validates the chosen store; an invalid old base store no longer prevents selecting a valid replacement.
- Removal clears owned folio/unit/selection listeners; detached save calls do nothing. No shared store/session cache is modified.

## Single item

Initiate.save resolves the concrete store and calls callback(folio, units, originalType.registering(in: store)). The sole AssetView initiation callback receives registrationType and passes it to CreateAssetItemView(createType: .singleItem). The child shows registrationStore.name and retains its immutable viewType. Its existing createAssettem call submits type: viewType, so the selected store snapshot reaches the shared request directly.

## Batch

AssetView passes registrationType to CreateAssetMultipleItemView. Its summary shows registrationStore.name. addItem passes the same viewType to every CreateAssetItemView(createType: .multiItem), including subsequent staged items. Child callbacks return item objects without changing context. The batch's existing final createAssettem call submits type: viewType once for all collected items. No fallback to the parent's original store or custCatchStore occurs.

## Classification and preserved behavior

The shared relationId/relationType definitions continue to drive child classification selection and creation: store/warehouse contexts use the selected store ID, while customer/subcustomer contexts retain their owner classification scope. Existing section/subsection propagation, cost/serial/media/warranty inputs, single/batch payloads, inventory reload callbacks and user edits remain in the task-relative diff. The store selection does not create or modify a store.

## Recovery and correction

The lockfile already pinned two uncached revisions. Exact pinned objects were fetched and their shared enum/request/store contracts re-reviewed without changing pins. One unsupported Select.value(...) preset was caught during compilation; after reviewing native Select state binding and Option.selected, only that preset was corrected under the amended plan. Final sources were parsed again before the final build.
