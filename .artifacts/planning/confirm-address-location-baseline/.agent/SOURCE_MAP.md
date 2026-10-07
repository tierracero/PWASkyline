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
| `Sources/App/API/CustSubAcctEndpoint/` | Shared subaccount create/load/update POST wrappers and account-scoped GET search exposed as `API.custSubAcctV1`. |
| `Sources/App/API/CustOrderEndpoint/CustOrder+RemoveChargeCTAM.swift`, `CustOrder+RemovePaymentCTAM.swift` | Typed order charge/payment deletion approval request wrappers. |
| `Sources/App/API/CustPOCEndpoint/CustPOC+AuditProductActivity.swift` | Typed client wrapper for the product creation, edit, image, and duplicate audit report. |
| `Sources/App/API/CustPOCEndpoint/CustPOC+AuditsVT.swift` | Typed client wrapper for the Fast and Furious product velocity report. |
| `Sources/App/Websocket/` | WebSocket type and message/event handlers. |
| `Sources/App/ViewControlers/` | Page controllers for app, login, work, hotline, splash, and unavailable-service flows. |
| `Sources/App/VirtualControlers/` | Shared non-visual controllers/caches, including centralized error-report lifecycle, IndexedDB bridge ownership, and browser speech-recognition callback/target routing. |
| `Sources/App/Pages/` | Swift Web page definitions. |
| `Sources/App/Snippits/` | Reusable UI snippets, forms, panels, print engines, and feature views. |
| `Sources/App/Snippits/CustTaskAuthRequestWaitView.swift`, `OrderView/OrderView.swift` | Approval waiting view and order charge/payment deletion permission checks; approved removals reload the order. |
| `Sources/App/Snippits/AddChargeFormView.swift`, `AddServiceFormView.swift`, `BudgetSOCView.swift`, `ConfirmProductView.swift`, `ConfirmProductViewNew.swift` | Price override entry points; each uses its caller-provided order, sale, or inventory-merma authorization context. |
| `Sources/App/Snippits/CreateNewCustomerDataView.swift` | Customer creation forms using crystal surfaces, TierraCeroCustomUI headers/controls, and the existing verification flow. |
| `Sources/App/Snippits/ManageSubCustomerAccountView.swift` | Parent-account-scoped subaccount creation/editing with optional full address/coordinate requirements; edits update then reload the saved `CustSubAcct`. |
| `Sources/App/Snippits/SearchSubCustomerView.swift` | Parent-account-scoped subcustomer search/selection, no-result creation, and required-address completion through the subaccount manager. |
| `Sources/App/Snippits/ManualAddressSearch.swift` | Crystal postal-address and coordinate lookup dialogs; returns the selected address or geocoder snapshot to its caller. |
| `Sources/App/Snippits/TripControler/TripControler+AddLocation.swift` | Dedicated fiscal-location picker; owns origin/destination presentation and location-typed item properties/callbacks. |
| `Sources/App/Snippits/TripControler/TripControler+AddMerchandise.swift` | Account/origin-aware fiscal-merchandise base picker; preserves selection and creation callbacks. |
| `Sources/App/Snippits/SearchComertialAsset.swift` | Trip commercial-asset picker over preloaded available inventory from a store, warehouse or subaccount origin; locally filters folio/name/serial. |
| `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+FastAndFurios.swift` | Ranked product revenue velocity, sales velocity, volume, and weighted score report presentation. |
| `Sources/App/Snippits/Tools/HistorySettings/Tools+HistorySettings+OrderProcessing/Tools+HistorySettings+OrderProcessing+Reports.swift` | Order report UI and CSV exports for created, closed, payment, and delivered-equipment sections. |
| `Sources/App/Styles/` | Swift Web style declarations (`MainStyle`, `SKMainStyle`, `SKLogInStyle`). |
| `Sources/App/TierraCeroCustomUI/` | Scoped Tierra Cero layout controls and feature themes, including the production OrderView presentation and persistent speech-recognition control. |
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
| `Sources/Service/skyline/` | Skyline static resource tree: CSS, JS, media, document icons, tutorial assets, and the `PWASkylineSpeech` browser bridge. |

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
