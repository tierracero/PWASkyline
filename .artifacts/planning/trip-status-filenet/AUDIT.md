# Trip-status fileNet audit — 2026-10-09

- Source trace confirms unregistered PWA assetItem uploads reach UploadManager's /var/www/(sitio)/iCatch/ staging path, and the handler now uses the matching preregistration helper.
- Shared order permanent path is /mnt/volume1/sites/(sitio)/fileNet/. The handler performs one copy per submitted evidence image, copying original and available og_/thump_/wap_ variants with a new unique basename.
- Regular merchandise creates its trip/snapshot CustFiles metadata. Commercial assets reuse that saved file/variants and additionally create CustGeneralFiles entries; the transition service assigns Kardex relation IDs and persists image IDs on the same transaction connection.
- The former commercial-asset second copy was removed. It would collide when current shared order and assetItem paths both resolve fileNet.
- PWA pinned assetItem helper still selects CDN for permanent assets. The Kardex gallery now explicitly selects order/fileNet URL, matching the server and respecting entrepreneur pDir URL prefixes. The one-line PWA change preserves upload/staged-preview behavior and existing user edits; no dependency/checkouts were modified.
- Reviewed no-media behavior, required-original errors, optional-variant skips, filename/tenant-source checks, off-event-loop copying and failed-copy/transaction cleanup. Only newly copied files are removed on failure; staged originals remain. Same-status requests retain existing no-op semantics.
- Server git diff --check, PWA governance diff --check and both task-relative added-line whitespace checks passed. Final git statuses reviewed; only scoped server source/docs/evidence changed and unrelated PWA work remains.
- No build, test, compilation, live upload/filesystem/customer-data or database command was run. No staging, commit or deployment was performed.
