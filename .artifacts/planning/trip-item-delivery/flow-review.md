# Source flow review — Per-item asset delivery

This is a manual source walkthrough, not executed regression tests.

## Eligibility and rendering

- One merchandise row: no Entregar control, even for an eligible asset. More than one row: button only for linked commercial assets, inProgress and not deliverd. Ordinary merchandise is never submitted to deliverAssetItem.
- All trip sizes show deliverd; completed/in-progress flags read Entregado, canceled flags use Movimiento finalizado because the shared model documents cancellation returns as final movements.
- Header and data each have ten grid cells; the existing horizontally scrollable table preserves all nine prior columns and adds Entrega.

## Identity and contract

- Trip row item.id is the merchandise snapshot identifier. item.merchandiseId is the linked concrete asset item UUID. The request forwards the latter as assetItemId and the trip UUID as tripId.
- Existing asset route validation is reused for the selected item; duplicate linked asset IDs are rejected before the request. Only .store/.warehouse/.subaccount linked endpoints and unique route placement matches pass.
- Exact shared DeliverAssetItemRequest and DeliverAssetItemResponse keys/types are used; optional section/subsection default nil and no local DTO is introduced. Original staged image filenames are sent, never preview URLs.

## Popup and media

- New initializer wraps the existing media collection into a single-item delivery callback. It never calls changeTripStatus; the internal nextStatus value only supports existing common form fields. Delivery copy omits a requested next trip status.
- Comments optional; completed images optional. Existing allowlisted image extensions/safe basename/unique filename checks apply; pending local/remote image processing blocks only delivery confirmation. Remote request still has nil event ID/multiple captures and events route through original row ownership/terminal-ID logic.
- Existing status initializer still validates the same forward status transitions and required cancellation comment. Status-mode pending media behavior is retained. Existing upload transport, per-file polling and gallery stay intact; row type only exposes hasPendingUploads.
- One owned popup prevents duplicate dialogs; didConfirm and shared busy state prevent duplicate submit/status races. Parent removal closes popup, cancels uploads via existing cleanup, removes its gallery and invalidates refresh generation.

## Response, errors and refresh

- Nil, outer non-ok, missing/wrong trip/asset/snapshot response or deliverd=false leaves local flags/status unchanged. Busy state is cleared so the user can retry. Marking occurs only after a matching successful response.
- Partial success marks only that snapshot and applies returned tripStatus; final auto-completion uses the same response field and message. Dashboard/caller notification remains available after the view closes within the original session.
- A generation token invalidates older getTrip refreshes when the next mutation starts or view is removed. Session guards reject changed-user callbacks. Refresh also requires expected trip/status and the confirmed delivered item; a stale response cannot undo the latest confirmed flag.
- getTrip refresh replaces authoritative trip/notes, so subsequent opens use persisted deliverd. A failed/stale reload leaves the confirmed item/status in the current view; it does not turn a confirmed delivery into an error or mark other items optimistically.

## Dependencies and validation limits

- User-supplied package source includes delivery API and default/legacy-decoded deliverd=false. Cached PWASkyline dependencies lack these additions at task start. Package.swift/Package.resolved are protected and unchanged.
- The focused App build with local package sources was offered through the user-input tool. It is not authorized until the user responds affirmatively; no build/test commands were run during this source review.
