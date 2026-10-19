# Edit asset-item details and save supported fields

Date: 2026-10-14

## PLAN

Main PWASkyline checkout: `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`. Backend: `/Users/victorcantu/Development/ServersSwift/SkylineServer`. Preserve all pre-existing edits. Use the repository UI/API checklists for PWASkyline and Vapor endpoint checklist for SkylineServer.

User confirmed the existing API scope: editable name, serial, current cost, section and subsection; folio, purchase folio, acquisition cost and status remain read-only. Current custody type/name and service-card activation remain the existing separate workflows.

Architecture IDs: PWASkyline SWWEB-001/002/003, API-001/002; SkylineServer API-001/002/003, DATA-002/003.

1. In `CustAssets+AssetItemView.swift`, hydrate form state from the loaded item, replace the supported static labels with crystal text/select controls, retain unsupported metadata read-only, and add `Guardar Cambios` using the existing crystal action class.
2. Load section/subsection choices using existing wrappers in the current classification scope. Prefer the existing section/subsection owner; otherwise derive it from the resolved custody location. Use customer architecture reads for customer scope and `loadStore`/`getAssetsSection` for store/warehouse scope. Existing IDs remain selected (including unresolved-record placeholders) if choices cannot be loaded; changing section clears its subsection. Do not change commercial ownership or actual custody.
3. Validate a nonempty name, exact nonnegative cent conversion, UUID selections and subsection-parent membership. Disable editing/saving while loading or saving; guard callbacks by mount, session and editor generation. Submit the loaded UUID and explicit nullable classification IDs to the existing `API.custAssetsV1.updateAssettem`. `.ok` with a nil audit-note payload is a valid no-op response. Reload the saved record and notes through the concrete UUID after success; failed requests preserve the editor values.
4. The inspected SkylineServer update handler currently builds `parameters` but never executes an update. Add the missing tenant-scoped item update before note insertion. Keep the existing shared request/response, route, auth and no-op behavior. Retain its original session validator, then open an explicit transaction for row locking, classification validation, mutation and audit note. Validate changed classification references in the tenant and ensure the subsection belongs to the submitted section; keep helper logic fileprivate on the endpoint type. Preserve non-editable metadata and avoid lifecycle/custody changes or new Kardex events.
5. Synchronize verified implementation facts and task records in the existing client/server docs. No new source paths, migrations, contracts, dependencies, generated output, or shared-package changes.

Completion: supported values load into editable controls, Save persists the selected values without clearing unchanged classification IDs, the UI refreshes from server data, and metadata/custody/ownership/service-card behavior stays separate.

## Plan reviewed before source mutation

Self-reviewed against both repositories' PLAN → IMPLEMENT → AUDIT rules. Verified the exact PWA wrapper, TCFireSignal DTO, GetAssetItem location cases, existing hierarchy wrappers and server update patterns. The necessary persistence correction was reported to the user before expansion; the user selected the supported-field scope. No independent reviewer is required and no subagents are authorized.

Pre-application review adjustment: the connection-aware session-validation overload matches usernames case-sensitively, while the original overload compares lowercased names. Keep the original auth call and start the write transaction after validation to preserve that behavior. The shared monetary display formatter uses Float64; hydrate the editable cost directly from Int64 magnitude/division/remainder so unchanged large amounts retain every cent. Two newly reindented blank-line whitespace findings were corrected in the staged handler before application.

Prepare baseline-relative patches in the writable worktree, review them, then apply through filesystem escalation with optimistic content guards. Audit source mappings, lifecycle/error/no-op paths, exact-cent conversion, query schema/ID filters, diff whitespace/application and repository statuses. Builds/tests/full compiles and database/browser execution are not authorized. No commits or staging.
