# Modules

Current verified module and source structure for PWASkyline.

## Swift Package

- Package name: `Tierra Cero | Skyline2.0`.
- Platform declaration: macOS 11 or newer for package tooling.
- Products:
  - `App` executable.
  - `Service` executable.

## App Target

`Sources/App` contains the Swift Web browser application.

### Core Entry and Configuration

- `App.swift` — `@main` app class, lifecycle hooks, route declarations, style activation.
- `SkylineWeb.swift` — app version, API mode, global runtime variables, caches, and session-related globals.

### Feature Areas

- `API/` — typed client wrappers for auth, customer, order, account, fiscal, POC, including product-activity and Fast and Furious audit reports, route, mail, social/theme, rewards, and WebSocket API endpoints.
- `Websocket/` — real-time message handlers for chat, auth requests, mobile camera/scanner/OCR, async file/image jobs, social notifications, order/status updates, and connection lifecycle.
- `ViewControlers/` — page controllers and top-level page flows.
- `Snippits/` — reusable UI components and feature views, including Product Manager audit report presentations and velocity scoring.
- `Styles/` — Swift Web CSS style declarations.
- `Functions/`, `Extentions/`, `Enums/`, `Structurs/`, `VirtualControlers/` — shared app helpers and runtime support. Error diagnostics are owned by `ErrorReportingControler`, its record/context types, the centralized POST transport, and the API decoding helper.

## Service Target

`Sources/Service` contains the Swift service-worker executable and copied resource trees.

- `main.swift` starts the service.
- `Service.swift` defines the PWA manifest and service-worker lifecycle hooks.
- `css/`, `js/`, `images/`, and `skyline/` are copied resources.

## WebSources

`WebSources` contains JavaScript/WASI/webpack support for Swift WebAssembly output.

- `app.js` and `serviceWorker.js` are entry bootstraps.
- `errorReportingIndexedDB.js` exposes the App-only callback bridge for persistent diagnostic records.
- `wasi/` contains runtime bridge helpers.
- `webpack.config.js` emits target-specific JavaScript bundles.

## Public Output Trees

- `DevPublic` is the development public output.
- `DistPublic` is the distribution public output.

These directories should usually be treated as generated/deployable outputs, not primary source authority.

## Active Dependencies

- `swifweb/web` from `2.0.0-nightly.5`.
- Tierra Cero private packages: `TCFundamentals`, `TCFireSignal`, `MailAPICore`, `TCSocialCore`, `TaecelAPICore`, `LanguagePack`, `WaWebAPICore`, `SkylineDocumentationCore`.
- WebSources dev dependencies include webpack, JavaScriptKit local checkout bridge, and Wasmer WASI packages.
