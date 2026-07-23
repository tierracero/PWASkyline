# SwifWeb 2.0 Framework and Local Implementation Study

> **Compile baseline:** `swifweb/web` `2.0.0-nightly.11`, commit `6159d951fc9411ff6168685ad4a460a3adeca241`, as resolved by every local package studied.  
> **Repository comparison:** GitHub's default `master` was inspected at `92ae621c0c7c90c305c5abbedc62bb4db39664b8`. It is an older ancestor of the resolved nightly commit, not a newer replacement.  
> **Scope rule:** “SwifWeb” below means public API in the `swifweb/web` package unless a paragraph is explicitly marked **Project helper**, **Third-party package**, or **Browser-native interop**.

## 1. Purpose and Scope

This is a source-grounded study and working guide for the SwifWeb WebAssembly framework and the SwifWeb applications under `/Users/victorcantu/Development/SwifWeb2.0`. It is intended to answer four practical questions:

1. What is actually public and implemented in the locally resolved framework?
2. How do the local applications use it in production-oriented code?
3. Which patterns can be reused without silently depending on private Tierra Cero packages?
4. Where are the version boundaries, stubs, security hazards, and browser/WASI differences?

The primary evidence is the resolved source checkout in `PWASkyline/.build/checkouts/web`, the twelve local Swift packages, their manifests and lockfiles, and the local web bootstraps. The public GitHub repository and README were used to reconcile the default branch and `webber` workflow. Generated `.build`, `DevPublic`, `DistPublic`, and `node_modules` trees were treated as outputs, not architectural sources.

This document does not modify or prescribe changes to any application source. Examples are compile-oriented for nightly.11, but browser behavior still depends on the JavaScript/WASI host and must be validated in a served WebAssembly build.

## 2. Verified Versions

| Item | Verified value | Evidence and meaning |
|---|---|---|
| Local SwifWeb resolution | `2.0.0-nightly.11` | All 12 local `Package.resolved` files |
| Local SwifWeb commit | `6159d951fc9411ff6168685ad4a460a3adeca241` | All lockfiles; resolved checkout `HEAD` |
| GitHub default branch | `master` | Repository metadata and remote refs |
| Inspected `master` commit | `92ae621c0c7c90c305c5abbedc62bb4db39664b8` | Remote `refs/heads/master`; ancestor of nightly.11 |
| JavaScriptKit | `0.17.0`, commit `dac9d7b0342c5027fc74c8d2f212f10624123a7b` | Local lockfiles |
| Local application tools version | Swift tools `5.10` | Every studied application `Package.swift` |
| Framework tools version | Swift tools `5.7` | Resolved SwifWeb `Package.swift` |
| Web bootstrap | webpack `5.91.0`, webpack-cli `5.1.4`, `@wasmer/wasi` and `@wasmer/wasmfs` `0.12.0` | `PWASkyline/WebSources/package.json`; no Node `engines` constraint is declared |

Several manifests declare a lower bound of `.nightly.5`, but SwiftPM resolves `.nightly.11`. Code must therefore be judged against the lockfile, not only the manifest constraint. Other packages declare `.nightly.11` directly. Private dependencies are commonly pinned to the mutable `main` branch over SSH; that is convenient for coordinated development but weakens reproducibility and requires Git credentials.

The exact version boundary matters. Nightly.11 adds `Index`, `Splash`, crawler/static rendering support, `PageController.title`, `metaDescription`, and `rendered`, plus DOM and preview changes that are absent from the inspected `master`. Do not copy a nightly.11 sample into a checkout of that older `master` and expect it to compile.

## 3. Architecture Overview

```text
Swift application source
        │
        ├── App executable ── imports Web ── DOM/CSS/routing/fetch/websocket
        │                                      │
        │                                      └── JavaScriptKit bridge
        │                                                │
        │                                      browser JavaScript/DOM APIs
        │
        └── Service executable ── imports ServiceWorker ── manifest/lifecycle
                                                   │
Webber/webpack host ── loads app.wasm or service.wasm through WASI + JSKit
        │
        ├── app.js starts the browser application
        ├── service.js starts the service-worker runtime
        └── generated public directory contains JS, Wasm, compressed assets,
            main.html, site.webmanifest, and project resources
```

SwifWeb is declarative at its edges but imperative underneath. `WebApp` parses its `app` property through an `AppBuilder`; `PageController` and `BaseContentElement` parse a `DOM` result builder into browser elements; `Stylesheet` parses `Rules`; and state/event wrappers retain JavaScript callbacks. The browser remains the real runtime. JavaScriptKit supplies `JSValue`, `JSObject`, `JSClosure`, and dynamic calls.

On WebAssembly, `WebApp.start()` installs global bridge callbacks, builds stylesheets, runs lifecycle startup, and routes the current browser location. On native macOS/Linux invocation, there is no browser DOM: the executable supports preview/index-generation paths such as `--previews` and `--index`. The Service target similarly emits manifest data in its non-WebAssembly path rather than behaving like a browser service worker.

The application and service worker are separate executables and separate Wasm artifacts. Registering `"service"` maps to `./service.js`; it does not run the Swift `Service` type inside the app executable.

## 4. Package and Module Map

The framework package exposes these library products:

| Layer | Products | Status |
|---|---|---|
| Foundation/interop | `WebFoundation` | Functional core; reexports JavaScriptKit |
| DOM and events | `Events`, `DOMEvents`, `DOM`, `ARIA` | Substantial public implementation |
| Styling/app shell | `CSS`, `Web` | Substantial; `Web` is the normal app import |
| Worker shells | `ServiceWorker`, `Worker`, `SharedWorker`, `WorkersAPI` | Service lifecycle works; some worker APIs are partial |
| Network/data | `FetchAPI`, `XMLHttpRequest`, `WebSocketAPI`, `StreamsAPI` | Fetch/XHR/WebSocket usable, with limitations documented below |
| Browser state | `StorageAPI`, `HistoryAPI`, `LocationAPI`, `NavigatorAPI` | Functional wrappers |
| Observer/device APIs | `ResizeObserverAPI`, plus catalog modules in §27 | Mixed: functional, partial, or explicit TODO stubs |

`Web` depends on and reexports the most commonly used surface: `WebFoundation`, `DOM`, `DOMEvents`, `CSS`, `StorageAPI`, `NavigatorAPI`, `LocationAPI`, `HistoryAPI`, and `Events`. It also links Fetch, WebSocket, XHR, and ResizeObserver, but a local manifest may name those products explicitly when a source file imports the module directly.

`WebFoundation.Storage` is **framework-internal callback/object retention**, keyed by `StorageKey`. It is not localStorage. Browser persistence lives in `StorageAPI` as `LocalStorage` and `SessionStorage`.

## 5. Project Structure

Twelve Swift package roots were found:

| Package | Role | Swift source files* | Notable dependencies/character |
|---|---:|---:|---|
| `PWA-WebTheme-Base` | Reusable production-style theme | 74 | contact flow, localization, CAPTCHA bridge, CSS |
| `PWA-WebTheme-PapaContador` | Product theme | 70 | private PapaContador API/core |
| `PWA-WebTheme-Raffle` | Product theme | 61 | Raffle API/core, components |
| `PWA-WebTheme-TierraCero/PWA-WebTheme-TierraCero` | Nested product theme package | 20 | components/fundamentals/language |
| `PWA-WebTheme-xtheme003` | Larger reusable theme | 110 | components, chat, auth helpers |
| `PWARaffle` | Minimal scaffold | 5 | only SwifWeb |
| `PWASkyline` | Large production/migration application | 1,143 | broad Skyline business modules |
| `WebThems/BaseTheme` | Duplicate/archive copy | 74 | mirrors the base theme family |
| `WebThems/xtheme003` | Duplicate/archive copy | 108 | mirrors xtheme003 family |
| `YoConTicoPWA` | Minimal scaffold | 5 | only SwifWeb |
| `antiguedadesypianos.com` | Minimal source scaffold | 5 | extra packages declared, but current app source remains scaffold-like |
| `igBaust` | Production implementation | 104 | dynamic routes, typed APIs, maps/JS bridge |

\*Counts exclude `.build`; they include App and Service Swift files. Counts describe scale, not quality or uniqueness.

The first-level `PWA-WebTheme-TierraCero` and `WebThems` directories are containers, not package roots themselves. Common package layout is:

```text
Package.swift
Package.resolved
Sources/
  App/                 # @main WebApp or main entry + pages/styles/helpers
  Service/             # @main ServiceWorker, or main.swift + Service class
  App/Resources/       # static resources copied by the build workflow
WebSources/            # JS/WASI/webpack bootstrap in larger projects
DevPublic/             # generated development output
DistPublic/            # generated release output
```

Treat `.build`, `DevPublic`, `DistPublic`, and `node_modules` as generated. In PWASkyline, `Sources/Service/main.swift` calls `Service.start()` while `Service.swift` defines a non-`@main` class; minimal projects instead put `@main` directly on `Service`.

## 6. Installation and Tooling

The official README workflow uses the `webber` command-line tool:

```bash
webber new MyApp
cd MyApp
webber serve
```

For a PWA with an App and a Service executable:

```bash
webber serve -t pwa -s Service
webber release -t pwa -s Service
```

Development entrypoints are generated under `.webber/entrypoint/dev`; release output is generated under `.webber/release`. Local projects also carry custom `WebSources`/webpack bootstraps and generated `DevPublic`/`DistPublic` folders, so first determine which workflow the project actually uses before replacing it with a generic command.

A minimal manifest shape is:

```swift
// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "ExamplePWA",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "App", targets: ["App"]),
        .executable(name: "Service", targets: ["Service"])
    ],
    dependencies: [
        .package(url: "https://github.com/swifweb/web.git", from: "2.0.0-nightly.11")
    ],
    targets: [
        .executableTarget(name: "App", dependencies: [.product(name: "Web", package: "web")]),
        .executableTarget(name: "Service", dependencies: [.product(name: "ServiceWorker", package: "web")])
    ]
)
```

Use the project lockfile in CI. A mutable private `branch: "main"` dependency can change without a manifest edit; prefer a tag, exact revision, or a committed lockfile when reproducibility matters. The examined npm bootstrap does not declare a Node engine, so the repository does not provide an authoritative Node version requirement.

## 7. Creating a Minimal App

**Example 1 — complete minimal browser app (framework API):**

```swift
import Web

@main
final class App: WebApp {
    @AppBuilder override var app: Configuration {
        Lifecycle.didFinishLaunching { app in
            print("application started")
        }

        Routes {
            Page { HomePage() }
            Page("hello") { HelloPage() }
            Page("**") { NotFoundPage() }
        }

        MainStyles()
    }
}

final class HomePage: PageController {
    @DOM override var body: DOM.Content {
        Div {
            H1("Hello from Swift and WebAssembly")
            A("Open hello").href("/hello")
        }
        .class(.page)
    }
}

final class HelloPage: PageController {
    @DOM override var body: DOM.Content {
        Button("Back").onClick { History.back() }
    }
}

final class NotFoundPage: PageController {
    @DOM override var body: DOM.Content { H1("Not found") }
}

final class MainStyles: Stylesheet {
    @Rules override var rules: Rules.Content {
        Rule(Class.page)
            .padding(all: 24.px)
            .fontFamily(FontFamilyType.systemUI)
    }
}
```

This shape is reflected in `PWARaffle`, `YoConTicoPWA`, and the current minimal source in `antiguedadesypianos.com`. An explicit `Page("**")` gives the application control over 404 UI. Without a match, the internal default responder returns a framework “Nothing has been found” page.

**Example 2 — minimal service target (framework API):**

```swift
import ServiceWorker

@main
final class Service: ServiceWorker {
    @ServiceBuilder override var body: ServiceBuilder.Content {
        Manifest
            .name("Example PWA")
            .shortName("Example")
            .description("A SwifWeb application")
            .lang("en")
            .startURL("/")
            .display(.standalone)
            .backgroundColor("#ffffff")
            .themeColor("#1d2026")
            .icons(
                .init(src: "images/192.png", sizes: .x192, type: .png),
                .init(src: "images/512.png", sizes: .x512, type: .png)
            )

        Lifecycle.install { print("service installed") }
            .activate { print("service activated") }
    }
}
```

In an app using a separate `main.swift`, omit `@main` and write `let app = Service.start()` there, as PWASkyline does. Use a valid CSS color for manifest colors; the literal `"dark"` in the current PWASkyline service source is not a standard CSS color value.

## 8. WebApp Lifecycle

`WebApp.main()` calls `start()`, establishes the shared application, parses `app`, installs stylesheets, invokes startup, and routes `window.location`. Browser location changes re-enter routing through the installed bridge/listener. The public lifecycle builder supports:

- `didFinishLaunching`
- `willTerminate`
- `didBecomeActive`
- `willResignActive`
- `didEnterBackground`
- `willEnterForeground`

**Example 3 — lifecycle and resource registration (framework API):**

```swift
import Web

@main
final class App: WebApp {
    @AppBuilder override var app: Configuration {
        Lifecycle.didFinishLaunching { app in
                app.registerServiceWorker("service") // resolves to ./service.js
                app.addScript("scripts/vendor.js")
                app.addStylesheet("styles/vendor.css")
            }
            .didBecomeActive { print("active") }
            .didEnterBackground { print("background") }

        Routes { Page { HomePage() } }
    }
}
```

Register resources during startup, not in every page load. A JavaScript global such as the service worker controller may not be ready synchronously immediately after registration; use the relevant browser callback/state rather than assuming registration equals activation.

On navigation, the current controller receives `willUnload`, is removed, then receives `didUnload`. The incoming controller receives `willLoad(with:)`, is appended, its request is assigned, then it receives `didLoad(with:)`. Because the request argument is already available to `willLoad`, prefer that argument there; the controller's `req` property is not assigned until later in the current implementation.

## 9. AppBuilder

`@AppBuilder` accepts `Lifecycle`, `Splash`, `Index`, `Routes`, and `Stylesheet` items. It supports empty blocks, multiple items, `if`, and `if/else`; it does not expose a general `buildArray`, so do not assume a raw `for` loop works inside the builder.

**Example 4 — index metadata, splash, routes, and conditional stylesheet (framework API, nightly.11):**

```swift
final class App: WebApp {
    let useExperimentalTheme = false

    @AppBuilder override var app: Configuration {
        Index()
            .lang("en")
            .title("Example")
            .meta(name: "description", "SwifWeb example")
            .link(rel: "icon", href: "/images/favicon.png")
            .script(name: "vendor", src: "/scripts/vendor.js")

        Splash(pathToHTML: "/splash.html")
        Routes { Page { HomePage() } }
        MainStyles()

        if useExperimentalTheme {
            ExperimentalStyles()
        }
    }
}
```

`Index` and `Splash` are nightly.11 APIs and are absent from the inspected older `master`. Confirm exact method overloads against the resolved checkout when constructing elaborate metadata; the fluent index builder is meant for generated/static bootstrap metadata, while `Document` and `PageController` manage live page metadata.

## 10. DOM Builder

`@DOM` builds `DOM.Content` from elements and other `DOMContent` values. It supports conditional branches. Framework `ForEach` wrappers should be used for collections because the builder does not provide a general array builder.

**Example 5 — composed DOM with conditional and repeated content (framework API):**

```swift
final class ProductList: BaseContentElement {
    let names: [String]
    let showHeading: Bool

    init(names: [String], showHeading: Bool = true) {
        self.names = names
        self.showHeading = showHeading
        super.init()
    }

    required init() {
        names = []
        showHeading = true
        super.init()
    }

    @DOM override var body: DOM.Content {
        Section {
            if self.showHeading { H2("Products") }
            ForEach(self.names) { name in
                Div(name).class(.productRow)
            }
        }
    }
}
```

`BaseContentElement` creates its underlying browser element and calls `buildUI`; its post-build path parses `body`. `appendChild` updates both the JavaScript DOM and SwifWeb parent/child bookkeeping. `remove()` detaches and sends removal lifecycle callbacks, but source inspection does not show an automatic `shutdown()` call in every removal path. Custom elements that retain timers/listeners should clean those resources in their own lifecycle.

A raw `String` used as `DOMContent` is placed in a `Div` through `innerHTML`. That makes it suitable for trusted markup only. Use a text element/`innerText` for user-controlled data.

## 11. HTML Elements and Attributes

SwifWeb exposes typed element classes (`Div`, `P`, `H1`, `A`, `Button`, `Form`, `InputText`, `InputFile`, and many more) plus fluent attributes. `Class` and `Id` are string-literal-friendly pointer types.

**Example 6 — elements, safe text, classes, IDs, and attributes (framework API):**

```swift
extension Class {
    static let card: Class = "card"
    static let cardTitle: Class = "card-title"
}

extension Id {
    static let accountCard: Id = "account-card"
}

let card = Div {
    H2("Account").class(.cardTitle)
    P().innerText("Text supplied by the application")
    A("Documentation")
        .href("/docs")
        .attribute("aria-label", "Open documentation")
}
.id(.accountCard)
.class(.card)
.attribute("data-kind", "account")
```

**Example 7 — state-bound attributes and text (framework API):**

```swift
@State var message = "Waiting"
@State var disabled = false

let status = P().innerText($message)
let action = Button("Send").disabled($disabled)
```

Typed fluent methods are preferable where available; `.attribute(name, value)` is the escape hatch. `domElement`, `jsValue`, and `view` expose the underlying JavaScript object/value. Direct mutation through them bypasses some SwifWeb state/bookkeeping and should be isolated.

`Document.querySelector`/`querySelectorAll` wrap browser selection, but the generic wrapper cannot always recover the original specialized Swift element type. Retain the Swift element when later typed access matters. The current `querySelectorAll` implementation uses a global JavaScript evaluation helper, another reason not to build core ownership around re-querying.

## 12. Reactive State

`@State` is a reference-backed property wrapper. The wrapped property is the value; `$property` is the `State<Value>` object used for binding and listening. Assigning always runs begin/listener/end triggers—even when an `Equatable` value did not change—unless consumers use change-filtered listening.

**Example 8 — state binding and derived state (framework API):**

```swift
final class CounterView: BaseContentElement {
    @State private var count = 0

    @DOM override var body: DOM.Content {
        Div {
            P().innerText(self.$count.map { "Count: \($0)" })
            Button("Increment").onClick { [weak self] in
                self?.count += 1
            }
        }
    }
}
```

**Example 9 — combine two states (framework API):**

```swift
@State var firstName = "Ada"
@State var lastName = "Lovelace"

let fullName: State<String> = $firstName.and($lastName).map { first, last in
    "\(first) \(last)"
}

let heading = H2().innerText(fullName)
```

Public operations include `listen`, `listenOnlyIfChanged` for `Equatable`, `reset`, `manualChangeNotify`, `removeAllListeners`, `merge(with:)`, `and`, and `map`. The old `CombinedDeprecatedResult` mapping form is deprecated; use the multi-argument closure shown above.

State/listener ownership deserves care:

- listener registration has no individual public cancellation token; `removeAllListeners()` removes all listeners from that state;
- closures can create retain cycles, so capture owning elements/controllers weakly;
- `merge` creates bidirectional propagation and should be used only when both sides truly share ownership;
- state updates are synchronous and are not a thread-isolation model;
- bind DOM only on the browser/Wasm path—native preview/index modes do not provide a normal browser document.

The local themes derive stylesheet visibility, metadata, and localization text from state. This is a strong reusable pattern: keep business state in the controller/application, derive presentation states, and bind them declaratively.

## 13. Events

Typed fluent handlers include `.onClick`, `.onInput`, `.onChange`, `.onKeyUp`, and `.onSubmit`. Lower-level `addEventListener` accepts event names/options and an event callback.

**Example 10 — click, input, keyboard, and submit (framework API):**

```swift
final class SearchForm: BaseContentElement {
    @State private var query = ""

    @DOM override var body: DOM.Content {
        Form {
            InputText(self.$query)
                .placeholder("Search")
                .onKeyUp { _, event in
                    if event.key == "Escape" { self.query = "" }
                }
            Button("Search").type("submit")
        }
        .onSubmit { event in
            event.preventDefault()
            self.runSearch(self.query)
        }
    }

    private func runSearch(_ text: String) {
        print("search", text)
    }
}
```

Calling a form's DOM `submit()` is not the same as dispatching a user submit event and does not itself call `preventDefault`. Always cancel the browser default explicitly when keeping navigation inside the SPA.

Source review found two retention/lifetime caveats. A standalone `EventListener` removes its browser listener in `deinit`, so retain it for as long as it must remain active. The generic `EventListenerContainer` implementation appears to remove stored handlers while dispatching its first event, making low-level handlers potentially one-shot even when `once` is false. Typed DOM handlers use a different container path in common cases. Treat persistent low-level listeners as requiring browser runtime verification for nightly.11.

## 14. CSS and Stylesheets

`Stylesheet` uses `@Rules`; `Rule` targets classes, IDs, or other selectors and fluent properties use typed values such as `24.px`, `100.percent`, and `Color`. The same `CSSRulable` modifiers are available inline on many elements.

**Example 11 — stylesheet, responsive rule, animation, and inline override (framework API):**

```swift
extension Class {
    static let panel: Class = "panel"
}

final class MainStyles: Stylesheet {
    @Rules override var rules: Rules.Content {
        Rule(Class.panel)
            .display(.flex)
            .padding(all: 24.px)
            .backgroundColor(.white)
            .animationName("fade-in")
            .animationDuration(250.ms)

        MediaRule(.all.maxWidth(833.px)) {
            Rule(Class.panel)
                .display(.block)
                .padding(all: 12.px)
        }

        Keyframes("fade-in")
            .from { Opacity(0) }
            .to { Opacity(1) }
    }
}

let panel = Div("Content")
    .class(.panel)
    .marginTop(8.px)
```

The local Base and Skyline themes demonstrate state-derived stylesheet rules and the `833px` responsive breakpoint. Keep one source of truth for shared colors/breakpoints rather than duplicating literal values across rules and inline styles.

Current framework limitations include a TODO around nested media-rule processing and internal/no-op rule insertion/deletion paths. Prefer constructing complete stylesheets at startup and using state-bound CSS properties/classes for dynamic UI instead of relying on runtime stylesheet surgery.

## 15. Routing

Routes are registered through `Routes` and `Page`. A path segment can be constant, a named parameter (`:id`), a single-segment wildcard (`*`), or a catchall (`**`). The trie prioritizes constant, parameter, wildcard, then catchall; therefore a catchall declared before a named route does not shadow that named route. Duplicate identical routes are different: the later registration replaces the earlier one and emits a warning.

**Example 12 — root, parameter, wildcard, catchall, query, and history (framework API):**

```swift
Routes {
    Page { HomePage() }
    Page("orders/:id") { OrderPage() }
    Page("assets/*") { AssetPage() }
    Page("**") { NotFoundPage() }
}

final class OrderPage: PageController {
    @State private var orderID = ""

    override func willLoad(with req: PageRequest) {
        super.willLoad(with: req)
        orderID = req.parameters.get("id") ?? ""
        let tab = (try? req.query.get(String.self, at: "tab")) ?? "summary"
        print(orderID, tab, req.hash)
    }

    @DOM override var body: DOM.Content {
        Button("Open next").onClick {
            History.pushState(path: "/orders/next?tab=details")
        }
    }
}
```

`Request` exposes path, search, hash, query, route, and parameters. Parameter containers support typed retrieval. A catchall must be the last path component; the matched remainder can be consumed through `getCatchall()`. Route groups and synchronous middleware are available for shared prefixes/interception. Middleware returns a controller synchronously—it is not an async networking pipeline.

Fragment routes let an existing page controller respond to a changed subpath without unloading the entire page. Use them for tabs/detail panes only when the owning controller genuinely controls that URL region; otherwise a normal page route is easier to reason about.

**Example 13 — browser history helpers (framework API):**

```swift
History.pushState(path: "/settings")
History.replaceState(path: "/settings/profile")
History.back()
History.go(-2)
```

History mutation and route rendering are connected by SwifWeb's location bridge. Avoid using both raw `window.history` and SwifWeb helpers for the same transition unless you also reproduce the expected route notification.

## 16. Page Controllers

`PageController` is a `BaseContentElement` whose root tag is a `div`. Override `body`, then use load/unload hooks for request-scoped work and cleanup. The old name `ViewController` is an unavailable renamed alias.

**Example 14 — request-aware controller lifecycle (framework API):**

```swift
final class CustomerPage: PageController {
    @State private var customerID = ""
    @State private var status = "Loading…"

    override func willLoad(with req: PageRequest) {
        super.willLoad(with: req)
        customerID = req.parameters.get("id") ?? ""
        title = "Customer \(customerID)"
        metaDescription = "Customer details"
    }

    override func didLoad(with req: PageRequest) {
        super.didLoad(with: req)
        status = "Ready"
    }

    override func willUnload() {
        stopTimersAndListeners()
        super.willUnload()
    }

    @DOM override var body: DOM.Content {
        Main { H1().innerText(self.$title); P().innerText(self.$status) }
    }

    private func stopTimersAndListeners() {}
}
```

The closure initializer is useful for small pages:

```swift
Page("about") {
    PageController { controller in
        Main { H1("About"); Button("Back").onClick { History.back() } }
    }
}
```

Nightly.11 supplies state-backed `title` and `metaDescription`; they write to `Document`. `rendered(.expirable, expiresIn:lastModifiedAt:)` and `.static` signal crawler/static-render completion in the nightly host bridge. They are not general browser rendering callbacks and are absent from the inspected `master`.

Use the `req` method argument in `willLoad`; use `self.req` only from `didLoad` or later. Cancel intervals, WebSockets, and external JS listeners in `willUnload`/`didUnload`; controller removal alone is not a reliable cancellation mechanism for project-owned resources.

## 17. Localization

SwifWeb itself does not expose a localization product in the inspected package. The local applications use **third-party/private `LanguagePack` types plus project helpers**, often choosing a language from browser storage and binding translated strings through state. Do not present `LString`, application language enums, or translation-loading APIs as SwifWeb framework features.

A framework-only boundary can remain simple:

**Example 15 — project-owned localization state over SwifWeb (project pattern):**

```swift
import Web

enum Language: String { case en, es }

final class CopyStore {
    @State var language: Language = .en

    func text(en: String, es: String) -> State<String> {
        $language.map { $0 == .es ? es : en }
    }
}

let copy = CopyStore()
let greeting = H1().innerText(copy.text(en: "Welcome", es: "Bienvenido"))
```

Persist only a stable language identifier and validate it on load. The Base theme's broader pattern—storage selection, language-pack lookup, then state-bound metadata and UI—is reusable, but its exact APIs belong to private packages.

## 18. Browser Storage

`LocalStorage` and `SessionStorage` are public wrappers around browser Web Storage. Both store strings in browsers, are synchronous, and are accessible to JavaScript running in the same origin. Session storage is tab-scoped, not a secure vault.

**Example 16 — storage, parsing, and notifications (framework API):**

```swift
LocalStorage.set("es", forKey: "language")
let language = LocalStorage.string(forKey: "language") ?? "en"

LocalStorage.set(String(25), forKey: "page-size")
let pageSize = LocalStorage.string(forKey: "page-size").flatMap(Int.init) ?? 20

LocalStorage.shared.onChange { key, oldValue, newValue in
    print("changed", key, oldValue, newValue)
}
LocalStorage.shared.onClear { print("storage cleared") }

SessionStorage.set("checkout", forKey: "flow")
LocalStorage.removeItem(forKey: "page-size")
```

The framework's `integer(forKey:)` and `double(forKey:)` test for a JavaScript number, but native Web Storage `getItem` normally returns a string. Reading a string and parsing in Swift is therefore the portable pattern.

Local projects currently persist authentication-related values. That may be a deliberate system tradeoff, but any injected same-origin script can read them. Never log tokens, include them in URLs, or describe localStorage as encrypted/secure. Prefer short-lived credentials, strict CSP, careful HTML handling, and server-side revocation. Storage change callbacks registered by the framework have no individual removal token; avoid repeatedly registering them from short-lived pages.

## 19. JavaScript Interop

`WebFoundation` reexports JavaScriptKit. `JSValue`, `JSObject.global`, dynamic members, optional JavaScript functions, `JSClosure`, and `JSPromise` are the core escape hatches.

**Example 17 — call a browser/global function safely (browser-native interop):**

```swift
import Web

func showAlert(_ message: String) {
    _ = JSObject.global.alert.function?.callAsFunction(message)
}

func callOptionalAnalytics(_ name: String) {
    _ = JSObject.global.analyticsTrack.function?.callAsFunction(name)
}
```

**Example 18 — install and retain a Swift callback for JavaScript (browser-native interop):**

```swift
final class JavaScriptBridge {
    private var closure: JSClosure?

    func install() {
        let callback = JSClosure { arguments in
            print(arguments.first?.string ?? "")
            return .undefined
        }
        closure = callback
        JSObject.global.onSwiftMessage = callback.jsValue
    }

    func uninstall() {
        JSObject.global.onSwiftMessage = .undefined
        closure = nil
    }
}
```

Retain callbacks for as long as JavaScript can call them, and remove the global on teardown. Use optional function access instead of force-unwrapping globals that depend on an external script. Local CAPTCHA/maps integrations illustrate the technique, but their global names, keys, URLs, and private helper types are project-specific.

`WebJSValue` differs by target: it represents `JSValue` on wasm32 and a printable `String` in native preview paths. Code that assumes a live JS object must be guarded for WebAssembly.

## 20. FetchAPI

`Fetch` is callback-based in nightly.11. A fulfilled fetch includes HTTP 4xx/5xx responses, so inspect `response.ok`/`status`; only transport/promise failures enter the outer failure case.

**Example 19 — GET text (framework API):**

```swift
import FetchAPI

Fetch("/api/health") { result in
    switch result {
    case .failure(let error):
        print("transport error", error)
    case .success(let response):
        guard response.ok else {
            print("HTTP", response.status, response.statusText)
            return
        }
        response.text { print($0) }
    }
}
```

**Example 20 — Codable JSON GET (framework API):**

```swift
struct Profile: Codable { let id: Int; let name: String }

Fetch("/api/profile") { result in
    guard case .success(let response) = result, response.ok else { return }
    response.json(as: Profile.self) { decoded in
        switch decoded {
        case .success(let profile): print(profile.name)
        case .failure(let error): print("decode", error)
        }
    }
}
```

**Example 21 — JSON POST with authorization (framework API):**

```swift
struct CreateNote: Codable { let title: String; let body: String }
struct Note: Codable { let id: Int; let title: String; let body: String }

func createNote(_ request: CreateNote, bearerToken: String,
                completion: @escaping (Result<Note, Error>) -> Void) {
    do {
        let data = try JSONEncoder().encode(request)
        guard let json = String(data: data, encoding: .utf8) else {
            throw EncodingError.invalidValue(request, .init(
                codingPath: [], debugDescription: "Request is not UTF-8"))
        }
        let options = RequestOptions()
            .method(.post)
            .header("Content-Type", "application/json")
            .header("Authorization", "Bearer \(bearerToken)")
            .body(json)

        Fetch("/api/notes", options) { result in
            switch result {
            case .failure(let error): completion(.failure(error))
            case .success(let response):
                guard response.ok else {
                    completion(.failure(HTTPError(status: response.status)))
                    return
                }
                response.json(as: Note.self, completion)
            }
        }
    } catch { completion(.failure(error)) }
}

struct HTTPError: Error { let status: Int }
```

**Example 22 — URL-encoded and multipart bodies (framework API):**

```swift
let fields = URLSearchParams("")
fields.append("query", "swift wasm")
fields.append("limit", "10")

Fetch("/api/search", RequestOptions()
    .method(.post)
    .header("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8")
    .body(fields)) { _ in }

func upload(_ file: File) {
    let form = FormData()
    form.append("caption", "Receipt")
    form.append("file", file, filename: file.name)

    // Do not set Content-Type manually; the browser adds the multipart boundary.
    Fetch("/api/files", RequestOptions().method(.post).body(form)) { result in
        print(result)
    }
}
```

`RequestOptions` supports method, headers, body, mode, credentials, a string cache mode, redirect, referrer, and integrity. Although a `RequestCache` enum exists, this version's option takes `String`. Its conversion also calls `Console.dir`, so request options may appear in the console; do not place secrets in debug output. `AbortController.abort()` is an empty stub and `RequestOptions` has no signal property, so Fetch cancellation is not implemented by the public wrapper.

## 21. XMLHttpRequest

XHR remains useful for upload/download progress and for the local legacy typed transports. Open first, set headers, attach handlers, then send.

**Example 23 — JSON XHR with progress and status handling (framework API):**

```swift
import XMLHttpRequest

func postJSON(_ json: String, to url: String,
              completion: @escaping (Result<String, Error>) -> Void) {
    let xhr = XMLHttpRequest(uploading: true)
    xhr.open(method: "POST", url: url)
        .setRequestHeader("Content-Type", "application/json")
        .onProgress { event in
            if event.lengthComputable {
                print("downloaded", event.loaded, "of", event.total)
            }
        }
        .onError { _ in completion(.failure(TransportError.failed)) }
        .onTimeout { _ in completion(.failure(TransportError.timedOut)) }
        .onLoad { _ in
            guard (200..<300).contains(xhr.status) else {
                completion(.failure(HTTPError(status: xhr.status)))
                return
            }
            completion(.success(xhr.responseText ?? ""))
        }

    // Nightly.11 setTimeout has inverted unit conversion; set browser ms directly.
    xhr.jsValue.timeout = 120_000.jsValue
    xhr.send(json)
}

enum TransportError: Error { case failed, timedOut }
```

The direct `jsValue.timeout` line is **browser-native interop used to bypass a verified framework bug**: `setTimeout(_:)` says seconds but assigns `time / 1000` to a browser field measured in milliseconds. If a future framework version fixes it, remove the workaround after verification.

`responseType` can select text, JSON, Blob, ArrayBuffer, or document; `upload` exposes upload progress. XHR callbacks can race (timeout/error/load-end). Project wrappers should use a single completion gate so callers receive exactly one result.

## 22. Typed API Endpoint Pattern

SwifWeb provides transports, not an opinionated endpoint layer. Tierra Cero packages add **project/private endpoint helpers** such as generic `sendPost` functions, API namespace aliases, generated request/response models, auth headers, and error reporting. A reusable public-project pattern is:

**Example 24 — typed endpoint over framework Fetch (project-owned abstraction):**

```swift
struct Endpoint<RequestBody: Encodable, ResponseBody: Decodable> {
    let path: String
    let method: RequestMethod
}

final class APIClient {
    let baseURL: String
    var bearerToken: () -> String?

    init(baseURL: String, bearerToken: @escaping () -> String?) {
        self.baseURL = baseURL
        self.bearerToken = bearerToken
    }

    func send<Body, Output>(_ endpoint: Endpoint<Body, Output>, body: Body,
                            completion: @escaping (Result<Output, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(body)
            guard let text = String(data: data, encoding: .utf8) else {
                throw ClientError.nonUTF8
            }
            let options = RequestOptions()
                .method(endpoint.method)
                .header("Content-Type", "application/json")
                .body(text)
            if let token = bearerToken() {
                _ = options.header("Authorization", "Bearer \(token)")
            }
            Fetch(baseURL + endpoint.path, options) { result in
                switch result {
                case .failure(let error): completion(.failure(error))
                case .success(let response):
                    guard response.ok else {
                        completion(.failure(HTTPError(status: response.status)))
                        return
                    }
                    response.json(as: Output.self, completion)
                }
            }
        } catch { completion(.failure(error)) }
    }
}

enum ClientError: Error { case nonUTF8 }
```

Keep base URLs, authentication lookup, retries, telemetry, and error decoding in the client—not every page. Do not log bodies or headers indiscriminately. PWASkyline's current worktree contains a consolidated XHR transport with timeout/reporting/completion gating; it is a local migration artifact, not framework API, and its exact server/auth details are intentionally omitted here.

## 23. WebSockets

The wrapper supports connect, open/error/message/close callbacks, readiness, queued-byte count, text/Blob/ArrayBuffer send, and close.

**Example 25 — owned WebSocket connection (framework API):**

```swift
import WebSocketAPI

final class LiveConnection {
    private var socket: WebSocket?
    private var intentionallyClosed = false

    func connect(url: String) {
        intentionallyClosed = false
        let socket = WebSocket(url)
            .onOpen { print("connected") }
            .onMessage { event in
                switch event.data {
                case .text(let text): print(text)
                case .arrayBuffer(let buffer): print(buffer)
                case .blob(let blob): print(blob)
                case .unknown: print("unknown message")
                }
            }
            .onError { _ in print("socket error") }
            .onClose { [weak self] event in
                guard self?.intentionallyClosed == false else { return }
                self?.scheduleReconnect()
            }
        self.socket = socket
    }

    func send(_ text: String) {
        guard socket?.readyState == .open else { return }
        socket?.send(text)
    }

    func disconnect() {
        intentionallyClosed = true
        socket?.close(1000, "page closed")
        socket = nil
    }

    private func scheduleReconnect() { /* project-owned backoff/timer */ }
}
```

PWASkyline's controller adds token lookup, typed message dispatch, a heartbeat, and randomized reconnect. The case study exposes important production concerns: cancel heartbeat/reconnect timers, distinguish intentional from abnormal closure, add bounded exponential backoff/jitter, never log token-bearing URLs or message payloads by default, and provide explicit shutdown from page/app lifecycle.

The framework's binary type source uses `"arrayBuffer"` and even contains a `FUTUREFIX`; the browser standard value is lowercase `"arraybuffer"`. Treat `.binaryType = .arrayBuffer` as a nightly.11 bug requiring direct browser validation or a narrowly isolated JS interop workaround.

## 24. Forms and File Uploads

Input elements expose typed state. `InputText($state)` provides two-way binding. `InputFile.files` is a read-only-from-caller state populated on browser change.

**Example 26 — validated form and selected-file upload (framework API):**

```swift
final class ContactForm: BaseContentElement {
    @State private var email = ""
    @State private var message = ""
    @State private var busy = false
    private let fileInput = InputFile()

    @DOM override var body: DOM.Content {
        Form {
            InputEmail(self.$email).required(true).placeholder("Email")
            TextArea(self.$message).required(true).placeholder("Message")
            self.fileInput.accept("image/*", "application/pdf")
            Button("Send").type("submit").disabled(self.$busy)
        }
        .onSubmit { [weak self] event in
            event.preventDefault()
            self?.submit()
        }
    }

    private func submit() {
        guard !email.isEmpty, !message.isEmpty, !busy else { return }
        busy = true

        let form = FormData()
        form.append("email", email)
        form.append("message", message)
        if let file = fileInput.files.first {
            form.append("attachment", file, filename: file.name)
        }

        Fetch("/api/contact", RequestOptions().method(.post).body(form)) { [weak self] result in
            self?.busy = false
            print(result)
        }
    }
}
```

Browser validation attributes improve UX but do not replace server validation. Restrict accepted types/sizes in the UI, revalidate server-side, sanitize filenames, and do not set the multipart `Content-Type` boundary yourself. `File` wraps a browser file; the normal public path is `InputFile.files`, not constructing an arbitrary browser `File` from Swift bytes.

The Base theme's contact form combines bound inputs, local validation, CAPTCHA, a loading state, a private typed API, reset, and success/error UI. Reuse the state machine, but keep CAPTCHA site keys and server details outside source/docs and label its helper as project/private rather than SwifWeb.

## 25. PWA Manifest

`Manifest` is a `ServiceBuilder` item and a fluent `Codable` model. Verified properties include `name`, `short_name`, description, direction, language, `start_url`, display, background/theme colors, icons, categories, IARC rating, orientation, related applications, scope, screenshots, and shortcuts.

**Example 27 — richer manifest (framework API):**

```swift
Manifest
    .name("Warehouse Console")
    .shortName("Warehouse")
    .description("Inventory and fulfillment")
    .lang("en")
    .startURL("/")
    .scope("/")
    .display(.standalone)
    .orientation(.any)
    .backgroundColor("#ffffff")
    .themeColor("#15324a")
    .icons(
        .init(src: "images/icon-192.png", sizes: .x192, type: .png),
        .init(src: "images/icon-512.png", sizes: .x512, type: .png)
    )
```

The encoder maps Swift names to standard keys such as `short_name`, `start_url`, `background_color`, `theme_color`, and `prefer_related_applications`. A manifest is metadata, not a cache policy. Validate that every referenced asset exists in the generated public root and that `startURL`/`scope` match the deployment base path. Test installability in the target browser; successful JSON encoding alone does not establish PWA installability.

## 26. Service Workers

`ServiceWorker` parses a `ServiceBuilder` containing `Manifest` and a lifecycle. Verified fluent callbacks include install, activate, fetch, message, push, sync, and content-delete style events. In nightly.11 these callbacks generally expose no event payload, so a fetch handler cannot use a typed event's `respondWith` and a push handler cannot read typed push data through this builder.

**Example 28 — supported lifecycle shell (framework API):**

```swift
import ServiceWorker

@main
final class Service: ServiceWorker {
    @ServiceBuilder override var body: ServiceBuilder.Content {
        Manifest.name("Example").startURL("/").display(.standalone)

        Lifecycle
            .install { print("install") }
            .activate { print("activate") }
            .message { print("message") }
            .fetch { print("fetch observed") }
            .push { print("push observed") }
    }
}
```

This is an event-observation shell, not a cache-first implementation. Source inspection found the framework `Cache`/`CacheStorage` surfaces to be TODO stubs, `PushManager` to be a TODO stub, and `PushEvent` unfinished. A truthful framework-only cache or push-data recipe therefore cannot be supplied for nightly.11.

**Example 29 — cache-first boundary when required (browser-native service-worker JavaScript, not SwifWeb API):**

```javascript
self.addEventListener("fetch", event => {
  event.respondWith(
    caches.match(event.request).then(cached =>
      cached || fetch(event.request).then(response => {
        const copy = response.clone();
        caches.open("app-v1").then(cache => cache.put(event.request, copy));
        return response;
      })
    )
  );
});
```

Use this only in a deliberately owned JavaScript service-worker layer and coordinate it with SwifWeb's generated service bootstrap; do not register two competing fetch handlers without defining precedence. Cache versioning, offline fallback, update activation, and deletion are application policy. A future SwifWeb version may make this fallback unnecessary.

The PWASkyline bootstrap forwards browser service-worker events into the Wasm runtime after it reports installation. If Wasm startup fails, current JavaScript logs the error while its readiness polling can continue indefinitely. Add fail-fast/error state when evolving that bootstrap. The App's `registerServiceWorker("service")` expects `./service.js`; generated Wasm and resource files must be deployed with the JS wrapper.

Notifications have useful wrappers (permission request and registration display), but permission must be requested in an appropriate user gesture and a service worker still needs browser support/secure context. Never imply that declaring a push lifecycle callback creates a push subscription.

## 27. Browser API Catalog

Status is based on public surface plus implementation inspection at nightly.11, not merely the existence of a product.

| Product | Main public surface | Status at nightly.11 | Notes |
|---|---|---|---|
| `ARIA` | roles and ARIA attributes | Functional declarative layer | Browser semantics still require accessible structure/testing |
| `BeaconAPI` | — | TODO stub | No reusable public example |
| `BluetoothAPI` | — | TODO stub | No public wrapper; browser support/permission varies |
| `BroadcastChannelAPI` | — | TODO stub | Use browser-native interop only if needed |
| `CanvasAPI` | — | TODO stub | No public drawing wrapper |
| `ChannelMessagingAPI` | `MessagePort` | Very partial | Source includes TODO; validate before adoption |
| `ClipboardAPI` | — | TODO stub | Secure context and user gesture generally required |
| `ContentIndexAPI` | `ContentIndex` | Partial | Source contains TODO; experimental browser support |
| `FetchAPI` | `Fetch`, request/response, headers/body data | Functional with gaps | Callback-only; no abort signal; HTTP errors require explicit check |
| `FullscreenAPI` | — | TODO stub | Browser-native fallback requires user gesture |
| `GamepadAPI` | — | TODO stub | No public wrapper |
| `GeolocationAPI` | — | TODO stub | No public wrapper; secure context/permission required |
| `HistoryAPI` | push/replace/back/forward/go | Functional | Use SwifWeb bridge-aware navigation |
| `IndexedDB` | — | TODO stub | No public database wrapper |
| `IntersectionObserverAPI` | — | TODO stub | No public observer wrapper |
| `LocationAPI` | reactive/window location fields | Functional | Navigation semantics are browser-origin dependent |
| `MediaCapabilitiesAPI` | — | TODO stub | No public wrapper |
| `MediaStreamAPI` | — | TODO stub | No public wrapper; permissions required |
| `NavigationTimingAPI` | — | TODO stub | No public wrapper |
| `NavigatorAPI` | navigator, service-worker registration/container | Substantial/partial | Includes cross-module integrations; validate browser availability |
| `NotificationsAPI` | permission and notification wrappers | Functional but partial | Secure context, user gesture, permission; some TODO/visibility limits |
| `PaymentRequestAPI` | — | TODO stub | No public wrapper; merchant/browser constraints apply |
| `PeriodicBackgroundSynchronizationAPI` | — | TODO stub | No public wrapper; highly browser-dependent |
| `PictureInPictureAPI` | — | TODO stub | No public wrapper |
| `PushAPI` | subscription wrappers, push types | Incomplete | `PushManager`/`PushEvent` TODO; no end-to-end recipe |
| `ResizeObserverAPI` | observer and entries | Substantial, with TODO | Retain observer/callback and disconnect at teardown |
| `StorageAPI` | local/session storage | Functional | Strings, synchronous, same-origin JS-readable |
| `StreamsAPI` | readable/writable stream wrappers | Substantial/partial | Some TODOs; test each stream path |
| `WebSocketAPI` | socket/events/messages | Functional with binary-type bug | Own reconnect/heartbeat/cancellation policy |
| `WorkersAPI` | workers, worker globals/events | Substantial/partial | Several TODOs and host differences |
| `XMLHttpRequest` | XHR, events, progress, body types | Functional with timeout bug | Completion gating and HTTP status handling are project concerns |
| `ServiceWorker` | builder, manifest, lifecycle | Partial | Events work; cache/push payload APIs are incomplete |
| `Worker` / `SharedWorker` | executable shells | Partial | Separate worker runtime; verify intended bootstrap |

Module presence must never be used as a support claim. For stub modules, either add a small, isolated JavaScriptKit adapter with browser feature detection or choose a maintained external package; record that boundary in the consuming project.

## 28. Local Implementation Case Studies

### Minimal scaffolds: PWARaffle, YoConTicoPWA, antiguedadesypianos.com

`PWARaffle` and `YoConTicoPWA` are effectively the same five-file teaching scaffold: a `WebApp`, three pages, and an `@main Service`. They demonstrate lifecycle registration, root/hello/catchall routing, `History.back`, a manifest, and service lifecycle logging. `antiguedadesypianos.com` currently has the same minimal source shape despite declaring additional packages; it should not be cited as evidence that those dependencies are integrated.

Use these projects for onboarding and baseline compilation. Do not infer production architecture, authentication, cache policy, or error handling from them.

### PWA-WebTheme-Base

The Base theme is the clearest reusable production-style study:

- an App namespace aliases private API/core types;
- startup registers the service and an external CAPTCHA script;
- metadata and text are derived from localization state;
- routes include constants, dynamic `c/:code`, and catchall behavior;
- `MainStyle` demonstrates class rules, responsive media rules, and keyframes;
- `SendContactFormView` models input binding, validation, CAPTCHA, loading, private API completion, reset, and success/error UI;
- `HCaptchaView` is a project JavaScript bridge, not framework API.

Two local cautions are worth preserving: `configure()` registers a key listener but no call site was observed in the inspected source, and a route contains the spelling `:csode`, so parameter names must be verified rather than guessed. Private transport code in a resolved dependency uses XHR and typed decoding but also contains hard-coded environment assumptions and payload logging; reuse its generic shape, not those operational details.

### Theme variants and archive copies

`PWA-WebTheme-PapaContador`, `PWA-WebTheme-Raffle`, nested `PWA-WebTheme-TierraCero`, and `PWA-WebTheme-xtheme003` are fuller product/theme variants with private business modules. `WebThems/BaseTheme` and `WebThems/xtheme003` are duplicate/archive copies, so searching all directories can double-count an implementation. Choose an active package root before making conclusions or changes.

### PWASkyline

PWASkyline is the large production/migration case: more than a thousand Swift source files spanning service orders, POS, inventory, fiscal documents, Carta Porte, messaging/mail/social integrations, routes, documentation, rewards, and helpers. Its App coordinates environment setup, service registration, error reporting, state-driven themes, localization/session behavior, and a very large route table. Private package aliases define its backend contract.

The current worktree is an active migration with many unrelated user edits. Source-observed patterns include:

- centralized XHR transport/error reporting and completion gating;
- application/theme state controlling multiple stylesheets;
- extensive storage-backed session behavior;
- a WebSocket controller with authentication, heartbeat, typed dispatch, and reconnect;
- a separate service entrypoint plus custom JS/WASI service bootstrap;
- generated development/release artifacts and large static resources.

The WebSocket implementation should evolve toward explicit shutdown, heartbeat cancellation, intentional-close handling, bounded backoff, and redacted logging. Transport behavior should define whether non-2xx data is decoded as a domain error or rejected before callback. PWASkyline's local TODO/migration notes are evidence of incomplete convergence, not framework defects by themselves.

### igBaust

igBaust is a useful mid-sized production example. It combines dynamic routing, typed private APIs, SwifWeb XHR, and maps/JavaScript bridges. It demonstrates how browser-native integrations can be encapsulated behind Swift views/controllers. Its exact API and map helpers are project/private; the reusable principle is a narrow adapter with lifecycle ownership and feature checks.

### Custom web bootstrap

PWASkyline's webpack entry chooses `app.js` or `serviceWorker.js`, produces `${target}.js`, and enables source maps in development. `app.js` creates WASI/WasmFs imports, fetches `${target}.wasm`, reports progress, combines JavaScriptKit imports, and starts/initializes the module. The current loader should fail explicitly on non-success HTTP responses; progress handling does not replace response validation. The service bootstrap forwards install/activate/fetch/etc. and polls for Wasm readiness; give startup failure a terminal state to avoid endless polling.

## 29. Reusable Recipes

The following recipes combine the verified primitives without importing private Tierra Cero packages.

**Example 30 — query parameters (framework API):**

```swift
override func willLoad(with req: PageRequest) {
    let filter = (try? req.query.get(String.self, at: "filter")) ?? "all"
    let page = (try? req.query.get(Int.self, at: "page")) ?? 1
    print(filter, page)
}
```

**Example 31 — authenticated request without URL token leakage (framework API):**

```swift
let options = RequestOptions()
    .header("Authorization", "Bearer \(token)")
    .credentials(.sameOrigin)
Fetch("/api/account", options) { result in /* handle status and decoding */ }
```

**Example 32 — debounced input (framework + project ownership):**

```swift
final class SearchBox: BaseContentElement {
    @State private var query = ""
    private var generation = 0

    @DOM override var body: DOM.Content {
        InputSearch(self.$query).onInput { [weak self] in self?.schedule() }
    }

    private func schedule() {
        generation += 1
        let expected = generation
        Dispatch.asyncAfter(0.3) { [weak self] in
            guard let self, expected == generation else { return }
            performSearch(query)
        }
    }

    private func performSearch(_ value: String) {}
}
```

This is logical cancellation, not timer cancellation. Note that native `Dispatch.asyncAfter` currently truncates seconds through an integer conversion; the browser path uses `setTimeout` and preserves fractional seconds.

**Example 33 — loading/error/content state (framework API):**

```swift
enum LoadState { case idle, loading, loaded(String), failed(String) }
@State var loadState: LoadState = .idle

let content = $loadState.map { state -> String in
    switch state {
    case .idle: return ""
    case .loading: return "Loading…"
    case .loaded(let value): return value
    case .failed(let message): return "Error: \(message)"
    }
}
let status = P().innerText(content)
```

**Example 34 — external script with readiness check (framework + browser-native interop):**

```swift
Lifecycle.didFinishLaunching { app in
    app.addScript("https://example.invalid/sdk.js")
}

func useSDK() {
    guard let start = JSObject.global.vendorSDK.start.function else {
        print("SDK not ready")
        return
    }
    _ = start.callAsFunction(optionalThis: JSObject.global.vendorSDK.object)
}
```

Replace the placeholder origin and add CSP/SRI policy appropriate to the real vendor. Script insertion is asynchronous.

**Example 35 — accessible disclosure (framework API):**

```swift
@State var expanded = false

let details = Div("Details").id("details").hidden($expanded.map { !$0 })
let button = Button("Toggle details")
    .attribute("aria-controls", "details")
    .attribute("aria-expanded", expanded, .trueFalse)
    .onClick { expanded.toggle() }
$expanded.listen { button.attribute("aria-expanded", $0, .trueFalse) }
```

Using a fixed ID keeps `aria-controls` synchronized with its target; the state listener keeps visibility and `aria-expanded` synchronized. The generic `attribute` method does not accept `State<String>` directly. Prefer typed ARIA modifiers from `ARIA` where their nightly.11 overload matches the element.

**Example 36 — route-owned cleanup checklist (project pattern):**

```swift
final class LivePage: PageController {
    private let connection = LiveConnection()
    private var listener: EventListener?

    override func didLoad(with req: PageRequest) {
        super.didLoad(with: req)
        connection.connect(url: "wss://example.invalid/live")
    }

    override func willUnload() {
        connection.disconnect()
        listener = nil
        super.willUnload()
    }
}
```

**Example 37 — browser feature detection (browser-native interop):**

```swift
if !JSObject.global.ResizeObserver.isUndefined {
    // Construct the SwifWeb ResizeObserver wrapper here.
} else {
    // Provide a layout fallback.
}
```

Feature detection is required even when a framework product exists; browser versions, secure contexts, permissions, and worker/window globals differ.

## 30. Common Problems and Pitfalls

| Problem | Verified cause | Recommended response |
|---|---|---|
| Code compiles against a manifest lower bound but not another checkout | lockfile is nightly.11; inspected `master` is older and lacks nightly APIs | Use/commit lockfile and state the compile baseline |
| `Index`, `Splash`, page metadata, or `rendered` is missing | absent from inspected `master` | Gate/remove it or use nightly.11 |
| Fetch treats 404/500 as success | browser fetch resolves HTTP responses | Check `response.ok`/`status` before decoding success |
| Fetch cannot be canceled | abort method is empty; options have no signal | Own a logical cancellation token or use a verified native adapter |
| XHR times out immediately/incorrectly | `setTimeout` divides instead of converting to milliseconds | Set `xhr.jsValue.timeout` in ms until framework is fixed |
| XHR completion fires more than once | multiple terminal events/races | Centralize a single completion gate |
| WebSocket ArrayBuffer mode fails | source uses nonstandard `arrayBuffer` casing | Validate and isolate browser-native workaround |
| WebSocket reconnects after leaving page | no intentional-close/timer ownership | Add shutdown flag; cancel heartbeat/reconnect work |
| Secret appears in logs/history | token in query URL or request/options logging | Use authorization header where protocol allows; redact diagnostics |
| Stored integer reads as nil | Web Storage returns strings | Read `string(forKey:)`, then parse |
| local/session storage assumed secure | any same-origin injected JS can access it | Minimize sensitive persistence and harden CSP/XSS boundaries |
| User text becomes markup | raw String DOM content/`innerHTML` | Use `innerText` or typed text elements |
| Form navigates/reloads | submit default not canceled | `event.preventDefault()` in `.onSubmit` |
| Multipart upload rejected | manually supplied Content-Type lacks browser boundary | Let `FormData`/browser set it |
| Low-level event fires only once | source-observed listener-container mutation | Prefer typed handlers or runtime-test a patch/wrapper |
| Listener/timer keeps controller alive | retained closures and no individual state listener token | weak captures and explicit lifecycle cleanup |
| Dynamic route resolves unexpectedly | trie precedence and duplicate replacement | Understand constant > parameter > wildcard > catchall; audit duplicates |
| `req` is nil in `willLoad` | property assigned after `willLoad` in current routing sequence | use the method argument |
| Catchall assertion/failure | `**` is not final component | keep catchall last |
| Nested media rule ignored | framework processing TODO | flatten media structure |
| Service fetch callback cannot serve cached response | builder hides event; caches are stubs | explicit owned JS service-worker layer or framework contribution |
| Push declared but no subscription/data | manager/event are incomplete | browser-native or external implementation; test end-to-end |
| Wasm loader hangs/continues after failure | bootstrap polling/error path is incomplete | validate HTTP response and establish terminal failure state |
| Private dependency changes unexpectedly | mutable SSH `main` dependency | lock exact revision/tag and preserve lockfile |
| Same implementation counted twice | `WebThems` archive/duplicates | identify active package roots first |
| Native preview behaves like a browser in assumptions | native mode generates previews/index and uses string substitutes | separate wasm runtime tests from native generation tests |

Other source-level cautions:

- `RequestOptions.jsValue` calls `Console.dir`, which can expose request metadata.
- `Document.querySelectorAll` relies on a global/eval-style helper.
- State assignments notify even when values are equal; use `listenOnlyIfChanged` where necessary.
- `remove()` is not a universal project-resource shutdown hook.
- Service callbacks without event payloads cannot express standard browser `waitUntil`/`respondWith` policy.
- CORS, CSP, secure-context rules, user-gesture requirements, and browser permissions are enforced by the browser, not bypassed by WebAssembly.

## 31. Version Differences and Deprecated APIs

The inspected history is unusual but unambiguous: remote `master` (`92ae621`) is behind the resolved/tagged nightly.11 commit (`6159d95`). Nightly.11 contains 22 commits not present on that default branch. This guide therefore uses nightly.11 for local compile-oriented examples and uses `master` only to document the public default-branch boundary.

| Area | Inspected `master` | Resolved nightly.11 | Migration guidance |
|---|---|---|---|
| App metadata generation | no `Index` item | adds `Index` | Do not use on older checkout |
| Splash | no `Splash` item | adds `Splash` | Gate by resolved version |
| Controller metadata | no page `title`/`metaDescription` states | added | On older source write document metadata through available API |
| Static/crawler completion | no `rendered` API | added | Treat as host integration, not DOM render callback |
| Preview architecture | `PreviewableApp` exists | removed/reworked | Follow exact checkout's preview entrypoint |
| DOM/CSS/event/app internals | older implementations | multiple follow-up changes | Avoid depending on internal types/behavior |

`ViewController` is explicitly unavailable and renamed to `PageController`; update declarations and return types. The combined-state deprecated result type should be replaced with `.and(...).map { value1, value2 in ... }`.

The following are public-looking concepts but not viable stable APIs in nightly.11: Fetch abort wiring, service-worker cache wrappers, PushManager/PushEvent, and many catalog modules whose source is only a TODO. Version upgrades must be audited by reading implementation and public visibility, not release name alone.

When upgrading:

1. record old/new resolved commits and JavaScriptKit version;
2. diff public source for `Web`, `DOM`, `CSS`, events, networking, and ServiceWorker;
3. search for `TODO`, `FUTUREFIX`, `unavailable`, and `deprecated` in used modules;
4. rebuild one minimal App, one representative production App, and Service products;
5. browser-test routing/back-forward, state/event persistence, HTTP error/timeout, WebSocket shutdown, manifest generation, install/update/offline behavior;
6. remove interop workarounds only after the fixed wrapper is verified.

## 32. Source Index

### Framework sources inspected

All framework paths below are relative to the resolved checkout `PWASkyline/.build/checkouts/web` at commit `6159d951…`.

| Topic | Source locations |
|---|---|
| Package products/dependencies | `Package.swift` |
| Foundation/interop/state | `Sources/WebFoundation/State.swift`, `JSValue.swift`, `JSClass.swift`, `WebJSValue.swift`, `Storage.swift`, `Dispatch.swift`, `AbortController.swift`, `FormData.swift`, `File.swift`, `Blob.swift`, `URLSearchParams.swift` |
| DOM builder/elements/document | `Sources/DOM/DOM.swift`, `DOMElement.swift`, `BaseElement.swift`, `BaseContentElement.swift`, `Elements.swift`, `Document.swift`, `ForEach.swift` |
| DOM events | `Sources/DOMEvents`, `Sources/Events` including event target/listener/container types |
| CSS | `Sources/CSS/Stylesheet.swift`, `Rules.swift`, `CSSRule.swift`, `MediaRule.swift`, `Keyframes.swift`, `CSSProperties.swift`, `StyleElement+CSS.swift` |
| App/lifecycle/builders | `Sources/Web/WebApp.swift`, `AppBuilder.swift`, `WindowLifecycle.swift`, `Elements/Index.swift`, `Elements/Splash.swift` |
| Controllers/routing | `Sources/Web/Controllers/PageController.swift`, `Sources/Web/Routing/Routes.swift`, `Page.swift`, `Request.swift`, `Parameters.swift`, `PathComponent.swift`, `TrieRouter.swift`, `DefaultResponder.swift`, fragment routing sources |
| Fetch | `Sources/FetchAPI/Fetch.swift`, `RequestOptions.swift`, `Response.swift`, `Body.swift`, `Headers.swift` |
| XHR | `Sources/XMLHttpRequest/XMLHttpRequest.swift` and event/response files |
| WebSocket | `Sources/WebSocketAPI/WebSocket.swift`, `MessageEvent.swift`, `BinaryType.swift` |
| Storage/history/location | `Sources/StorageAPI`, `Sources/HistoryAPI`, `Sources/LocationAPI` |
| Service/manifest | `Sources/ServiceWorker/ServiceWorker.swift`, `ServiceBuilder.swift`, lifecycle/event sources, `Manifest/Manifest.swift` and manifest value types |
| Browser catalog | each product under `Sources/*API`; status was based on implementation size/public declarations/TODO inspection |
| Version comparison | local `git show`/`git diff` between `92ae621…` and `6159d951…`; official repository README/default branch/remote refs |

### Local application sources inspected

| Study area | Representative local locations |
|---|---|
| Package/version inventory | each package's `Package.swift` and `Package.resolved` under `/Users/victorcantu/Development/SwifWeb2.0` |
| Minimal app/service | `PWARaffle/Sources`, `YoConTicoPWA/Sources`, `antiguedadesypianos.com/Sources` |
| Base lifecycle/routes/style/localization | `PWA-WebTheme-Base/Sources/App/App.swift`, route/page/style sources |
| Contact form and CAPTCHA adapter | `PWA-WebTheme-Base/Sources/App/Views/SendContactFormView.swift` and `HCaptchaView.swift` (names/placement may vary within the view tree) |
| Private typed transport evidence | resolved private dependency checkouts used by Base; classified as third-party/project code |
| PWASkyline app/routes/styles | `PWASkyline/Sources/App/App.swift`, routing, styles, storage/session, API alias sources |
| PWASkyline transport | `PWASkyline/Sources/App/Functions/sendPost.swift` in the current worktree |
| PWASkyline WebSocket | WebSocket controller sources under `PWASkyline/Sources/App` |
| PWASkyline service | `PWASkyline/Sources/Service/main.swift`, `Service.swift` |
| JS/WASI bootstrap | `PWASkyline/WebSources/package.json`, webpack config, `app.js`, `startTask.js`, `serviceWorker.js` |
| igBaust dynamic/API/JS patterns | `igBaust/Sources/App` and its package/lockfile |
| Local governance/architecture | `PWASkyline/.agent/SYSTEM_RULES.md`, `WORKFLOW.md`, `COMMIT_RULES.md`, `PRODUCT_SCOPE.md`, `ARCH_INDEX.md`, relevant architecture chunks, `SOURCE_MAP.md`, `REFERENCE_PROJECTS.md`, documentation-sync skill |

### Evidence quality and limits

This study distinguishes public declarations from internal implementation, and framework APIs from local/private extensions. It inspected source instead of assuming a module name implied functionality. It did not expose observed credentials, private hostnames, CAPTCHA keys, or token values. Compile-oriented snippets containing placeholders such as `example.invalid`, empty project methods, or project-owned error models illustrate the boundary and require application-specific completion.

The strongest evidence is the exact resolved checkout and local code. Browser runtime behavior—permissions, CSP/CORS, PWA install/update, service-worker fetch control, history events, and JavaScript callback lifetime—still needs targeted browser validation in the deployment environment. Generated outputs were inspected only to understand the bootstrap and were not treated as stable authority.

### Verification record for this study

- **Projects inventoried:** 12 Swift package roots, each with App and Service products.
- **Framework baseline:** nightly.11/`6159d951…`; JavaScriptKit 0.17.0/`dac9d7b…`; compared with older default-branch `master`/`92ae621…`.
- **Examples:** 37 labeled examples covering all requested major surfaces. A combined App/DOM/CSS/routing/state/forms/Fetch/XHR/WebSocket/storage/history audit file and an independent Service/manifest/lifecycle audit file type-checked against the resolved nightly.11 modules.
- **Focused builds:** `swift build --product Service --jobs 4` passed. `swift build --product App --jobs 4` compiled the source objects but failed at native link on unresolved project symbols `showSuccess`, `showAlert`, and `showError`; it also reported a missing `tutorial` resource and one unhandled project file. Those are existing PWASkyline worktree/build conflicts, not failures introduced by this document.
- **Incomplete framework areas:** Fetch abort integration; service-worker cache response control; Cache/CacheStorage; PushManager/PushEvent; WebSocket ArrayBuffer casing; XHR timeout conversion; multiple catalog products that contain only TODO scaffolding.
- **Security audit:** examples contain no observed private hosts, tokens, credentials, CAPTCHA keys, or production identifiers. Placeholder origins use `example.invalid`.
- **Mutation scope:** this documentation file is the sole requested deliverable; application source was not changed.
