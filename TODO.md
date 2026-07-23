# PWASkyline Bug and Consistency TODO

Static audit performed on **2026-07-16** against the current working tree.

> The repository already contains substantial uncommitted work. This audit treats that working tree as the current source of truth and does not modify existing source files.
>
> Priority guide: **P0** blocks builds, risks account/security data, or can crash a production workflow; **P1** is a user-visible functional or lifecycle defect; **P2** is reliability/architecture debt; **P3** is cleanup and naming consistency.

## P0 — Critical

- [ ] **Fix the missing SwiftPM resource path.** **Confirmed.**
  - Evidence: `Package.swift:96-102` copies `tutorial`, but `Sources/Service/tutorial` does not exist. The current tutorial resources are under `Sources/Service/skyline/tutorial/`.
  - Impact: the `Service` target can fail package validation/build with an unhandled resource path.
  - Done when: `Package.swift` references only existing resource directories and both `App` and `Service` targets build from a clean checkout.

- [ ] **Correct the authenticated production API base URL.** **Confirmed inconsistency; verify against the backend contract before release.**
  - Evidence: `Sources/App/Functions/sendPost.swift:21-40` starts at `https://api.tierracero.co` without `/api`, while the other overload at `sendPost.swift:91-108` starts at `https://api.tierracero.co/api`. `Sources/App/Enums/ServerRouts.swift:11-30` does not add an `api` prefix.
  - Impact: authenticated production requests can be sent to a different route tree than development and unauthenticated requests.
  - Done when: one environment-aware URL builder produces the same documented route shape for every request overload.

- [ ] **Remove credentials, tokens, personal data, and full payloads from logs.** **Confirmed.**
  - Evidence: `sendPost.swift:43-59`, `sendPost.swift:129-171`, and `sendPost.swift:194-216` print encoded request payloads and/or authorization data; `Sources/App/VirtualControlers/WebSocketControler.swift:128-157` builds a token-bearing URL and logs it in development; `WebSocketControler.swift:228-239` prints every incoming message; `Sources/App/API/APIEndpoint/API+SkylineDocument.swift:24-30` prints the complete document response.
  - Impact: browser consoles and captured logs can expose session material, customer data, fiscal data, payment data, or internal documents.
  - Done when: logging is structured, environment-gated, redacted, and never prints authorization headers, tokenized URLs, or raw business payloads.

- [ ] **Implement complete logout/session destruction.** **Confirmed.**
  - Evidence: `Sources/App/Functions/killSession.swift:11-35` only clears `localStorage`. It does not clear `sessionStorage`, close/nil the WebSocket, stop reconnect/heartbeat work, or reset the global session and cache variables declared throughout `Sources/App/SkylineWeb.swift`.
  - Impact: a logout or expired session can leave previous-account data and live real-time activity in memory until the page is fully reloaded.
  - Done when: one session coordinator clears both storage scopes as appropriate, resets all account-scoped caches/state, cancels real-time work, closes the socket intentionally, and has a cross-account regression test.

- [ ] **Stop persisting reusable authentication/session material in `localStorage`.** **Confirmed design risk.**
  - Evidence: `Sources/App/Functions/loadBasicConfiguration.swift:26-77` restores user, token, key, and chat data from `localStorage`; `Sources/App/VirtualControlers/WebSocketControler.swift:40-95` stores `custCatchChatToken` there.
  - Impact: any successful script injection can read long-lived session material; stale tokens also survive browser restarts.
  - Done when: sensitive tokens use the shortest viable lifetime/storage mechanism, rotation and expiry are explicit, and the backend uses secure cookie/token protections appropriate for the PWA.

- [ ] **Replace the inventory print-path `fatalError` with recoverable handling.** **Confirmed.**
  - Evidence: `Sources/App/Snippits/ToolReciveSendInventory.swift:2451-2457` terminates execution when `granCredit > 0` but `manualPurchaseManager` is missing.
  - Impact: inconsistent API/UI state can crash the whole WebAssembly app during a business-critical inventory flow.
  - Done when: the missing relation produces a user-visible error, telemetry, and a safe return; add a regression test for the inconsistent payload.

## P1 — High

- [ ] **Make `loadBasicConfiguration` single-exit and single-callback safe.** **Confirmed.**
  - Evidence: `Sources/App/Functions/loadBasicConfiguration.swift:143-153` calls `killSession()` and `callback(nil)` after a `linkedProfile` decode failure but does not return, so API loading continues and the callback can later fire again.
  - Impact: callers can navigate twice, mutate state after logout, or receive contradictory completion results.
  - Done when: every failure returns immediately and the completion is guaranteed to execute exactly once.

- [ ] **Guarantee the loading overlay is dismissed on every configuration path.** **Confirmed.**
  - Evidence: `loadBasicConfiguration.swift:155-193` enables the loader and has multiple early returns without disabling it; `loadBasicConfiguration.swift:250-253` returns for inactive accounts before the normal `loadingView(show: false)` at line 257.
  - Impact: communication errors or non-active account states can leave the UI permanently blocked.
  - Done when: loader ownership uses one cleanup/defer-style path and tests cover nil responses, non-OK responses, missing payloads, inactive accounts, and decode failures.

- [ ] **Do not report configuration ready before required asynchronous data is ready.** **Confirmed race.**
  - Evidence: `loadBasicConfiguration.swift:255-405` starts fiscal profile and multiple dependent cache requests, but `callback(settings.account.status)` is called at `loadBasicConfiguration.swift:407` without waiting for those operations.
  - Impact: the work UI can render while fiscal profile, users, stores, banks, and order-manager caches are still empty, causing intermittent missing options and stale defaults.
  - Done when: required startup tasks are explicitly grouped/awaited, optional tasks are identified as background work, and readiness has a documented contract.

- [ ] **Unify HTTP request handling and validate response status.** **Confirmed.**
  - Evidence: `Sources/App/Functions/sendPost.swift` contains three near-duplicate implementations. Their local/development schemes differ (`http` versus `https`), and every `onLoad` forwards the response body without checking HTTP status.
  - Impact: 4xx/5xx responses look like successful transport, environment behavior drifts, and callers receive only `nil` instead of actionable error context.
  - Done when: one request client owns base URLs, headers, timeout/cancellation, status validation, decoding errors, and a typed result/error model.

- [ ] **Fix service-worker installation hanging after WASM startup failure.** **Confirmed failure path.**
  - Evidence: `WebSources/serviceWorker.js:10-24` polls forever until `self.serviceInstalled` or `self.serviceInstallationError` is set. `serviceWorker.js:72-76` sends startup rejection to `wasiErrorHandler`, while `WebSources/wasi/errorHandler.js:1-6` only logs and never sets `serviceInstallationError`.
  - Impact: a failed service-worker WASM load can leave installation/update pending indefinitely.
  - Done when: startup failures reject the install promise, polling has a bounded timeout, and update/recovery behavior is tested offline and with a missing/corrupt WASM file.

- [ ] **Harden WASM fetch/startup error handling.** **Confirmed incomplete handling.**
  - Evidence: `WebSources/wasi/startTask.js:6-31` does not fail fast on a non-OK GET/HEAD response; the UI error event is dispatched for an unexpected status, but execution continues into stream reading and WebAssembly instantiation. The `304` branch creates `WASMLoadedFromCache` without dispatching it.
  - Impact: users can receive a low-level instantiate failure instead of a deterministic loading error, and cache telemetry/events do not work as intended.
  - Done when: GET and HEAD failures are checked, the error event is dispatched once, startup aborts cleanly, and the cache event is actually dispatched.

- [ ] **Define intentional WebSocket shutdown and reconnect rules.** **Confirmed lifecycle gap.**
  - Evidence: `Sources/App/VirtualControlers/WebSocketControler.swift:164-216` reconnects after most close codes, including normal closure, because `reconect` defaults to `true`; no WebSocket close call was found in the app audit.
  - Impact: logout, navigation, or an intentional server close can immediately reopen the authenticated connection.
  - Done when: the controller has explicit states (`connecting`, `connected`, `stopping`, `stopped`), intentional closes never reconnect, and retry policy uses bounded exponential backoff with jitter.

- [ ] **Prevent duplicate or orphaned WebSocket heartbeat chains.** **Needs runtime verification.**
  - Evidence: every socket open schedules `heartBeat()` at `WebSocketControler.swift:158-163`; `heartBeat()` recursively schedules itself at `WebSocketControler.swift:350-378`, with no cancellation token tied to the current socket instance.
  - Impact: reconnects can leave timers associated with old sockets and make connection behavior nondeterministic.
  - Done when: heartbeat ownership is per connection, timers are cancelled on close/logout, and only the active socket can send/schedule the next heartbeat.

- [ ] **Repair production-element search and favorite ordering.** **Confirmed.**
  - Evidence: `Sources/App/Snippits/ServiceProductionElementsView.swift:45-63` disables the search input; `ServiceProductionElementsView.swift:225-239` contains no filtering logic for terms of three or more characters; `ServiceProductionElementsView.swift:210-220` computes favorite/general ordering and then immediately overwrites it with the full API order.
  - Impact: users cannot search and the favorite-first behavior never takes effect.
  - Done when: the field is enabled after loading, filtering covers the intended searchable fields, clearing the term restores favorite/general ordering, and UI tests cover all states.

- [ ] **Replace placeholder order balance and production-time values.** **Confirmed.**
  - Evidence: `Sources/App/ViewControlers/WorkViewControler.swift:2706-2707`, `2791-2792`, and several additional creation branches pass `balance: 0` and `productionTime: 0` with `TODO: do proper calc`.
  - Impact: newly inserted order summaries can display incorrect operational and financial information until refreshed from another source.
  - Done when: all creation paths use one authoritative calculation/mapping function and match subsequently loaded order data.

- [ ] **Make app initialization explicit instead of relying on an apparently unused `configure()`.** **Needs framework/runtime verification.**
  - Evidence: `Sources/App/App.swift:147-178` initializes fiscal lookup references, panel language, and the Escape-key handler, but repository search found no call to `configure()`.
  - Impact: lookup dictionaries and keyboard behavior may never initialize, or the method may represent obsolete lifecycle code.
  - Done when: initialization is called from a documented lifecycle hook exactly once, or the dead method is removed and its required work moved to the active launch path.

- [ ] **Use one localization storage key and consistent locale matching.** **Confirmed.**
  - Evidence: launch code reads/writes `webLanguage` at `Sources/App/App.swift:34-64`, while `configure()` reads `panelLanguage` at `App.swift:160-165`. Navigator French matching uses exact `lang == "fr"`, unlike English prefix matching.
  - Impact: a saved language can be ignored or overwritten, and locales such as `fr-FR` do not select French.
  - Done when: one key and one locale parser are used across login, panel, and launch flows.

- [ ] **Make bootstrap DOM helpers null-safe and navigation absolute.** **Confirmed fragility.**
  - Evidence: `WebSources/main.html:28-34` removes three elements without null checks; Swift force-calls the helper at `Sources/App/App.swift:67`. `main.html:35-37` navigates to relative `login`, and several Swift bridge calls are force-unwrapped (`App.swift:94`, `App.swift:174`).
  - Impact: duplicate lifecycle calls or changed bootstrap markup can throw JavaScript errors; nested deep links can resolve login to the wrong URL.
  - Done when: helpers tolerate missing elements, bridges are checked before invocation, and navigation uses an absolute app route.

- [ ] **Centralize session refresh logic and remove the magic timeout.** **Confirmed duplication.**
  - Evidence: near-identical `sessionControl` checks exist in `Sources/App/App.swift:78-108` and `Sources/App/ViewControlers/WorkViewControler.swift:2245-2270`, both using the unexplained value `10799`.
  - Impact: fixes can diverge between lifecycle and controller code, and the intended duration is unclear.
  - Done when: one session coordinator owns the interval as a named duration/configuration and all callers consume the same result.

## P2 — Medium

- [ ] **Use a valid PWA theme color.** **Confirmed.**
  - Evidence: `Sources/Service/Service.swift:5-10` sets `.themeColor("dark")`; the generated manifest contains `"theme_color": "dark"`, which is not a valid CSS color value.
  - Impact: browsers may ignore the theme color and render inconsistent browser chrome.
  - Done when: manifest and HTML use the same valid hex/rgb/named CSS color and generated output is verified.

- [ ] **Improve manifest/bootstrap deep-link robustness.** **Needs browser verification.**
  - Evidence: `Sources/App/App.swift:16` registers `./service.js` and `WebSources/main.html:6` links `./site.webmanifest`; both are relative URLs. `main.html:35-37` also uses a relative login route.
  - Impact: multi-segment deep links or a changed trailing-slash policy can resolve assets below the current route rather than the application root.
  - Done when: root-scoped URLs are used where intended and installation/navigation is tested from direct deep links.

- [ ] **Add a real document title and package local app icons consistently.** **Confirmed inconsistency.**
  - Evidence: `WebSources/main.html:4` uses an effectively blank title, while favicon/touch-icon links at `main.html:11-16` depend on external `tierracero.com` URLs even though local PWA icons exist.
  - Impact: poor tab/accessibility labeling and degraded/offline icon behavior.
  - Done when: the title identifies Skyline, icon links use packaged assets, and favicon markup uses the correct `sizes` attribute.

- [ ] **Eliminate duplicate application-version declarations.** **Confirmed.**
  - Evidence: version `0.23.2 beta` is independently declared in `Sources/App/SkylineWeb.swift:14-20` and again at `SkylineWeb.swift:280-286`.
  - Impact: headers and UI/runtime reporting can drift after a release bump.
  - Done when: one version source is injected/read by all consumers.

- [ ] **Make API endpoint access consistent.** **Confirmed.**
  - Evidence: `Sources/App/API/API.swift:14-46` exposes endpoint namespaces as type aliases except `mailV1`, which is an instance property. Call sites therefore use `API().mailV1` while other endpoints use `API.<namespace>`.
  - Impact: unnecessary object construction and an inconsistent API surface that encourages stateful endpoint wrappers.
  - Done when: endpoint namespaces follow one documented static/instance model.

- [ ] **Pin production dependencies reproducibly and avoid SSH-only package URLs.** **Confirmed configuration debt.**
  - Evidence: `Package.swift:43-71` tracks several private dependencies from the moving `main` branch through `git@github.com` URLs.
  - Impact: clean builds can change without a project commit and fail in CI/deployment environments without the developer SSH configuration.
  - Done when: releases use tagged/exact/range versions or reviewed revisions, CI authentication is documented, and a clean clone resolves deterministically.

- [ ] **Audit route precedence for the wildcard page.** **Needs framework verification.**
  - Evidence: `Sources/App/App.swift:116-126` declares `Page("**")` before named routes.
  - Impact: if SwifWeb uses first-match routing, valid routes may be intercepted by `NotFoundPage`.
  - Done when: route behavior is covered by tests/direct navigation and the wildcard is placed according to documented matcher precedence.

- [ ] **Replace unsupported default initializers with compile-time unavailability where possible.** **Needs framework verification.**
  - Evidence: many `Div` subclasses implement `required init() { fatalError("init() has not been implemented") }`, including `PaymentConfirmationView.swift:73`, `ServiceProductionElementsView.swift:36-38`, and numerous other view files.
  - Impact: any framework/reflection/default-construction path can terminate the whole WASM app at runtime.
  - Done when: default initialization is marked unavailable or safely implemented, and DOM/framework construction paths are tested.

- [ ] **Define ownership and invalidation for global mutable caches.** **Confirmed architecture debt.**
  - Evidence: `Sources/App/SkylineWeb.swift` declares account, order, payment, store, fiscal, user, social, and other mutable caches as process-wide globals.
  - Impact: stale or cross-account state is difficult to reason about and makes logout/reload behavior unsafe.
  - Done when: caches are grouped under an account-scoped runtime/session object with explicit load, refresh, and reset rules.

- [ ] **Add automated coverage for critical client contracts.** **Confirmed gap from repository layout.**
  - Evidence: no `Tests/**/*.swift` test suite was found in the source audit.
  - Minimum coverage: URL construction by environment/auth mode, session reset, configuration callback behavior, WebSocket reconnect/heartbeat lifecycle, route matching, PWA bootstrap failure, and financial/order summary mapping.

## P3 — Cleanup and Consistency

- [ ] **Plan a dedicated naming cleanup without mixing it into bug fixes.**
  - Examples: `ViewControlers`, `Snippits`, `Structurs`, `Extentions`, `ServerRouts`, `develpment`, `produccion`, `PaymenrPrintEngine`, `PaymentReciptFormView`, `Vehical`, `Refrence`, and `Catch` where `Cache` is intended.
  - Done when: public/API contract spellings are separated from internal rename candidates, migration is incremental, and each path/type rename has build verification.

- [ ] **Remove duplicate imports and temporary raw-response diagnostics.**
  - Evidence: `Sources/App/API/APIEndpoint/API+SkylineDocument.swift:2-5` and `API+SkylineDocuments.swift:1-5` import `TCFundamentals` twice; the singular endpoint includes temporary raw-response/count logging.
  - Done when: imports are lint-clean and diagnostics use the centralized redacted logger.

- [ ] **Replace repeated debug prints with a leveled logger.**
  - Evidence: lifecycle, API, WebSocket, session, and controller code use large volumes of emoji-prefixed `print`/`debugPrint`, including duplicated connection-ID prints at `WebSocketControler.swift:34-36`.
  - Done when: debug/info/warning/error levels can be disabled per build and messages contain safe structured context.

- [ ] **Break up `WorkViewControler.swift` through focused, tested extractions.**
  - Evidence: the file is approximately 4,150 lines and mixes navigation, session checks, menus, order creation, printing, alerts, chat, inventory, fiscal tools, and account loading.
  - Done when: responsibilities move behind small controllers/services without changing behavior, one feature at a time.

- [ ] **Remove stale comments and duplicated TODO blocks after converting them into tracked tasks.**
  - Examples: repeated inventory TODO text at the beginning of `ToolReciveSendInventory.swift`, obsolete commented implementations, and comments describing bypasses that current code no longer performs.
  - Done when: source TODOs link to a tracked item or are resolved, and commented-out implementation blocks are removed from production source.

## Validation Checklist

- [ ] Run a clean dependency resolution and build for both `App` and `Service` targets.
- [ ] Build the WebSources/webpack outputs from a clean `node_modules` install.
- [ ] Test direct navigation to every named route and at least one multi-segment deep link.
- [ ] Test login, session expiry, logout, and login as a different account without reloading the tab.
- [ ] Test WebSocket connect, network loss, intentional logout close, reconnect, and heartbeat behavior.
- [ ] Test service-worker first install, update, offline start, missing WASM, corrupt WASM, and failed HEAD/GET requests.
- [ ] Confirm browser console output contains no credentials, tokens, customer payloads, fiscal documents, or payment data.
