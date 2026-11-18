# Separate order initialization failure

The shared binding repair is verified in Chrome: counters and toolbar restored, fiscal history switches correctly and invoice 1014 details open. Debug build succeeded in 53s862ms using web 241de07.

Order-card clicks do reach the API/load callback, but constructing AccoutOverview traps with `RuntimeError: function signature mismatch`. Browser stack identifies `AccoutOverview.buildUI` at WASM offset 0x456374 in the current debug artifact, called from BaseContentElement.postInit and AccoutOverview.init. This disproves the assumption that all reported order symptoms share the mapped-state defect.

Reviewed next steps: map the exact failing indirect call to source and inspect its function signature; reproduce in a focused fixture if feasible. Limit any correction to initialization/actor/dispatch compatibility and preserve order data, API contracts, permissions and business actions. Rebuild debug and verify the same order, then release. Do not stack a speculative fix or mark order loading verified yet.

The failing call is confirmed as `CustFolioStatus.color.description`, loading the Color vtable method at byte offset 100. Build-cache evidence: `AccoutOverview.swift.o` is still dated 06:12, while `Color.swift.o` and `CSS.swiftmodule` were rebuilt at 14:24 after the class-layout change. The incremental build reused a caller compiled against the previous layout. Revised next step: invalidate the WASI build cache and perform a complete debug rebuild before changing any order source. The existing SwiftStream pipeline must regenerate public output; no manual WASM patch.
