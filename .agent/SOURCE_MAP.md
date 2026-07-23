# Source Map

Repository file map for PWASkyline.

## Package and Build Metadata

| Path | Description |
|---|---|
| `Package.swift` | Swift Package manifest; defines `App` and `Service` executables and dependencies. |
| `Package.resolved` | Dependency-resolution lockfile. Edit only in dependency-change tasks. |
| `.devcontainer/` | Container development environment metadata. |
| `.vscode/` | Editor launch/settings metadata. |

## App Target Source

| Path | Description |
|---|---|
| `Sources/App/App.swift` | `@main` Swift Web app lifecycle, service-worker registration, route table, and theme switching. |
| `Sources/App/SkylineWeb.swift` | Project version, environment flags, global app/session/cache variables. |
| `Sources/App/API/` | Client API wrapper namespaces and endpoint files. |
| `Sources/App/Websocket/` | WebSocket type and message/event handlers. |
| `Sources/App/ViewControlers/` | Page controllers for app, login, work, hotline, splash, and unavailable-service flows. |
| `Sources/App/VirtualControlers/` | Shared non-visual controllers/caches, including centralized error-report lifecycle and IndexedDB bridge ownership. |
| `Sources/App/Pages/` | Swift Web page definitions. |
| `Sources/App/Snippits/` | Reusable UI snippets, forms, panels, print engines, and feature views. |
| `Sources/App/Styles/` | Swift Web style declarations (`MainStyle`, `SKMainStyle`, `SKLogInStyle`). |
| `Sources/App/TierraCeroCustomUI/` | Scoped Tierra Cero layout controls and feature themes, including the production OrderView presentation. |
| `Sources/App/Functions/` | Free functions and browser helpers, including centralized POST transport and API response decoding instrumentation. |
| `Sources/App/Extentions/` | Project extensions for Web elements and value types. |
| `Sources/App/Enums/` | App enums. |
| `Sources/App/Structurs/` | App structs and payload objects. |

## Service Target Source and Resources

| Path | Description |
|---|---|
| `Sources/Service/main.swift` | Service target entry point. |
| `Sources/Service/Service.swift` | Service worker manifest and lifecycle declarations. |
| `Sources/Service/favicon.ico` | Service target favicon resource. |
| `Sources/Service/css/` | Copied CSS resources. |
| `Sources/Service/js/` | Copied JavaScript resources. |
| `Sources/Service/images/` | Copied image resources. |
| `Sources/Service/skyline/` | Skyline static resource tree: CSS, JS, media, document icons, tutorial assets. |

## Web/WASI Bootstrap

| Path | Description |
|---|---|
| `WebSources/app.js` | JavaScript bootstrap for browser app WASM execution. |
| `WebSources/errorReportingIndexedDB.js` | Callback-based IndexedDB persistence, atomic claim, retry-state, and retention bridge exposed as `globalThis.PWASkylineErrorStore`. |
| `WebSources/serviceWorker.js` | JavaScript bootstrap for service worker WASM execution. |
| `WebSources/wasi/` | WASI support scripts and runtime bridge helpers. |
| `WebSources/webpack.config.js` | Webpack configuration for app/service worker entry output. |
| `WebSources/package.json` | Node/webpack dependencies for WebSources. |
| `WebSources/tsconfig.json` | TypeScript configuration. |

## Public Outputs

| Path | Description |
|---|---|
| `DevPublic/` | Development public output tree. Treat as generated/deployable output. |
| `DistPublic/` | Distribution public output tree. Treat as generated/deployable output. |

## Generated / User-Local State

Do not edit unless explicitly scoped:

- `.build/**`
- `.swiftpm/**`
- `WebSources/node_modules/**`
- `.DS_Store`
- `.git/**`

## Agent Governance

| Path | Description |
|---|---|
| `AGENTS.md` | Root agent router and project rules. |
| `.agent/` | Stable agent governance documentation tree. |
| `.artifacts/` | Transient plans, logs, screenshots, patches, and review evidence. |
