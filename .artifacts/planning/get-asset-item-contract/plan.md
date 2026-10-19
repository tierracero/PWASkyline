# getAssetItem contract alignment

## Reviewed plan

Scope: asset detail API wrapper, AssetItemView identifier type/UUID guards, inventory/detail caller and Work folio-search caller, owning API architecture verified fact. IDs API-001/002 and SWWEB-001/002/003. No boundary, route registration, package or generated output changes.

Verified TCFireSignal 88a8faa: lowercase getAssetItem POST route, GetAssetItemRequest(itemId: MultipleIdentifier), MultipleIdentifier cases id(UUID)/folio(String)/serviceCard(String). GetAssetItemResponse still returns parent asset, concrete item, images/notes/location/classifications. Package.resolved already pins the updated revision. The user changed the detail initializer to HybridIdentifier and retained the resolved assetItemId as an optional UUID. The wrapper and two view callers still use the old signature. The Work caller is inside folio search and references an out-of-scope item; its correct available identifier is the typed search term. User has now supplied assetItemId = payload.item.id; preserve it.

Implementation: wrapper takes itemId:MultipleIdentifier and constructs the shared request. Detail view stores/accepts MultipleIdentifier, allowing all three lookup cases. Inventory opens .id(item.id); Work asset/assetDocument branch opens .folio(term). Keep all user service-card/layout changes, preserve the resolved UUID assignment, and add returns to existing missing-ID guards so Kardex/card mutation only accepts a concrete loaded UUID. Correct existing uppercase route doc to verified contract.

Completion: all getAssetItem/detail call signatures match the shared request, no obsolete parameter labels/HybridIdentifier remain in this path, loaded UUID drives downstream Kardex and card operations, callbacks/decoder/transport unchanged. Review source snapshots/whitespace/status and staged hash. Static-only checks; no builds/tests/browser execution/package resolution. Reviewed scope is focused and directly resolves the user's partially migrated callers.

## Audit

- Sources/App/API/CustAssetsEndpoint/CustAssets+GetAssettem.swift: no added whitespace issues
- Sources/App/Snippits/CustAssetsView/CustAssets+AssetItemView.swift: no added whitespace issues
- Sources/App/Snippits/CustAssetsView/CustAssets+AssetInventoryItemController.swift: no added whitespace issues
- Sources/App/ViewControlers/WorkViewControler.swift: no added whitespace issues
- .agent/architecture/API_AND_BACKEND.md: no added whitespace issues
- Obsolete getAssetItem/view argument labels: none
- Wrapper/view both use MultipleIdentifier: True
- Resolved UUID assignment present: True
- Both downstream UUID guards exit: True
- TCFireSignal resolved revision: 88a8faa09b02baf60182dc421b9ea31cbb414c12
- Unexpected status additions: []
- Removed user status paths: []
- Staged diff unchanged: True
- Snapshot diff reviewed: source changes limited to new identifier/payload labels, matching caller identifiers and missing-ID exits. Existing user service-card/UI changes and the resolved UUID assignment preserved. Shared GetAssetItemResponse is still decoded directly, so parent asset/classification fields remain supported without a local duplicate. API documentation updated without boundary/path changes.
- No builds/tests/browser execution or package resolution performed under the existing static-only preference. Compatibility is source-reviewed; runtime responses remain unverified.
