# API and Backend Boundaries

Authoritative rules: `API-*`.

## Verified Facts

- Client API wrappers live under `Sources/App/API/**`.
- The client `sincCustSettings` wrapper decodes an immutable reference-backed `SincCustSettingsSnapshot` with the same fields/keys/optionality as the shared `CustComponents.SincCustSettingsResponse`. This avoids passing/copying the whole settings aggregate by value through optional response callbacks on WASM; shared package definitions remain the wire-contract authority.
- `ManageSubCustomerAccountView` creates with the injected parent's UUID through `API.custSubAcctV1.create`, checking outer/create response statuses and the returned parent ID. Editing validates the source parent, uses `update` with the source UUID/status, then `load(.id)` to return the server's record after verifying its ID and parent. Both paths retain `longitud` and validate returned full address/coordinates when required.
- `API.custSubAcctV1` uses the shared `CustSubAcctComponents` contracts under `custSubAcct/v1`. Create/load/update use authenticated POST; account-scoped search uses authenticated GET and decodes a raw `[CustSubAcct]`, retaining the searched term in its callback and returning nil on transport/decoding failure. Create/update expose labeled parameters and construct the shared request objects internally, preserving the coordinate wire key `longitud`; load accepts `HybridIdentifier`.
- Asset architecture uses `listStoreArchitecture(relationId:)` and department creation requires a nonoptional `relationId`. Location links use `CustCommercialAssetsLocationLinkedType`; asset-item links retain `CustCommercialAssetsLinkedType`. Asset `custAcct` fields remain customer-account identifiers, not store or warehouse identifiers.
- Asset-item creation uses TCFireSignal's shared `InitiateAssetItemViewType`, `CreateAssetItemObject`, and `CreateAssetItemFile` contracts. Single creation submits one object; batch creation collects the requested objects before one request, and `CreateAssetItemResponse.items` returns every created asset item.
- Asset-item listing uses the shared `ListAssetItemsType` location scope, optional `departmentId`/`categorieId` filters, and `ListSubAccountItemsStatus` filter in `ListAssetItemsRequest`, posting to `listAssetItems` and decoding `ListAssetItemsResponse.items`. Store/warehouse scopes take `storeId` and an optional owning `account`; the backend treats a nil account as unowned inventory. Account scope takes `account`, optional `storeId`, and optional `loadSubAccounts` (nil: all, true: linked, false: unlinked). Subaccount scope selects by `owningSubAccount` rather than current custody location.
- Trip asset search maps linked store/warehouse/subaccount origins to `.store(storeId:account:)`, `.warehose(storeId:account:)` (shared wire spelling), or `.subAccount(subAccount:)`, with nil department/category filters and `.available` status. Store/warehouse requests pass the trip's customer `account.id`. Inventory loads before picker presentation; the selected item's parent `getAsset` metadata loads before fiscal editing. Commercial-asset trip merchandise links to `CustCommercialAssetsItem.id`, not its parent `commercialAssetId`, and keeps that identity through the existing trip submission contract.
- Asset-item detail uses TCFireSignal's shared `GetAssetItemRequest`/`GetAssetItemResponse` on the exact `GetAssetItem` POST route. Its resolved location and inventory payloads use `GetAssetItemLocationType`, which identifies the current store, warehouse, account, subaccount, or user; detail records retain optional department, category, section, and subsection classification.
- Asset creation and update preserve the shared commercial-asset fiscal and physical fields: `fiscCode`, `fiscUnit`, `width`, `height`, `length`, and `weight`.
- Asset, asset-item, location, sublocation, category, and department update responses return the inserted `CustGeneralNotes` entry when a change produced an audit note; successful no-op updates may return no note.
- Commercial trip creation submits the complete fiscal location fields for each stop, together with `LocationType` and an optional linked ID; the server persists those submitted snapshots.
- Fiscal merchandise items distinguish their own UUID from `merchandiseType` and optional linked `merchandiseId`. `AddCartaPorteMerchendise` preserves those source fields on save; new manual entries use `.merchandise` with no linked ID. `CreateTripView` forwards type and linked ID to the shared `TripMerchandise` request, retaining its legacy item-ID fallback; deleting a saved merchandise base matches only `.merchandise` sources by linked ID (or item ID for legacy unlinked items).
- `CreateTripView` receives, edits, and submits `CustCommercialTripsComponents.TripLocation` snapshots directly. Its legacy UI adapters retain a nullable `locationId`; an item UUID generated for display/editing is never promoted to a submitted source ID.
- Order payment forms submit the explicitly selected `downpayment` boolean through TCFireSignal. Service/rental creation carries it in `PaymentObject`; later order payments carry it in `AddPaymentRequest`. The form defaults false even with no outstanding balance. Reports partition the shared payment list by that flag into Pagos generales and Anticipos, show each subtotal and their combined total, and export both groups/subtotals in the payment CSV. Existing payment/adjustment arithmetic is preserved; older payloads without the flag decode false.
- Order processing reports consume `ReportsResponseGeneral.delivered` from TCFireSignal. Each entry has an equipment delivery timestamp, order summary, equipment identifiers, and a current pending-equipment flag; the view and CSV export keep it separate from created orders, closed orders, and payments.
- Order charge and payment deletion use the `restrictDeleteCharges` and `restrictDeletePayments` thresholds. Users below the applicable threshold request approval through `CustTaskAuthRequestWaitView`; an approved WebSocket result reloads the order, while the direct removal response is applied only when its `auth` value is true.
- Price override views pass TCFireSignal's `ChangePriceAuthorizationContext` to `CustTaskAuthRequestWaitView`: order and order-budget charges use `restrictOrderCharges`, sale/account/fiscal charges and non-merma transfers use `restrictSaleCharges`, and inventory merma uses `restrictMermProduct`. The server uses the same context when selecting task approvers; requests without the context retain the former level-five gate. A `changePrice` response with `actionType: notify` completes the wait immediately when server settings already permit the requester.
- `Package.swift` resolves TCFireSignal from its remote `main` branch, so PWASkyline needs a revision containing this shared price-authorization contract before it can build with these callers.
- Trip store snapshots use the store-linked fiscal profile when available, otherwise the main profile (`FIAccountsType.account`). A missing preferred/main cached profile triggers the existing general `getProfile` request; a failed/unresolved lookup can use the cached main profile, and absence of any usable profile reports the requested fiscal-configuration error. This picker does not mutate the global fiscal-profile cache.
- Endpoint files are grouped by domain and often named `Domain+Action.swift`.
- The app depends on multiple Tierra Cero core packages that likely define shared payloads and contracts.
- The three public `sendPost` overloads share one internal XMLHttpRequest transport that preserves response-body callback compatibility while recording transport failures.
- First-party TierraCero and IntarTC `XMLHttpRequest` transports send the current `custCatchChatConnID` in the `WSId` header so backend work can correlate asynchronous WebSocket updates with the originating browser connection.
- API wrapper decoding is routed through `decodeAPIResponse`, except the recursion-protected error-reporting endpoint response.
- `API.v1.reportError` uses the shared `ReportErrorRequest` contract and a reporting-disabled transport policy.

## Rules

### API-001 — Client Contract Ownership

API wrapper files own client-side request construction, response decoding, callbacks, and error propagation for their domain.

### API-002 — Backend Contract Drift Requires Review

Any change to endpoint paths, payload shape, auth headers, fiscal fields, payment fields, or expected response models must be treated as a backend contract change unless verified against backend/shared package definitions.

### API-003 — Fiscal and Payment Focus

Fiscal, CFDI, Carta Porte, payment, credit, and account-balance flows require especially small diffs and focused verification because mistakes can affect legal/accounting behavior.

## Implementation Guidance

- Preserve exact serialized keys and backend naming conventions.
- Add new endpoints in the matching endpoint folder.
- Avoid introducing generic request abstractions in a feature bugfix unless the task is explicitly an API architecture task.
- For new payloads, verify whether the type already exists in a private package before duplicating it locally.
- Error-report delivery succeeds only after a successful HTTP status, decodable response, and backend `.ok` status; delivery failures update the original persisted record and never create a recursive report.
- Diagnostics use `TCFundamentals.ErrorReportingPriorty` directly (`zero`, `low`, `med`, and `high`) for persistence, queue ordering, and backend delivery.
