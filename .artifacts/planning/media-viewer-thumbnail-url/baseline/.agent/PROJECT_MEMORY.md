# Project Memory

Durable facts and current state for PWASkyline. Link to authority instead of duplicating rules.

## Product Identity

- **Project**: PWASkyline.
- **Owner/product family**: Tierra Cero Skyline 2.0.
- **Type**: Swift Web / WebAssembly PWA.
- **Primary language**: Swift, with JavaScript/WASI bootstrap support.

## Current Baseline Verified 2026-07-08

- Root project path: `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`.
- Git repository exists on branch `main...origin/main`.
- No pre-existing `AGENTS.md` or `.agent` docs existed before this bootstrap.
- Agent governance bootstrap created 36 documentation files total: root `AGENTS.md` plus 35 Markdown files under `.agent/**`.
- `Package.swift` defines executable products `App` and `Service`.
- `Sources/App/App.swift` registers `./service.js`, manages lifecycle hooks, sets localization defaults, defines route pages, and switches between main/skyline/login styles.
- `Sources/Service/Service.swift` defines PWA manifest fields and service-worker lifecycle handlers.
- `WebSources/package.json` includes webpack/WASI/JavaScriptKit-related dev dependencies.

## Current Caution

When this governance bootstrap began, the repository already contained many modified and untracked source files. Future agents must preserve those user changes and avoid broad formatting or regeneration.

## Error Reporting Baseline Verified 2026-07-16

- `ErrorReportingControler` is the single owner of diagnostic capture, IndexedDB persistence, immediate and 10-minute retries, account isolation, and 60-day cleanup.
- All three `sendPost` overloads use one internal transport with callback-once protection and automatic encoding, network, timeout, abort, HTTP-status, and empty-response reporting.
- API decoding under `Sources/App/API/**` uses `decodeAPIResponse`; the error-report endpoint intentionally uses a direct decoder and reporting-disabled transport to prevent recursion.
- `WebSources/errorReportingIndexedDB.js` owns the `PWASkylineDiagnostics/errorReports` schema and multi-tab atomic claims.
- Diagnostic priority uses `TCFundamentals.ErrorReportingPriorty` directly and is persisted as `priorty` plus `priorityRank` (`zero`/`low`/`med`/`high`, ranks `0`/`1`/`2`/`3`). IndexedDB schema version 2 migrates legacy `medium` and `critical` queue values to `med` and `high`.
- Generated public output trees were not refreshed by the error-reporting implementation.

## Authoritative References

- 2026-10-09: The saved-location cancellation action in `ManageLocationItem` and its linked-ID/picker synchronization are documented in `architecture/SWIFWEB_APP_ARCHITECTURE.md`.
- 2026-10-09: The minimal asset-creation camera-image payload lookup is documented in `architecture/SWIFWEB_APP_ARCHITECTURE.md`; the previous camera and upload logic is retained.
- 2026-10-08: Trip beta status confirmation and shared media-gallery source integration are documented in `architecture/SWIFWEB_APP_ARCHITECTURE.md`. The beta API handoff now submits status/comment/media and synchronizes status only after success; `ChangeTripStatusMedia` exists in the local TCFireSignal source but is absent from the repository's cached dependency. Build verification is blocked by the unavailable pinned TCFundamentals revision.
- Product facts: `PRODUCT_SCOPE.md`.
- Architecture boundaries: `ARCH_INDEX.md` and `architecture/*.md`.
- Source layout: `SOURCE_MAP.md`.
- Modules: `MODULES.md`.
- Open decisions: `OPEN_DECISIONS.md`.

- 2026-10-07: `CustAcctPayments.downpayment` defaults false; only explicit selection marks an order payment as an anticipo. Full/quick shared payloads, `PaymentObject`, and order AddPayment requests decode missing flags as false. Existing tenants need the manual payment-column SQL before server deployment. Order reports and payment CSVs show general/downpayment subtotals and a combined total while retaining existing adjustment arithmetic.

- 2026-10-13: Restored the asset avatar gallery in the main checkout: avatar-first image initialization, up to four preview-selection dots, and selected-image MediaViewer opening. Existing title/upload layout and MediaViewer implementation were preserved. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`; source audit only, builds/tests were not authorized.

- 2026-10-14: StoreView bounds `usersContainers` with a zero flex basis/height and automatic overflow. Its parent now uses explicit none/flex display bindings for existing/new stores, allowing the cards and user scroll area to fill the workspace instead of leaving the unused height shown in the supplied recording. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`. Source review and original-recording inspection only; no builds/tests or fixed-browser execution.

- 2026-10-14: Asset-item details now edit the supported name/serial/current-cost/section/subsection fields and save through the existing updateAssettem wrapper, then reload by concrete UUID. Other metadata and service-card activation remain separate. See the UI/API architecture chunks; source audit only, builds/tests/browser execution were not authorized.

- 2026-10-14: Asset-item media now shows one main avatar preview with up to five selection dots; the separate lower thumbnail grid and its private helpers were removed. The existing selected-photo/full-gallery MediaViewer flow remains intact. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`; source audit only, no builds/tests or browser execution.
