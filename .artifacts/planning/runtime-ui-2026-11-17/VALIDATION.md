# Runtime correction validation

## Package

Pushed Web commits: 1989f7a, a665be4, 30d2fac. The final adapter is in 30d2fac. Both container dependency checkouts resolve to 30d2fac. Web working tree was clean after publishing.

Native package build: PASS (7.41s).

Temporary binding regression probe: PASS for state retention, theme update, rebinding, stale update rejection, and state/stylesheet release.

WASI probe: built with SDK wasm32-unknown-wasi (actual artifact triple wasm32-unknown-wasip1) and reactor flags. Executed using existing @wasmer/wasi and javascript-kit-swift 0.17.0 via the VS Code node binary. Output:

```text
SYNC_START
MAIN_ACTOR_TASK
DELAYED_TASK_RESUMED
WORKER_ACTOR_TASK
EXECUTOR_PROBE_PASSED
```

Container probe artifact: /tmp/pwaskyline-wasi-executor-probe/.build/wasm32-unknown-wasip1/debug/Probe.wasm. Runner: /tmp/pwaskyline-run-executor-probe.cjs.

## Debug/browser

Full SwiftStream debug build: PASS, 41s853ms.

Chrome https://localhost:7701/login: visibly restored the supplied reference layout (glass card at constrained width; compact eye icon; side-by-side buttons; recovery dialogs initially hidden). CUA screenshot reviewed after closing DevTools with Cmd+Option+I. Opening/closing DevTools temporarily yielded blank page screenshots; ordinary full page screenshot clearly displayed the corrected UI.

Password eye action: secure field became plain text and icon changed from hidePassword.webp to viewPassword.png. Toggling back restored the secure field.

Forgot-password action: only the username recovery dialog appeared, with Paso 1 de 2. Close removed the dialog. No credentials or API action were submitted.

Console: supplied WASI Exit error 0 no longer appeared. Separate localhost SSL error on service-worker script registration and resource preload warnings remain environment/loader diagnostics.

CUA completion summary was sent for the browser check. A new CUA part then started the full Release Build; it is currently compiling WASI release App. The next CUA completion summary is required after observing the release build result.

## Pending release

### Final result

Full SwiftStream release build PASS in 11m19s. Native window became unavailable at final observation, so the definitive SwiftStream output log was used; it reports Release Build Succeeded and all phases through HTML/additional JS. The required CUA completion summary was sent.

Both final release modules pass V8 validation. Gzip and Brotli decompress to their respective module digests. Evidence saved in `.artifacts/verification/swift6-runtime-2026-11-17/`.

App SHA-256: cfda6dceb29ed75d8d52d4632a4e991da4f89a30f95e6ba870439d5c15a4c131.
Service SHA-256: 19be4ba6da6f90e8d576375fac3d763760bffada8d26d8aaf8a5c66742b7b6e6.

Report updated; Web working tree clean; PWASkyline changes remain uncommitted as authorized. Remaining localhost certificate diagnostics are separate from the fixed startup and theme defects.

Container: jovial_wiles. Current log: /root/.vscode-server/data/logs/20261117T055517/exthost1/output_logging_20261117T055518/1-SwiftStream.log.

Finish the full Release Build, observe UI status, send CUA completion_summary, validate regenerated WASM/compressed files if successful, append current evidence to the report and complete final git audit. Do not commit PWASkyline. Preserve earlier app-wide isolation migration edits.
