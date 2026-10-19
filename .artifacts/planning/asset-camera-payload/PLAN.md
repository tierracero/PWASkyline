# ASSET-CAMERA-PAYLOAD-001 — reviewed implementation plan

## Evidence and scope
CreateAssetItemView records remote camera previews in imageRefrence (event UUID) and imageOrder (view UUID), but not uploadFileControler (view UUID). create() reads only the latter. Two completed photos therefore yield an empty images array. Cancel/failure also removes the event map using the wrong UUID.

Primary skill: Swift Web UI; supporting skill: WebSocket. IDs: SWWEB-001/002/003, WS-001/002, SEC-001. No architectural boundary, dependency, server, wire-contract or global cache change.

Source scope: Sources/App/Snippits/CustAssetsView/CustAssets+CreateAssetItemView.swift. Documentation scope: UI architecture verified facts, project-memory authority reference and task archive. Existing store selection, serial scanning, local file upload, batch creation and user edits stay intact.

## Implementation
1. Replace duplicated remote Selected/Initiate view construction with a helper registering each capture once in event routing, the upload registry and ordered payload membership.
2. Scope new remote cards to a mounted form that requested the camera in the current session. Retain eventid:nil and multipleTakes:true. Terminal IDs suppress duplicate/late Selected/Initiate/Complete/progress events. Completion must support a missing earlier Selected/Initiate when destination is assetItem.
3. Completion stores the original file and marks readiness explicitly, independently of thumbnail loading. Preserve current media preview and avatar choice behavior. Known remote async completion remains supported; crop events may still update retained cards.
4. User removal, camera failure and cancellation clean the event map, upload registry and ordering with their correct keys; ignore later resurrection. Removal disables remote reception. Existing creation guard now sees pending camera rows and prevents premature empty/partial submission.
5. Trace two-photo payload creation, ordering, duplicate/late events, mixed local/remote uploads, pending/fail/cancel/removal and single/batch forwarding. Parse source, run the previously approved focused App build without dependency resolution, review task-relative diff and status/pin/staging preservation, then update verified docs.

## Self-review before mutation
Plan matches the proven registry defect and required adjacent cleanup. Shared API expects images [{fileName,isAvatar}]; no encoding change is needed. Event UUIDs and view UUIDs remain separate and are explicitly mapped; do not alter ImageGeneralView or its private event handling. Destination/session guards prevent completion for other upload types. No actual customer upload or create request will be run. Focused builds are already explicitly approved; no test suite authorization is assumed.

## Completion evidence
Successful parsing and focused build where feasible; reviewed source trace and task-relative diff; only scoped mutations, no staging/commit, unchanged lockfile. Live camera/browser verification must be reported as unrun.
