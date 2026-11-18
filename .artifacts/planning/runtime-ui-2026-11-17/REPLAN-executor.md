# Swift 6.3 executor compatibility

The first debug package now loads with no WASI exit error, but UI updates still do not run. Upstream JavaScriptKit issue 350 and Swift Forums topic 82269 identify the old main-executor hook as incompatible with newer Swift concurrency runtimes. The installed WASI 6.3.3 private interface provides ExecutorFactory, MainExecutor, SchedulingExecutor and _createExecutors.

Add Sources/WebFoundation/WebRuntime.swift to install a small factory adapter on wasm32 with compiler >= 6.3. It uses the existing JavaScriptKit 0.17 queueMicrotask/setTimeout bridge and the SDK's executor factory SPI. Keep synchronous framework entry points, with native behavior unchanged. Existing older compiler fallback may use the legacy installer; current supported verification is WASI 6.3.3.

The adapter is for the current single-threaded JavaScript realm. Enqueue ordinary and delayed jobs without blocking JavaScript; use weak/one-shot closure behavior already provided by JavaScriptEventLoop. Do not upgrade or patch JavaScriptKit. First compile and run a tiny WASM scheduling fixture proving MainActor tasks, delay/resumption and WebWorkerActor startup. Publish only after that passes, then regenerate both browser builds and verify UI.

Use an explicit error if a caller tries to drive a blocking Swift async-main run loop: this package's reactor contract requires synchronous entry points. Cancellation/timer behavior follows Swift executor job scheduling; delayed jobs must still run once to allow the runtime to observe cancellation.
