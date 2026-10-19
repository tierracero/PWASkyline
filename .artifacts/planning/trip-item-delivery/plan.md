# Per-item commercial asset delivery

Date: 2026-10-15

## Scope and authority

User confirms Entregar only for trips with multiple items. Use the supplied TCFireSignal DeliverAssetItemRequest/Response and FiscalMercanciaItem.deliverd. Primary checklist: swifweb_ui_skill; supporting checklist: api_endpoint_skill. Architecture IDs: SWWEB-001/002/003, API-001/002/003; session handling follows SEC-001/STATE-001.

## PLAN

1. Add Sources/App/API/CustComertialTripsEndpoint/CustComertialTrips+DeliverAssetItem.swift, an authenticated sendPost wrapper for deliverAssetItem using the exact shared request/response. Forward optional destination classification IDs with nil defaults; no local DTO, package/lockfile or backend edits.
2. Extend the existing ConfirmTripStatusUpdate popup with an explicit delivery initializer/mode for one linked commercial asset. Reuse its comment, local upload, remote camera, image gallery, event correlation and cleanup. Delivery copy describes only that asset/destination; it does not request a whole-trip status transition. Validate in-progress, linked/undelivered item, route and safe unique image filenames. Prevent delivery confirmation while images are pending. Keep original status initializer/behavior intact. Guard popup operations against changed sessions.
3. In TripViewBeta add an Entrega column. Show Entregar only for undelivered linked commercial assets in an in-progress trip with merchandise.count > 1; disable while a trip mutation is pending. Display Entregado from deliverd in every trip size; canceled final movements use Movimiento finalizado to avoid implying delivery on a canceled trip. Ordinary merchandise gets no asset delivery action.
4. Serialize delivery/status requests with the existing busy state and a single owned confirmation view. Capture trip/session/merchandise/asset identities and a mutation generation; close owned dialogs on parent removal. Only a successful matching delivery response updates deliverd and returned tripStatus, notifies the dashboard/caller, and starts a guarded authoritative getTrip refresh (including notes and final trip completion). Refreshes cannot overwrite a later mutation. Preserve a confirmed delivery if a stale/invalid reload lacks its delivered state.
5. Synchronize owning UI/API facts, source map/module entries, memory and archived task. No boundary ownership changes.
6. Audit task-relative diff/whitespace/status, shared field types, eligible/ineligible/duplicate/error/removed/session-change/partial/final delivery and reload ordering by source review. Builds/tests require explicit user permission. Cached dependencies currently lack both new shared contracts; do not edit generated checkouts or pin updates silently.

## Reviewed before source mutation

Self-reviewed against mandatory workflow, primary UI/supporting API checklists, shared supplied contracts and pinned GetTripItem mutable merchandise/status fields. The endpoint takes the linked asset item UUID (merchandiseId), while response.merchandiseItemId identifies the trip snapshot row. isAvatar/gallery/order-holder previous work is outside scope. No independent reviewer or subagents are required or authorized. The popup is reused instead of duplicating its upload pipeline. Optional destination section/subsection remain nil in this UI; their wrapper support preserves the new API contract without inventing classification semantics.

## Completion criteria

A multi-item in-progress trip offers per-asset delivery, opens a single-asset evidence/comment popup, submits the shared contract, marks only server-confirmed delivered rows, preserves marks on reload, and adopts server auto-completion. Single-item trips have no Entregar action. Existing trip-wide status and unrelated user work are preserved. Source-only completion must explicitly report dependency/build/browser verification limits.
