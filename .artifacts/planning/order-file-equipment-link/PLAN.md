# Order file equipment association

## Goal

When an order has exactly one linked `CustFolioObjects` record (`equipment` or `assetItem`), attach order-file uploads to that record by writing its `id` to `CustFiles.item`. With zero or multiple linked records, preserve the existing unassociated behavior.

## Scope

- PWASkyline `OrderView` derives the optional single linked record ID and includes it in direct `uploadManager` multipart requests.
- The order `MessageGrid` passes that ID to `requestMobileCamara`.
- TCFireSignal adds a source-compatible optional `itemId` to `RequestMobileCamaraRequst`; TCFundamentals carries it in the APNS payload; SkylineServer forwards it to the device.
- Version3 passes the ID from the APNS payload through camera capture and `ImagePickerUploader` into the existing `itemId` multipart field.
- SkylineServer's remote order-message finalizer also creates a linked `CustFiles` record when the upload carries the optional order item ID. The existing note/message flow remains intact.
- Update the owning API and camera architecture notes and task archives in the affected repositories.

## Planned files

- PWASkyline: `Sources/App/Snippits/OrderView/OrderView.swift`, `Sources/App/Snippits/MessageGrid/MessageGrid.swift`, `Sources/App/API/CustEndpoint/Cust+RequestMobileCamara.swift`, and `.agent/architecture/API_AND_BACKEND.md`.
- TCFireSignal: `Sources/TCFireSignal/Components/CustComponents/Cust+RequestMobileCamara.swift`.
- TCFundamentals: `Sources/TCFundamentals/APNS/Structures/APNSNotificationPayload.swift`.
- SkylineServer: `Sources/App/Endpoints/CustEndpoint/Cust+RequestMobileCamara.swift`, `Sources/App/Endpoints/WebhookEndpoint/Webhook+UploadManager/Webhook+UploadManager+Finalize/Webhook+UploadManager+Finalize+ToWebNote.swift`, and API architecture notes.
- Version3: `version3/ViewControlers/MainViewController.swift`, `CamaraViewController.swift`, `ImagePickerUploader.swift`, and API/camera architecture notes.

## Constraints and risks

- Keep `relatedid` as the order UUID; `itemId` is separate and identifies the linked `CustFolioObjects` row.
- All new request fields default to nil so existing callers and notifications remain compatible.
- Do not create or edit Core Data entities, database columns, package pins, or unrelated upload behavior.
- PWASkyline and Version3 resolve shared packages from remote `main`; those clients require a shared-package revision containing the optional field and a dependency refresh before they can compile against it.
- Preserve all unrelated existing staged, unstaged, and untracked work. No build or test command without user confirmation.

## Completion criteria

- Exactly-one item association is applied consistently to direct and remote order pictures; zero/multiple associations preserve nil.
- The order ID continues to drive the remote camera/message flow.
- Remote upload passes the optional item ID through every contract boundary and persists `CustFiles.item` without removing the existing order message.
- Static contract/call-site/diff/status audit is complete; no build, test, device, or server execution is claimed.
