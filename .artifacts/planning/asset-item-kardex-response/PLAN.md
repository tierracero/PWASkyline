# Asset-item Kardex response usage — 2026-10-09

## Reviewed scope
- Server: Sources/App/Endpoints/CustAssetsEndpoint/CustAssets+GetAssetItemKardex.swift.
- PWA: Sources/App/Snippits/CustAssetsView/CustAssets+AssetItemView.swift; review the typed GetAssetItemKardex wrapper (change only if needed).
- Shared contract: inspect TCFireSignal/CustAssets+GetAssetItemKardex.swift; missing-note/actor representation awaits the user's answer.
- Relevant architecture IDs: server API-001/API-002/API-003/DATA-002/DATA-003/SEC-003; PWA API-001/API-002/SWWEB-001/SWWEB-002/SWWEB-003.
- Required governance updates: owning API/UI verified facts and task status; no source layout changes.

## Implementation
1. Collect unique file, note, actor and typed location IDs from the returned page, then load tenant-scoped related rows in batches; skip empty ID sets.
2. Project persistent events into CustCommercialAssetsItemKardexObject preserving event/image ordering, IDs, status/context/source/timestamps/coordinates and existing pagination/integrity semantics.
3. Update the PWA event view to render resolved location names, note content, actor and evidence with the existing read-only MediaViewer.
4. Preserve all preexisting PWA edits and generated/dependency files.

## Completion / validation
- Re-scan all callers of getAssetItemKardex and usages of the new event object.
- Review empty pages, absent/deleted relations, each location case and ordered images, route/schema isolation and response keys.
- Review task-relative diffs, whitespace and final git status.
- Ask before builds/tests/compile checks as required by both AGENTS.md files; no live database changes or deployments.

## Review
The existing wrapper already decodes the updated shared response. Persistence remains unchanged. Page projection will not discard events with missing relations. One required contract decision (optional note/user vs display placeholders) is pending; dependent mapping will follow that answer.
