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

- 2026-10-14: MediaViewer thumbnail naming now preserves URL separators/suffixes by inserting thump_ directly before the filename instead of using NSString filesystem path operations. Bottom thumbnail buttons center as a group with auto outer margins and retain overflow scrolling. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`; source audit only, no builds/tests or browser execution.

- 2026-10-14: Order mode now uses an inset rounded holder matching the standalone point-of-sale offsets/dimensions, replacing the theme's forced full-screen geometry. Only five shell declarations changed; internal order elements and the corner icon remain unchanged. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`; source audit only, no builds/tests or browser execution.

- 2026-10-14: Fixed duplicate asset avatar gallery insertion by reconciling original/thumbnail/render-variant identities, ignoring cache query/fragment suffixes while retaining host/directory. AssetItemView also associates its isAvatar record with the saved avatar preview, preserving the original media file/ID. See `architecture/SWIFWEB_APP_ARCHITECTURE.md`; source audit only, no builds/tests or browser execution.

- 2026-10-15: Multi-item TripViewBeta adds per-asset Entregar actions and persisted deliverd markers. Delivery reuses the status popup evidence/comment flow and calls the new shared deliverAssetItem contract, applies confirmed item/status/auto-completion, notifies the dashboard and refreshes trip/notes with session/generation guards. See UI/API architecture and `.artifacts/planning/trip-item-delivery/`. The implementation requires dependency revisions containing the supplied delivery contracts; package pins were not changed in this task.

- 2026-10-15: Trip creation supports ordered extra destinations through the existing destination picker. Route cards switch from two columns to one list after a third stop, returning to the grid when extras are removed. Origin/first destination removal is locked while extras remain, including editor deletion. Each asset/merchandise retains its valid chosen destination, all stops are submitted together, and TripViewBeta adapts by stop count. See the UI/API architecture chunks. Source audit only; builds/tests were not authorized and fixed browser rendering remains unverified.

- 2026-10-15: Reviewed and synchronized the exact already-pinned TCFireSignal 0ac424b and TCFundamentals 6a9d6ba commits. Current delivery and billingType consumers already match their contracts; no App source or package pin edits were needed. SwiftPM working copies were behind the pins and now match. The user-approved focused App build passed (150.95s); no tests or browser/server execution. Evidence: `.artifacts/planning/shared-package-sync/`.

- 2026-10-15: OrderView screenshot cleanup moves the reactive highlighted folio to the outer toolbar and the compact status pill onto the priority/alert row. Equipment inspection uses bound native checkboxes, tag1/tag2 share a row, diagnosis/resolution actions have smaller text, and letter/contract/map headers use blue SVG icons with left-aligned address text. Existing business actions, disabled/permission state and inset shell remain intact. See UI architecture and `.artifacts/planning/order-view-compact-cleanup/`; runtime validation pending.

- 2026-10-15: Counter-charge subtraction now follows BillingType.adjustment across billing-aware order/trip/budget/cart calculations, budget imports/edits/historic previews, receipts and sales summaries. The App-only signedAmount helper centralizes direction; locally appended records keep raw prices to avoid double negation. Budget/cart service wrappers retain actual SOC classification locally without a shared contract change. Preserved the user's StartServiceOrder.calcBalance verbatim. Source audit only; builds/tests were not authorized and browser behavior remains unverified. See UI/API architecture and .artifacts/planning/charge-balance-adjustments/.

- 2026-10-15: The approved follow-up build for OrderView compact cleanup reported no errors in AccoutOverview, OrderView, EquipmentView or TCOrderViewTheme. The full App target failed on missing LoadBudgetObjectSOCDecoder.codeType in concurrent budget/point-of-sale charge edits; those sources and package pins were preserved. See `.artifacts/planning/order-view-compact-cleanup/build-errors.txt`; browser rendering remains unverified.

- 2026-10-16: Dirección de servicio now shows the same dropdown/close arrow assets and divider treatment as Imprimir, bound to the existing address expansion state. See UI architecture; source/diff review only, no new build/test or browser validation.

- 2026-10-16: OrderView's deferred initial hydration and single-run mecha-console animation are documented in architecture/SWIFWEB_APP_ARCHITECTURE.md. Explicit refresh cancels unfinished boot work; reduced-motion/performance fallbacks are scoped to the Order theme. Source review only; no new build/test authorization was requested or inferred.

- 2026-10-16: Removed OrderView's full-screen vertical sweep at the user's request. Loading HUD details follow the supplied segmented-ring/frame references; asynchronous hydration is unchanged. Source audit only; no new build/test permission inferred.

- 2026-10-17: Simplified OrderView loading to a centered 144px animated circle. Removed all rectangular HUD surfaces, visible text, progress bar and frame details; retained nonvisual loading status, async hydration and reduced-motion/performance support. Source-audited; build/browser validation unrun.

- 2026-10-17: Order loading visuals now take twice as long: 4.8s/3.2s ring cycles, 1120ms card entry and a 760ms fade. The circle uses 50% alpha and its overlay explicitly has no background, shadow or backdrop filter. Decorative cleanup is 1.8s; actual hydration still yields at 25ms intervals. Source audit only; builds/tests and live App rendering unrun.

- 2026-10-17: Refined the order circle with an 800ms zoom/fade entry and staggered ring assembly, followed by existing slow counter-rotation. An independent wrapper exits with zoom/fade after readiness, allowing the build to finish even on fast loads. Cleanup is 2.1s; 50% alpha, transparent background and actual hydration remain unchanged. See UI architecture; source-only validation.

- Reference refinement: supplied FujiXerox Launch Gambit opening (0–5s) guides a luminous core/fine tick rim and a stronger 1.55-scale exit. The hand and background are excluded; all effects remain local to the circle.

- 2026-10-17: Order circle now completes its build/zoom/fade within one fixed 500ms CSS timeline from first display, independent of readiness. Content entrances finish within 360ms after readiness; decorative cleanup follows after 550ms. Actual hydration, 144px size, 50% alpha and transparent background remain intact. Source audit only; build/browser validation unrun.

- 2026-10-17: Modo de rendimiento now hides the OrderView loader throughout startup and shows ready panels without animation/transition, at full opacity with no transform. Uses the existing live/persisted data-tc-performance-mode flag; normal 500ms visuals and actual hydration remain unchanged. Source audit only; build/browser validation unrun.

- 2026-10-17: Reproduced the missing order animation in the local Chrome app with performance mode off and reduced motion false: its wrapper faded out during hydration before ready. The overlay now first displays in ready state, starting all unchanged 500ms effects after the initial DOM build. Existing 550ms cleanup, performance-mode suppression and data behavior are preserved. Runtime reproduction captured; new build/post-fix App rendering unverified.

- 2026-10-17: SuperView hosts now use a 70% black background when Modo de rendimiento is off, driven by the existing live root flag in visualPerformance.js. The scoped veil improves contrast without adding filters or changing mode-on behavior. See UI architecture; source/diff audit only, no build/test or generated-public refresh.

- 2026-10-17: Order circle now starts wide and contracts inward: entry scale 1.8 to 1, assembly 1.35 to 1, exit 1 to 0.55. The existing 500ms timeline, fade, ready-phase start, cleanup and quiet-mode behavior remain unchanged. See UI architecture; source/diff audit only, builds/tests and live rendering unverified.

- 2026-10-17: Matched the supplied green-outline starting-size reference by enlarging the order circle entry to scale 4 (approximately 688px outer footprint), with the first 20% fading in at that width before contraction. Existing 500ms total timeline, final size, exit and quiet-mode behavior remain unchanged. Source/diff audit only; live rendering/builds/tests unverified.

- 2026-10-17: Order circle fade-out now starts 20ms after first ready display and lasts 480ms, retaining the 500ms total. Wide starting geometry, fade-in/assembly, exit endpoints, cleanup and motion suppression remain unchanged. Source/diff audit only; builds/tests and live rendering unverified.

- 2026-10-17: Order circle opens 25% wider (entry scale 5) and uses a local muted blue palette for rings/ticks/core/glow. No saturation filter or surrounding order-theme change. The 20ms fade-out start and 500ms total remain unchanged. See UI architecture; source/diff audit only, builds/tests and live rendering unverified.

- 2026-10-17: Order circle disappears before reaching its compact center: fade runs from 20ms to 300ms while contraction spans 500ms, passing scale 2.2 at 75%. Combined scale stays above 1.21 through the visible fade. Initial width, muted palette, alpha, hydration/readiness, cleanup and quiet-mode behavior remain unchanged. Source/diff audit only; builds/tests and live rendering unverified.

- 2026-10-17: Order circle now becomes fully invisible at 100ms (20ms delay + 80ms fade). Fade-in reaches its existing 50% alpha at 20ms. Thinner outer/middle/core strokes, narrower ticks and smaller/lower-alpha glows reduce bulk; wide initial geometry and muted palette remain. Source/diff audit only; builds/tests and live rendering unverified.

- 2026-10-17: Order-circle preview now remains visible for 900ms (20ms delay + 880ms fade), with 1200ms contraction so it disappears before becoming compact. Decorative cleanup moves to 950ms to avoid truncation. Thin strokes, muted palette, starting size and actual hydration remain unchanged. Source/diff audit only; builds/tests and live rendering unverified.

- 2026-10-17: Removed the order-opening animation entirely at the user's request: no circle overlay, ring/zoom/fade or panel entrance; no decorative cleanup timer. Existing aria-busy now controls loading-card visibility, and async hydration/refresh guards/map loading are preserved. See UI architecture; source/diff audit only, builds/tests and live rendering unverified.
