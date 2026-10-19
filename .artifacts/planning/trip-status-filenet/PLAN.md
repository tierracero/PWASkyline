# Trip-status evidence fileNet correction — 2026-10-09

## Reviewed scope
- SkylineServer: Sources/App/Endpoints/CustComertialTripsEndpoint/CustComertialTrips+ChangeTripStatus.swift and owning API/data facts plus task status.
- Read-only PWA review: typed status wrapper, evidence upload/staged preview and asset/Kardex viewer URLs.
- Architecture: API-002/API-003/DATA-002/DATA-003/SEC-003.
- Baseline: SkylineServer clean; preserve all existing PWA edits. No shared-package or PWA source mutation is needed.

## Evidence and correction
- PWA submits unregistered assetItem uploads; UploadManager stages them under /var/www/(sitio)/iCatch/.
- Current ImagePickerTo.order and .assetItem permanent paths both resolve /mnt/volume1/sites/(sitio)/fileNet/.
- Existing status handler copies regular evidence to the trip folder, then copies commercial-asset evidence to the same folder using the same filename, triggering its collision guard and rejecting/cleaning up the status update.
- Read staged files using ImagePickerTo.assetItem with isPreRegistration=true to match the uploader.
- Copy each original and available og_/thump_/wap_ variants once to the canonical order/fileNet destination. Both CustFiles trip/merchandise records and CustGeneralFiles/Kardex references use that saved filename.
- Retain filename/path validation, unique permanent naming, off-event-loop copies, transactional metadata and copied-file rollback cleanup. Staged originals remain available.

## Completion / audit
- Inspect resulting source/diff, exact shared paths, PWA upload/preview/viewer behavior and both metadata links.
- Trace ordinary merchandise and commercial assets, absent originals/optional variants, no-media requests and failed transactions.
- git diff --check and final status; no build/test/compile or live filesystem/database operation without required permission.

## Reviewed scope extension: permanent evidence URL
The PWA pinned TCFundamentals helper still groups assetItem with asset and resolves permanent CDN URLs. Add a focused one-line change to AssetItemView.kardexMediaGrid: select ImagePickerTo.order.url for the tenant fileNet copy. Keep pre-registration uploads/previews on assetItem/iCatch, and preserve all unrelated PWA changes/dependency pins. Update the owning PWA API/UI fact and task status.
