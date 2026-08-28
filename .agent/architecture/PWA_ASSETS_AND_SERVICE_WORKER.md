# PWA Assets and Service Worker

Authoritative rules: `PWA-*`.

## Verified Facts

- `Sources/Service/Service.swift` defines the service worker manifest and lifecycle callbacks.
- `Package.swift` copies `favicon.ico`, `skyline`, `tutorial`, `images`, `js`, and `css` resources for the `Service` target.
- `WebSources` contains JS/WASI/webpack bootstrap files.
- The app WASI loader performs one GET per WASM target. Webpack embeds the decoded
  WASM byte length from the build artifact so Brotli/Gzip response streams can
  report accurate decoded-byte progress without a second HEAD request.
- `DevPublic` and `DistPublic` contain app/service JS, WASM, compressed WASM, HTML, manifest, favicon, and service worker outputs.
- `Sources/Service/skyline/js/speechRecognition.js` is the source-owned browser bridge exposed as `globalThis.PWASkylineSpeech`; it is copied through the existing `skyline` resource declaration and loaded only by the authenticated work shell.

## Rules

### PWA-001 — Service Target Ownership

Service-worker behavior, manifest metadata, icons, and copied resources are owned by the `Service` target and its source/resource files.

### PWA-002 — Public Outputs Are Outputs

`DevPublic/**` and `DistPublic/**` are generated/deployable output trees. Do not edit them for source-only changes unless the task explicitly requires output refresh or hotfixing deployed assets.

### PWA-003 — Path Integrity

Resource path changes must preserve manifest icon paths, service-worker registration path `./service.js`, app shell `main.html`, deep-link behavior, and static asset references.

## Implementation Guidance

- Validate both app and service-worker entry output when changing `WebSources/webpack.config.js`.
- Keep source resource updates under `Sources/Service/**` when possible.
- If editing public outputs, document whether the source files were also updated.
- Browser speech recognition requires a secure context in production (HTTPS; localhost is the normal development exception) and explicit user activation. It does not require a web-manifest microphone permission.
- PWASkyline does not currently define a restrictive microphone Permissions Policy or Content Security Policy in this repository. If deployment headers later restrict browser features, the hosting layer must allow same-origin microphone access, for example `Permissions-Policy: microphone=(self)`.
- The speech bridge must feature-detect browser support, detach recognizer handlers at session end, and never persist, upload, or automatically restart transcript capture.
