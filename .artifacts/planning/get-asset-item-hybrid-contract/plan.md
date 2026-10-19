# getAssetItem HybridIdentifier alignment

## Reviewed plan

Scope: getAssetItem API wrapper, AssetItemView property/initializer, Work asset folio-search caller, TCFireSignal Package.resolved pin, owning API fact. Preserve current user edits, including separated unsupported assetDocument case and loaded UUID/Kardex/card behavior. Inventory .id caller remains valid unchanged. IDs API-001/002, SWWEB-001/002/003. No boundary/path changes.

Verified TCFireSignal commit 823a0d94c62b82146896af3b23cf2b5f47732e87 changes only itemId type from MultipleIdentifier to HybridIdentifier in request/API, retaining lowercase getAssetItem route and shared response. Local HEAD and origin/main both identify that revision. TCFundamentals HybridIdentifier has id(UUID) and folio(String) only. Package.resolved TCFundamentals already matches current local commit; TCFireSignal still pins previous 88a8faa.

Implementation: change wrapper/property/initializer to HybridIdentifier; Work's existing .asset folio branch uses .folio(term) rather than unsupported .serviceCard(term). Update only TCFireSignal lock revision to verified origin/main commit without executing the package resolver; sync owning API fact for UUID/folio contract. No endpoint/path/response/transport or UI changes.

Completion: all affected signatures and cases match current shared source; pin identifies the reviewed shared commit and other pins are unchanged; review focused snapshot diff/whitespace/status/staged hash. Static-only validation, no builds/tests/browser execution/network/package resolution.

Review: latest package contract and callers inspected; focused plan implements the requested repeated contract update.

## Audit

- Sources/App/API/CustAssetsEndpoint/CustAssets+GetAssettem.swift: no added whitespace issues
- Sources/App/Snippits/CustAssetsView/CustAssets+AssetItemView.swift: no added whitespace issues
- Sources/App/ViewControlers/WorkViewControler.swift: no added whitespace issues
- Package.resolved: no added whitespace issues
- .agent/architecture/API_AND_BACKEND.md: no added whitespace issues
- Only changed dependency pin: ['tcfiresignal']
- TCFireSignal pin: 823a0d94c62b82146896af3b23cf2b5f47732e87
- Stale MultipleIdentifier/serviceCard cases in affected path: none
- Unexpected status additions: []
- Removed user status paths: []
- Staged diff unchanged: True
- Snapshot diff reviewed: source changes limited to three identifier declarations and Work lookup case; all other UI/UUID behavior preserved. Only TCFireSignal lock revision changes. Shared response/request route and transport remain unchanged.
- No builds/tests/browser/network/package resolution commands were run. Static declaration/case and lock-format review completed; compilation and runtime remain unverified.
