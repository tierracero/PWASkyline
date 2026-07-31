# CSS Performance and Migration Analysis

Date: 2026-07-29

## Scope

This report covers the runtime stylesheet installers named in phase 8:

- `TCTripBetaTheme.install()`
- `AccountViewTripBetaStyle.install()`
- `TCAccountViewTheme.install()`
- `TCOrderViewTheme.install()`
- `TCCrystalSurfaceTheme.install()`
- `TCWorkDashboardTheme.install()`

It is a source-level architecture review only. No production CSS was migrated,
no theme was disabled, and no browser profiling or visual comparison was run.

## Executive findings

1. Every reviewed installer has an `isInstalled` guard. Rule construction and
   stylesheet insertion are therefore first-use costs, not work repeated for
   every rendered instance.
2. Applying a theme after installation is normally limited to a guard check and
   one or two root-class mutations. This is not expected to be a continuous
   interaction bottleneck.
3. Ongoing cost comes from the CSS produced by the installers: selector
   matching, layout-affecting declarations, paint-heavy shadows/gradients, and
   especially nested or large-area `backdrop-filter` surfaces.
4. The themes intentionally use scoped selectors, but they still overlap
   legacy global controls such as `.uibtn`, `.uibtnLarge`,
   `.uibtnLargeOrange`, `.roundDarkBlue`, `.roundGrayBlackDark`,
   `.roundGrayBlack`, and `.roundBlue`. High specificity and `!important` are
   frequently used to win that cascade.
5. Runtime generation is not inherently slow. Moving rules to static CSS can
   reduce Wasm rule-builder and CSSOM insertion work and improve
   maintainability, but it does not automatically reduce layout, paint, or
   compositing cost.

## Inventory

Counts below are static source counts. “Rules” means constructed `CSSRule`
objects; media wrappers are listed separately. `backdrop-filter` counts include
the prefixed duplicate because both declarations enter the stylesheet. The Trip
theme has one commented occurrence and no active backdrop-filter declaration.

| Installer | Rules | Media wrappers | Stylesheet batches | `!important` occurrences | Active backdrop declarations |
|---|---:|---:|---:|---:|---:|
| `TCTripBetaTheme` | 48 | 1 | 5 | 11 | 0 |
| `AccountViewTripBetaStyle` | 33 | 0 | 5 | 90 | 12 |
| `TCAccountViewTheme` | 32 | 0 | 5 | 52 | 10 |
| `TCOrderViewTheme` | 93 | 1 | 6 | 188 | 18 |
| `TCCrystalSurfaceTheme` | 92 | 2 | 7 | 181 | 36 |
| `TCWorkDashboardTheme` | 112 | 1 | 10 | 15 | 6 |

The counts are architecture-sizing evidence, not a performance score. A small
rule set can still be expensive if it filters a large composited region, and a
large scoped rule set can remain inexpensive when its root is absent.

## Installer-by-installer analysis

### `TCTripBetaTheme`

- **Install timing:** first call to `apply(to:)` or direct `install()`. Current
  callers include TripController views, popup/layout controls, login, follow-up,
  AddCharge, and AccountView.
- **Root:** `.tc-trip-beta-theme`.
- **Specificity:** commonly one root plus one component class (`0-2-0`);
  descendants and pseudo states increase this to roughly `0-3-0`.
- **Overrides:** only 11 `!important` occurrences, concentrated in legacy
  button overrides near the end of the theme.
- **Compositing:** no active backdrop blur. The single source occurrence is
  commented out.
- **Legacy overlap:** `.uibtn`, `.uibtnLarge`, `.uibtnLargeOrange` and shared
  field/control elements.
- **Inline interaction:** Swift view code still sets dimensions and layout
  directly. Normal inline declarations beat normal stylesheet declarations;
  theme `!important` declarations beat non-important inline declarations.
- **Static suitability:** good candidate for incremental extraction by isolated
  component groups, but it is shared broadly and should not be moved as one
  large first migration.

### `AccountViewTripBetaStyle`

- **Install timing:** first `AccountView.buildUI()` that calls
  `AccountViewTripBetaStyle.apply(to:)`.
- **Root:** intended inner root is
  `.tc-account-view-theme.tc-account-overview.tc-account-trip-beta-style`.
  It also contains a separate `.tc-account-overview-host` selector family for
  the Account/Orders host shell.
- **Specificity:** intended root selectors begin at `0-3-0`; common descendant
  selectors are `0-4-0` or higher. Host selectors usually start at `0-1-0`.
- **Overrides:** 90 `!important` occurrences.
- **Compositing:** six standard/prefixed backdrop-filter pairs across host,
  root, summary/content, and panels.
- **Tokens:** duplicates cyan `#49b9f5`, ink `#edf7ff`, accent bar `#252c3b`,
  input border `#245a7c`, and several dark RGB surface families found in the
  Account and Crystal themes.
- **Legacy overlap:** explicitly restyles `.roundDarkBlue`,
  `.roundGrayBlackDark`, `.roundGrayBlack`, `.roundBlue`, `.uibtn`,
  `.uibtnLarge`, and `.uibtnLargeOrange`.
- **Inline interaction:** AccountView contains extensive inline sizing,
  positioning, background, border, and visibility declarations. The beta
  stylesheet relies on scoped `!important` properties to override many of
  those declarations.
- **Static suitability:** not a first-migration candidate. Its current cascade
  state must be resolved and visually baselined before extraction.

### `TCAccountViewTheme`

- **Install timing:** first call to `apply(to:variant:)`. The detail variant is
  used by `Account+DetailView`. The overview application in `AccountView` is
  currently commented out.
- **Root:** `.tc-account-view-theme` plus `.tc-account-overview` or
  `.tc-account-detail`.
- **Specificity:** variant roots generally start at `0-2-0`; descendants are
  normally `0-3-0` or higher. The detail modal host uses `:has(...)`, increasing
  selector complexity and tying styling to DOM ancestry.
- **Overrides:** 52 `!important` occurrences.
- **Compositing:** five standard/prefixed backdrop-filter pairs, including
  large detail/modal surfaces.
- **Tokens:** duplicates Account beta and Crystal values including `#49b9f5`,
  `#edf7ff`, `#252c3b`, and dark translucent surface families.
- **Legacy overlap:** shared `.uibtn` families and global overlay host styling.
- **Inline interaction:** Account detail and editor views own much of their
  geometry inline; theme rules override selected controls and containers.
- **Static suitability:** split by variant before migration. Detail is safer to
  baseline independently than the overview cascade.

### `TCOrderViewTheme`

- **Install timing:** `AccoutOverview.buildUI()` calls `install()`. The
  `.tc-order-view-theme` root is added only while the host is in Order mode.
- **Root:** `.tc-order-view-theme`.
- **Specificity:** usually root plus component (`0-2-0`), with child,
  `:not(...)`, and state selectors increasing specificity.
- **Overrides:** 188 `!important` occurrences, the largest reviewed dependency
  on cascade force.
- **Compositing:** nine standard/prefixed backdrop-filter pairs, including the
  main shell and nested panels.
- **Tokens:** repeats dark surfaces, `#ff9f0a`, and shared border/ink colors.
- **Legacy overlap:** broad scoped rules for existing buttons, grids, inputs,
  toggles, and OrderView legacy classes.
- **Inline interaction:** OrderView still assigns substantial dimensions,
  widths, heights, and state colors inline. The theme must preserve the
  current inline/important relationship during extraction.
- **Static suitability:** technically extractable, but high-risk because of
  breadth, root toggling, and the number of important overrides. Migrate after
  smaller pilots.

### `TCCrystalSurfaceTheme`

- **Install timing:** first crystal view calls `apply(to:variant:)`. It is
  shared by payments, charges, analytics, customer flows, high-priority notes,
  trip processing, TripController views, and task requests.
- **Root:** `.tc-crystal-surface` plus one variant class.
- **Specificity:** normally two root/variant classes plus a component
  (`0-3-0`); modal-host `:has(...)` selectors are more complex and depend on
  exact parent/child structure.
- **Overrides:** 181 `!important` occurrences.
- **Compositing:** 18 standard/prefixed backdrop-filter pairs, the highest
  reviewed concentration. Several variants use layered shell, header, and body
  glass surfaces by design.
- **Tokens:** duplicates `#49b9f5`, `#edf7ff`, `#252c3b`, `#245a7c`, and dark
  surface RGB families across Account and feature themes.
- **Legacy overlap:** global modal overlay classes, shared buttons and inputs,
  plus variant-specific classes.
- **Inline interaction:** callers still own layout and content state inline;
  crystal rules use `!important` where legacy styles would otherwise win.
- **Static suitability:** must be split by shared primitives and variant. A
  monolithic extraction would have a large visual regression surface.

### `TCWorkDashboardTheme`

- **Install timing:** installed once in `WorkViewControler.buildUI()`; the
  controller then adds `.tc-work-dashboard`.
- **Root:** `.tc-work-dashboard`.
- **Specificity:** commonly `0-2-0`; component combinations and state classes
  increase it.
- **Overrides:** 15 `!important` occurrences, far fewer than Account, Order, or
  Crystal.
- **Compositing:** three active standard declarations. The source does not add
  WebKit-prefixed duplicates for each.
- **Tokens:** repeats `#ff9f0a` and related work/dashboard palette values.
- **Legacy overlap:** dashboard navigation and message controls coexist with
  global page/button classes.
- **Inline interaction:** startup states and selected navigation states are
  class-driven, while several controller-owned dimensions remain inline.
- **Static suitability:** a reasonable later pilot after one smaller isolated
  component, provided startup animation behavior is separately audited.

## AccountView cascade

The effective source order and matching behavior are important:

1. `MainStyle` or `SKMainStyle` is enabled globally from `App.swift`, depending
   on the active theme.
2. `AccountView.buildUI()` calls `TCTripBetaTheme.install()` and manually adds
   `.tc-trip-beta-theme`.
3. It applies `TCCrystalSurfaceTheme` with the `.trip` variant.
4. It calls `AccountViewTripBetaStyle.apply(to:)`, adding
   `.tc-account-trip-beta-style`.
5. Swift inline styles remain on individual AccountView nodes.
6. `!important` stylesheet declarations can override non-important inline
   declarations; otherwise inline declarations win.

However, `TCAccountViewTheme.apply(to:self, variant:.overview)` is commented out
in the current AccountView implementation. No other AccountView root assignment
was found. Therefore the intended inner selector
`.tc-account-view-theme.tc-account-overview.tc-account-trip-beta-style` does not
currently match AccountView. The independent `.tc-account-overview-host`
selectors can still match the containing `AccoutOverview`.

This is a verified cascade mismatch, not a phase-8 change request. Enabling the
overview root would change production appearance and must be handled only after
a visual baseline and explicit review.

## Performance model

### Stylesheet construction

The first call to each guarded installer builds Swift `RulesContent`, bridges it
through Wasm, and inserts several stylesheets. Large builders have previously
required batching to avoid Wasm pressure. Static CSS would remove this first-use
construction cost.

### Per-instance application

After installation, `apply` performs a guard check and adds root/variant
classes. This is small and should not be described as a continuous rendering
problem.

### Selector matching

Root scoping limits matching to active subtrees. Complex descendant selectors,
large grouped selectors, and `:has(...)` cost more than a single class selector,
but the actual impact requires browser profiling.

### Layout

Width, height, top, left, padding, grid/flex, and overflow changes can trigger
layout. Moving those declarations from runtime Swift to static CSS does not
change their layout cost.

### Paint

Borders, gradients, large shadows, and translucent backgrounds increase paint
work. Static extraction preserves this work by design during the exact-migration
stage.

### Compositing

Nested `backdrop-filter`, opacity, and large transparent surfaces can create
additional composited layers. This is the most plausible ongoing cost in the
reviewed themes, but changing it is a visual optimization and must not be mixed
with exact CSS migration.

## Duplicate token candidates

Exact duplicates suitable for a later token-extraction pass include:

- cyan: `#49b9f5`
- light ink: `#edf7ff`
- accent/header bar: `#252c3b`
- GOOD_STYLE input border: `#245a7c`
- orange semantic accent: `#ff9f0a`

Repeated RGB families such as `rgba(6, 24, 42, ...)`,
`rgba(10, 39, 63, ...)`, and `rgba(3, 21, 38, ...)` use different alpha values.
They should not be collapsed into one token during exact extraction unless the
computed value remains identical. A later design-token pass may introduce base
RGB channels with explicit alpha variants.

## Runtime CSS that can become static

All six guarded installers can technically be represented as static CSS because
their output is deterministic and activation is already class-based. Migration
safety differs:

1. Start with a small isolated component, not AccountView.
2. Preserve exact selector text, rule order, property values, prefixes, and
   `!important`.
3. Load the static sheet after the relevant legacy stylesheet so the original
   cascade relationship remains intact.
4. Remove only the corresponding runtime installer after computed-style and
   visual equivalence are established.
5. Treat blur/shadow simplification as a later performance phase.

`TCMessageObjectTheme` is a better first pilot than any of the six large themes:
it is isolated to `MessageObject`, has 14 rules in two batches, and has one
standard/prefixed backdrop pair. Its exact extraction can validate the loading
and cascade process before touching shared Account, Order, Crystal, or Work
surfaces.

## Evidence and limitations

Source evidence was collected with focused searches for rule constructors,
stylesheet batches, `!important`, backdrop filters, root classes, application
sites, global CSS links, and shared token literals.

Not performed:

- Swift build or tests (user confirmation is required).
- Browser computed-style inspection.
- Before/after screenshots.
- Chrome Performance or Layers profiling.

Consequently, this report identifies architectural and source-level risk. It
does not claim measured frame-time savings.
