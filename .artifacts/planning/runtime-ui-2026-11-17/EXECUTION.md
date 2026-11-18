# Runtime UI execution state

- web commit `1989f7a` pushed to origin/master: JavaScriptEventLoop dependency/re-export; synchronous WebApp WASM entry; ServiceWorker synchronous WASM entry schedules WebWorkerActor Task, native async entry remains; Stylesheet retains disabled state/listener with weak callbacks, deinit cancellation and stale-state identity guard.
- PWASkyline Service/main.swift conditional call for WASM synchronous vs native async. LoginViewcontroler retains four mapped states as lazy view-owned properties. Authentication logic and theme declarations untouched.
- Native Web package build passed (10.06s). Temporary fixture initially showed MAPPED_RETAINED=false and no theme update; after fix showed retained=true and disabled changed false. Expanded probe passed retained-state, rebind, stale task, and deallocation checks.
- Container checkouts at `.build/checkouts/web` and `.build/.wasi/checkouts/web` both resolve to 1989f7a.
- Full SwiftStream debug rebuild started via VS Code Debug Build (row Cmd+B) and currently running.
- Current SwiftStream log: `/root/.vscode-server/data/logs/20261117T055517/exthost1/output_logging_20261117T055518/1-SwiftStream.log` in container `jovial_wiles`.

## Browser state and tooling

Chrome existing tab https://localhost:7701/login reproduces screenshot. DevTools Elements open. CUA variable `chromeApp` bound to com.google.Chrome; `codeApp` bound to com.microsoft.VSCode. CUA is active; after final UI result, next CUA call must be completion_summary only.

Do not paste JavaScript into DevTools: Chrome displayed its self-XSS paste protection warning. It was NOT bypassed. Inspect DOM through Elements panel and ordinary screenshots/actions. Re-query AX before choosing indices; disabling diffing may renumber all indices. Browser tab is already authorized for the localhost cert; no interstitial bypass performed.

Browser DOM showed `.tc-login-main-root` and `[hidden]` recovery popups exist; missing login CSS made icons giant, card wide, hidden popups visible. Native fixture independently confirms stylesheet mapped state lifetime failure.

## Remaining

### Current correction (supersedes earlier bootstrap notes)

The first full debug run succeeded but runtime UI remained broken because JavaScriptKit 0.17's legacy executor hooks do not work with WASI 6.3's main executor. `WASI Exit error: 0` was gone. Replan in REPLAN-executor.md.

Web commit `30d2fac` is pushed after `1989f7a` and `a665be4`. New WebFoundation/WebRuntime.swift uses the installed WASI SDK's ExecutorFactory SPI, existing JSKit microtask/timer bridge, ordinary/delayed job handling, and a synchronous reactor entry contract. Both WebApp and ServiceWorker now call WebRuntime.installEventLoop(). Native builds remain inert for executor installation.

Tiny WASI fixture under `/tmp/pwaskyline-wasi-executor-probe` built and executed through the project's existing Wasmer/JSKit runtime in the container. Output: SYNC_START, MAIN_ACTOR_TASK, DELAYED_TASK_RESUMED, WORKER_ACTOR_TASK, EXECUTOR_PROBE_PASSED. No WASI exit. Native full package build passed (7.41s).

Package resolution of both project checkouts to `30d2fac` is running in tool exec session 87195. After completion, rerun full debug through VS Code and verify UI, then full release as needed. The last debug package had old legacy hooks, so it is NOT the final runtime result.

Finish full debug build; inspect failures if any. Reload localhost page and verify reference layout, no WASIExitError, show/hide password and open/close recovery (do not submit credentials/API actions). Complete CUA summary. Verify release as appropriate after runtime changes, update stable PWA docs and user handoff report, capture evidence and final git audit. No PWA commit authorized; package push is authorized. Web .agent docs are local ignored governance, updated runtime/CSS ownership facts already.
