# Asset items contract migration

Reviewed plan — 2026-10-05

Primary skill: API endpoint checklist; supporting Swift Web UI checklist. Architecture IDs API-001/API-002 and SWWEB-001/SWWEB-003. No boundary-rule changes.

## Shared-package review

- Reviewed the latest three local TCFireSignal commits: 998dad6, e7a1ec3, cd0b774. The latter two merchandise/subaccount contracts are already reflected in the app.
- 998dad6 replaces ListAssetItemsRequest(type:id:) with currentLocation: ListAssetItemsType, departmentId: UUID?, categorieId: UUID?, status: ListSubAccountItemsStatus. Response remains ListAssetItemsResponse.items.
- The same commit renames GetAssettemRequest/Response to GetAssetItemRequest/Response and CustAssetsComponents.LocationType to GetAssetItemLocationType. Its CodyFire detail helper uses the exact route GetAssetItem.
- SearchAssetRequest/Response are empty placeholders; the file's gated helper duplicates updateAsset. The gated listAssetItems helper still constructs the removed type/id initializer. These shared-package issues are outside the local app patch; do not edit dependencies or invent a search contract.

## Scope and implementation

1. Sources/App/API/CustAssetsEndpoint/CustAssets+ListAssetItems.swift: expose all four new typed request arguments and pass them to the shared request. Preserve listAssetItems POST route and response/transport/error callbacks. No app callers exist for the old wrapper.
2. Sources/App/API/CustAssetsEndpoint/CustAssets+GetAssettem.swift: use getAssetItem as the app wrapper method, shared GetAssetItemRequest/Response, and exact GetAssetItem endpoint string. Keep the file path to avoid unrelated moves.
3. Sources/App/Snippits/CustAssetsView/CustAssets+AssetItemView.swift: update its sole detail request call and three response type annotations.
4. Sources/App/Snippits/CustAssetsView/CustAssets+AssetInventoryItemController.swift: update its explicit resolved-location state type to GetAssetItemLocationType; inferred payload location usage remains valid.
5. .agent/architecture/API_AND_BACKEND.md: synchronize resolved-location/detail names and document typed list filters.

Plan review: searches cover every reference to the removed model names and listing wrapper in App/Service. The changes preserve serialization through shared types (including warehose and categorieId spellings), avoid duplicate local models, and retain existing user edits. No asset-search UI, dependency edits, formatting, staging, or commits.

Completion: review task-only diffs against backups, shared request arguments/routes/decoding and all callers; check removed names and whitespace; confirm status and staged-index preservation. Builds/tests require explicit user confirmation and are not authorized.

## Audit result

- Reviewed the task-only patch in asset-items-contract.diff. Listing now accepts exactly currentLocation/departmentId/categorieId/status and constructs the shared request with those arguments. The list response, route, POST transport, and nil-on-transport/decoding-failure behavior remain unchanged. There are no existing app list callers requiring migration.
- Detail wrapper now exposes getAssetItem and uses the exact shared GetAssetItem route plus renamed request/response models. Migrated its sole caller, three response annotations, and the explicit inventory resolved-location state type. Removed model/method/type-name searches across Sources returned no obsolete references. Preserved the pre-existing AssetItemView EOF convention.
- GetAssetResponse.AssetsItemPayload location is inferred elsewhere and now matches the updated explicit inventory state type. Existing merchandise type/source-ID propagation and subaccount endpoints already conform to e7a1ec3/cd0b774.
- All five task-only whitespace comparisons emitted no diagnostics (no-index exit 1 indicates differing files). Status comparison shows only intended existing-source modifications and new task artifacts. Cached binary diff SHA-256 is unchanged; preserved staged changes and unrelated working-tree files.
- Upstream findings: the CodyFire-only list helper still calls the removed ListAssetItemsRequest(type:id:) initializer; SearchAsset.swift contains a duplicate updateAsset helper and empty search models. TCFireSignal's manifest enables CodyFire for iOS/macCatalyst, so these conditional-source issues should be corrected in that package for those targets. Dependencies were not edited.
- Builds/tests/live API checks were not run because repository instructions require explicit confirmation. Compilation, backend route availability, and runtime behavior remain unverified.
