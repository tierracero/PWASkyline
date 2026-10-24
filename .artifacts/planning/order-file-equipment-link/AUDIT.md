# Order file equipment association audit

## Result

PWASkyline now sends the linked `CustFolioObjects.id` as `itemId` when exactly one equipment or asset-item row belongs to the order. Direct uploads use the existing multipart upload contract. Order-message camera requests carry the same optional value through TCFireSignal, SkylineServer's APNS payload, Version3 camera capture, and the existing multipart uploader. SkylineServer's direct-order finalizer already writes `manager.itemId` to `CustFiles.item`; the remote web-note image finalizer now writes a `CustFiles` row with the order folio and item ID after the existing message/note finalizer completes.

With no linked row or multiple linked rows, PWA omits `itemId`. Existing remote callers remain nil-compatible. Remote non-image uploads are unchanged.

No schema change is needed: `CustFiles.item` already stores the linked folio-object UUID, and order-file reads already return it.

## Static checks

- Reviewed the full request path: `OrderView` → `MessageGrid` → PWA `requestMobileCamara` → shared `RequestMobileCamaraRequst` → SkylineServer `requestMobileCamara` → shared `APNSNotificationPayload` → Version3 `MainViewController` → `CamaraViewController` → `ImagePickerUploader` multipart parameters → SkylineServer upload manager → `uploadManagerFinalizeToWebNote`.
- Confirmed the direct-upload path already decodes `itemId` into `UploadManager.itemId` and persists it in `uploadManagerFinalizeToOrder`.
- Reviewed focused diffs and `git status` in PWASkyline, SkylineServer, TCFireSignal, TCFundamentals, and Version3. No changes from this task were staged or committed. Pre-existing staged Version3 files remain untouched.
- `git diff --check` passed for the focused PWASkyline, SkylineServer, TCFireSignal, and TCFundamentals changes. Version3 has pre-existing uncommitted whitespace changes in the camera and main-controller files; the new `itemId` lines contain no trailing whitespace. Existing diagnostics and other user changes were preserved.

## Not run

No builds, tests, database queries, APNS delivery, browser session, or device capture were run. PWASkyline and Version3 consume TCFireSignal/TCFundamentals through remote `main`; publish the shared package revisions and refresh those dependencies before compiling the client apps.
