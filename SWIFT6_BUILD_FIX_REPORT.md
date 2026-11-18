# Swift 6 Build Fix Report

**Project:** PWASkyline (Swift Web / WebAssembly PWA)  
**Date:** 2026-11-16  
**Purpose:** Handoff summary of the Swift 6 concurrency and container build updates made in PWASkyline and the `web` package.

## Summary

The project was being built with Swift 6, while its Swift package manifest still declared Swift tools 5.10. Enabling Swift 6 exposed actor-isolation mismatches between browser DOM callbacks, the App target, and the service-worker startup. The changes below make the ownership explicit while preserving the existing event dispatch and service-worker lifecycle.

## PWASkyline project changes

### Swift package configuration and Web dependency

- Raised `swift-tools-version` in `Package.swift` from `5.10` to `6.2`.
- Set the `App` target's default isolation to `MainActor`, which matches the browser UI and DOM work performed by the target.
- Added an optional `TIERRACERO_WEB_PACKAGE_PATH` override for a local `web` checkout.
- Made the default Web dependency `git@github.com:tierracero/web.git` on the `master` branch. The Docker container does not have the Mac checkout at `~/Development/Packages/web` mounted, so a local filesystem dependency cannot be relied on there. The Git dependency is fetched normally by `swift package update` inside the container.

### App concurrency migration

- Marked 443 `override class var name` declarations as `nonisolated`. These are static DOM tag names and do not need access to MainActor-isolated UI state.
- Applied targeted actor annotations to shared state and callbacks, including `CatchControler`'s MainActor-owned singleton, `CustomEvent`'s nonisolated event decoding, and affected UI/API extensions and imports.
- Used `@preconcurrency import LanguagePack` where the existing package's concurrency annotations are not yet fully expressed to the compiler.
- Reworked the Carta Porte history location iteration from `forEach` into a `for` loop and made its date/hour labels immutable. The displayed labels and date values are unchanged; this removes closure-capture issues exposed by strict concurrency checking.

These App edits are concurrency annotations or equivalent control-flow forms. They do not change the business rules for orders, inventory, payments, or Carta Porte.

### Service worker entry point

- Replaced the direct `Service.start()` call with the package's `Service.main()` bootstrap. The initial fix used its async entry point to resolve the MainActor-to-WebWorkerActor compiler error.
- The later browser-runtime correction uses a synchronous WASM entry point that queues startup on `WebWorkerActor`; native tooling still awaits `Service.main()` for manifest extraction. `Sources/Service/main.swift` selects the corresponding call with `#if arch(wasm32)`.

## `web` package changes

- Annotated DOM event callback closure types with `@MainActor` across the event-handler APIs.
- Updated callback storage and initializer/factory closure types in `Sources/DOMEvents/Container.swift` to use the same actor annotation.
- Kept the existing callback dispatch behavior; the package already dispatches these callbacks through `MainActor.assumeIsolated`.
- Committed and pushed the package change to `origin/master`:

  ```text
  a5146d22be1486ba55d337677b178f80021c3403
  Isolate DOM event callbacks to MainActor
  ```

  The package change covers 83 files under `Sources/DOMEvents` and contains only callback isolation annotations.

## Verification

The initial verification covered Swift compilation. A subsequent full SwiftStream release build exposed an additional failure in WASM postprocessing, described below. Successful Swift compilation alone does not prove the entire production packaging pipeline has completed.

Builds completed successfully:

- `swift package update` in the Docker container: all dependencies updated/resolved; it reported “Everything is already up-to-date.”
- `swift build --target Service` on the host: passed.
- `swift build --jobs 2 --target Service --configuration debug --swift-sdk wasm32-unknown-wasi` in the Docker container: passed after the service entry-point change.
- App native debug and release builds: passed.
- App WASI debug build: passed.
- App WASI release build with per-file optimization: passed using `-Xswiftc -no-whole-module-optimization`.
- Web package debug build: passed.
- `git diff --check`: passed.

An earlier whole-module-optimized App WASI release build was killed by signal 9 in the 8 GB container during compilation, without a Swift source diagnostic. The per-file release build completed successfully. The subsequently supplied SwiftStream log also confirms a normal release compile and link completed before the optimizer failure. This initial verification was build-based; the later runtime checks are described below.

The container build emits existing non-fatal warnings about an unhandled source file under `CustPrintEndpoint` and the `swift-nio-zlib-support` system package. They did not prevent either target from building.

## Full production build: WASM optimizer compatibility

The supplied release log shows `App.wasm` compiled and linked successfully, followed by a failure in SwiftStream's Phase 5.1. Binaryen `wasm-opt` version 91 reported `all used features should be allowed` for `i32.trunc_sat_*` and `i64.trunc_sat_*` instructions, ending with `Fatal: error validating input`.

SwiftStream invoked the optimizer with `-Os --enable-bulk-memory --enable-sign-ext`. It also needs `--enable-nontrapping-float-to-int` to accept the saturating conversion instructions emitted by the Swift 6 toolchain. This flag enables the optimizer feature and preserves its validation checks.

Changes made:

- Added `.devcontainer/wasm-opt`, a shell wrapper that forwards every original argument and adds `--enable-nontrapping-float-to-int`.
- Updated `.devcontainer/Dockerfile` to preserve the base image's optimizer at `/usr/local/libexec/wasm-opt` and install the wrapper at `/usr/local/bin/wasm-opt`.
- Applied the same installation to the active container, so the current SwiftStream release build uses the fix immediately. Future container rebuilds install it from the Dockerfile.
- Adjusted `.gitignore` to allow the Dockerfile and wrapper to be versioned while retaining the existing exclusions for local container configuration.
- Updated the source map and PWA architecture documentation with the build compatibility requirement.

The failed production artifact was successfully optimized with the additional flag into a separate temporary file, reducing it from approximately 105 MiB to 86 MiB with no optimizer diagnostics. This fix is in container build tooling; no additional `web` package commit was required.

Additional verification: the updated Dockerfile built successfully, and a fresh image optimized a minimal `trunc_sat` module using SwiftStream's original arguments through the wrapper. V8 `WebAssembly.validate` accepted the optimized production App module (89,748,264 bytes).

### Completed production packaging verification

The full SwiftStream **Release Build** command was run from the VS Code container after installing the wrapper and reported:

```text
✅ Release Build Succeeded in 4m54s
```

This run reused the successful Swift compilation artifacts, then completed WASM optimization, Gzip/Brotli compression, JavaScriptKit TypeScript, webpack bundles, manifest/index extraction, resource copying, CSS, and HTML processing. `DistPublic` was regenerated by the build; no generated files were manually patched.

Both final WASM modules pass V8 `WebAssembly.validate`. Decompressing each Gzip and Brotli file produces the exact SHA-256 digest of its corresponding uncompressed WASM. The generated `app.js`, `service.js`, `main.html`, `site.webmanifest`, and `favicon.ico` are present.

| Target | WASM | Gzip | Brotli |
|---|---:|---:|---:|
| App | 85.6 MiB | 27.7 MiB | 16.7 MiB |
| Service | 46.4 MiB | 17.2 MiB | 11.2 MiB |

Build and artifact evidence is saved under `.artifacts/verification/swift6-release-2026-11-16/` in `release-summary.log` and `artifact-validation.json`. This verifies compilation and packaging; the application was not deployed or exercised through business workflows in a browser during this check.

## Browser runtime and login UI correction — 2026-11-17

After compilation and packaging succeeded, browser validation exposed two additional problems: `WASI Exit error: 0` from the migrated async entry point, and a login page with an oversized icon, a wide unstyled card, and recovery dialogs displayed despite their `hidden` attributes.

The package's async `WebApp.main()` completed startup through Swift async-main, which called `proc_exit(0)`; the existing WASI wrapper reported that as an exception. Framework UI updates also used `Task { @MainActor ... }`, but JavaScriptKit 0.17's old main-executor hook is incompatible with the project's WASI 6.3.3 runtime; the underlying hook compatibility problem is documented in [JavaScriptKit issue 350](https://github.com/swiftwasm/JavaScriptKit/issues/350). Finally, a temporary mapped theme state passed to `Stylesheet.disabled(...)` was released immediately because the stylesheet did not own the binding. A native reproduction confirmed that changing the theme then left the stylesheet disabled.

Corrections in the `web` package:

- Added the existing JavaScriptKit `JavaScriptEventLoop` product to WebFoundation's dependencies and re-exported it.
- Added `Sources/WebFoundation/WebRuntime.swift`. On WASI with Swift 6.3 or newer, it registers a JavaScript-backed executor factory through the installed SDK's executor API, using the existing JavaScriptKit microtask/timer bridge. The adapter supports the project's current single-threaded JavaScript realm, including delayed tasks. It retains the synchronous reactor entry contract.
- Restored synchronous `WebApp.main()` and added a synchronous WASM `ServiceWorker.main()` that queues startup on `WebWorkerActor`. Native ServiceWorker startup remains async for manifest tooling.
- Made `Stylesheet` retain its disabled state and listener, cancel the old listener on rebinding/deinitialization, and ignore queued updates from a replaced binding. Callbacks capture the stylesheet weakly.
- Retained JavaScriptKit at version `0.17.0`; its package and JavaScript runtime were not upgraded or patched.

Corrections in PWASkyline:

- Made `Sources/Service/main.swift` choose the synchronous WASM or async native package entry point.
- Retained the login view's four existing mapped states for password visibility/icon and recovery-dialog visibility as view-owned lazy properties. Their expressions and authentication actions are unchanged.
- Kept the existing login theme and layout rules; restoring the theme binding and queued UI updates restores their application.

Published package commits, in order:

| Commit | Change |
|---|---|
| `1989f7a` | Browser bootstrap, event-loop dependency and stylesheet binding ownership |
| `a665be4` | Explicit worker runtime dependency import verified with a focused WASI build |
| `30d2fac` | Swift 6.3 executor factory adapter, replacing the insufficient legacy hook setup |

Both native and WASI dependency checkouts in the project resolve to `30d2fac`.

Verification completed for this correction:

- Native Web package build passed.
- Binding regression checks passed: mapped-state retention, theme update, rebinding, stale queued update rejection, and state/stylesheet deallocation.
- A small WASI executable ran through the project's existing Wasmer and JavaScriptKit runtime and printed `MAIN_ACTOR_TASK`, `DELAYED_TASK_RESUMED`, `WORKER_ACTOR_TASK`, and `EXECUTOR_PROBE_PASSED`, with no WASI exit.
- Full SwiftStream debug build passed in `41s853ms` after the executor factory correction.
- Chrome login page visually matches the supplied reference: constrained glass card, compact password icon, side-by-side buttons, and initially hidden recovery dialogs.
- Password toggle switched between a secure and plain text field and updated its icon. The recovery action opened only step 1 and closing it removed the dialog. No credentials were submitted.
- The refreshed browser console no longer reports the supplied WASI exit exception. Chrome separately reported a localhost SSL certificate error while fetching the service-worker script; local certificate trust is a separate runtime-environment concern.
- Full SwiftStream release build passed in `11m19s`, including normal optimized Swift compilation, both WASM targets, optimizer, compression, bundles, manifest, CSS/HTML and resources.
- Both corrected release modules pass V8 validation, and their Gzip/Brotli files decompress to identical content. The final debug modules and their compressed copies also pass these checks.

Current artifact and release evidence: `.artifacts/verification/swift6-runtime-2026-11-17/` (`debug-artifacts.json`, `release-artifacts.json`, `release-summary.log`). Browser/fixture observations are recorded in `.artifacts/planning/runtime-ui-2026-11-17/VALIDATION.md`.

## Authenticated work UI and packaging correction — 2026-11-17

Comparing the authenticated localhost and production `/work` pages showed that local order rows were present but counters stayed at zero, toolbar/create actions were hidden, fiscal history stayed on the new-invoice form, and order detail content was missing.

Published `web` commit **`241de079d547463978ccd60f5ee48cf1c596ea25`** repairs reactive consumer ownership:

- An explicit `StateListener.hold(in:)` keeps its input state alive until cancellation or holder release. A state holding its own listener does not retain itself.
- DOM text, attributes and element values retain their bindings in element storage. Listener callbacks capture the element weakly, and shutdown releases subscriptions.
- Typed CSS properties and values retain their input bindings. Elements/rules retain active typed properties by CSS key; replacement/shutdown releases old properties and queued updates check binding identity.
- CSS rule builders use the same property ownership path. Stored binding values receive shutdown through `Storage`.
- The mechanical conversion preserved all original callback statements and ordering across **1,067 listeners**. Mapping expressions, API contracts, permissions, order/fiscal actions and serialized values were preserved.

Four focused package tests passed with zero failures. They cover temporary mapped inputs/chains, element updates/release, cancellation, holder reuse, self-holds, shutdown, CSS replacement, CSS rule builders and numeric inputs. The same native fixture failed text/visibility/display updates before the fix and passed afterward.

Chrome verification restored the dashboard toolbar/create actions and production-matching counters **0 / 4 / 0 / 2**. **Facturación → Historial** switches to date/search/history controls and renders existing rows. Invoice **1014** opens with its details, concepts and related documents. No fiscal document was issued, canceled, paid, edited or sent.

A separate order initialization trap was traced to a stale incremental caller: `AccoutOverview.swift.o` predated the changed `Color` class, and WASM disassembly identified the mismatched `Color.description` virtual call. The WASI debug output cache was invalidated and the entire App recompiled successfully in **111.15s**. The native debug cache was also regenerated. Package class-layout updates require rebuilding callers compiled against the previous layout; a successful incremental link alone did not prove runtime compatibility.

Independent artifact checks then caught a native index-generation crash despite a successful debug build banner. `App --index` invokes launch callbacks without a browser JavaScript realm, and the app's callback accessed browser performance persistence and loader APIs. `Sources/App/App.swift` now scopes that browser-startup block to `arch(wasm32)`. Every WASM startup statement and its order are preserved. The newly linked native executable exits successfully and emits a valid index payload; `VisualPerformanceSettings` itself was not changed.

Both project dependency paths resolve `241de07`. Final verification completed:

- In the clean Chrome session, **fobo01-5003** opens its complete detail view with folio, print control, equipment, notes and charges/payments. Fiscal history and invoice 1014 were checked again. Both PDF/XML controls render; the PDF action reaches Chrome's Save dialog, which was canceled without saving. The final console contains no function-signature mismatch, WASI exit or uncaught runtime trap.
- The final normal debug build reported **Build Succeeded in 7m44s**, including time waiting for the release compile lock. Native index extraction emits a valid payload without executing browser startup code.
- Running debug/release packaging concurrently caused a separate SwiftStream temporary-file collision: both use `/tmp/app.wasm.gz`. Release's final copy step reported ENOENT even though its Swift/WASM/JS/HTML generation completed. This was an execution error, not an additional source/compiler failure. Run these packaging commands sequentially.
- The failed compression step was recovered serially with the build's installed gzip command and level, using a unique temporary path. Only **DistPublic/app.wasm.gz** needed regeneration. Original WASM hashes remained unchanged; no WASM or minified JavaScript was patched. The recovery is artifact-validated rather than represented as a new successful SwiftStream release banner.
- All four final App/Service WASM modules pass V8 validation. Every Gzip/Brotli copy decompresses to its corresponding WASM's exact SHA-256 digest. Both output folders contain `app.js`, `service.js`, `main.html` and valid `site.webmanifest` JSON.

| Output | App WASM bytes | Service WASM bytes |
|---|---:|---:|
| Debug | 365,802,777 | 64,591,795 |
| Release | 90,017,710 | 48,624,014 |

Evidence is under `.artifacts/planning/work-ui-bindings-2026-11-17/` and `.artifacts/verification/work-ui-bindings-2026-11-17/`, including package tests, browser results, native-index results, compression recovery and final artifact digests.

## Change state

- The Web package fix is committed and pushed as listed above.
- PWASkyline source/configuration changes remain in the project working tree and were not committed.
- The report includes build, WASI scheduling, artifact integrity, login and the authenticated read-only work/fiscal UI checks described above. It does not claim deployment or validation of fiscal issuance/payment/cancellation actions.
