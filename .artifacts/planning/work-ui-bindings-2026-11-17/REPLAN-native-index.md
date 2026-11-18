# Native index extraction

Artifact verification rejected release packaging because DistPublic/main.html is absent. The SwiftStream log shows native App index extraction traps in JavaScriptKit._decode_string, called by VisualPerformanceSettings.loadPersistedPerformanceModeIfNeeded at line 114. The native renderIndex tool intentionally runs didFinishLaunching while collecting generated index/styles.

Reviewed correction: guard only the browser JavaScript accesses in VisualPerformanceSettings with `#if arch(wasm32)`. Keep flag defaults, assignment order, persistence behavior and every browser call unchanged on WASM; native index tooling has no browser JS realm. Validate the native executable with `--index`, then regenerate both outputs through SwiftStream and require HTML plus valid compressed WASM artifacts. This is a platform boundary fix, with no order/fiscal business changes.

Call-site audit found the same didFinishLaunching block also directly calls `removeInitalElements` and starts browser session/error-reporting behavior. The smaller complete correction is to guard this browser-startup block at the App lifecycle call site, rather than individually patch each helper. Native index extraction still collects the existing route/style/index declarations; WASM startup statements and order remain identical.
