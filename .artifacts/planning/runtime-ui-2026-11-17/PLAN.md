# Runtime and login UI correction

## Evidence

- WebApp.main became async in the Swift 6 migration. The browser logs its generated async-main call to proc_exit(0) as WASIExitError.
- The package adds Task-based UI updates but does not install JavaScriptKit 0.17's documented JavaScriptEventLoop executor.
- A native fixture proves a temporary State passed to Stylesheet.disabled is deallocated immediately; changing its source does not update the disabled flag.
- The browser's Elements panel confirms login root classes and hidden attributes exist, while login-specific sizing and hidden rules are absent from the applied cascade.

## Reviewed scope

Owning boundaries: PWA-001/003 and APP-002 in PWASkyline; BRIDGE-003/007, CSS-005 and package application composition in web.

1. web: add JavaScriptEventLoop through the existing WebFoundation dependency/re-export. Restore synchronous WebApp main; in WASM install the executor before starting UI work. Keep native startup synchronous.
2. web: give ServiceWorker a synchronous WASM main that installs the executor and schedules startup on WebWorkerActor. Keep its native async main for manifest extraction. PWASkyline Service/main.swift calls the corresponding entry point conditionally.
3. web: retain Stylesheet's disabled State and listener, cancel on rebind/deinit, and use weak self in the callback/task. Do not change State.map's lifetime contract.
4. PWASkyline: retain the four existing login mapped states as view-owned lazy properties. Keep the expressions and authentication actions identical.
5. Verify native binding retention and release, native entry builds, package diff and status; push only the authorized web changes and update the project's remote resolution. Build debug and verify login UI and visibility actions in the browser. Verify release targets/pipeline as appropriate, and update the report.

No theme redesign, business-rule edits, broad State refactor, or generated-file patching.

## Plan audit

Source paths and owners checked. JavaScriptEventLoop is already supplied by pinned JavaScriptKit 0.17.0. State.map intentionally uses weak references; consumer ownership is the focused correction. The native fixture can prove retention/rebinding/release. Browser validation must prove actual style and visibility behavior, beyond compilation. Service native manifest extraction must remain supported.
