# Incremental Static CSS Migration Strategy

Date: 2026-07-29

## Goal

Move deterministic runtime-generated theme rules into static CSS incrementally
without changing visual output, DOM identifiers, class names, behavior, or
cascade results.

This phase defines the migration only. It does not create production CSS files,
add stylesheet links, or remove runtime installers.

## Existing loading model

- `WebSources/main.html` loads `/css/style.css`.
- `WorkViewControler` inserts `/skyline/css/main.css` and
  `/skyline/css/jcrop.css` when the Work route is constructed.
- Guarded Swift theme installers append their stylesheets on first use.
- `Sources/Service/skyline/**` is copied by the Service target and owns static
  Skyline assets.

A future static feature stylesheet must be loaded after the legacy stylesheet
whose declarations it currently overrides. Before the first extraction, verify
the final CSSOM order in the browser because startup links and runtime-added
links/styles do not necessarily appear in source-file order.

## Recommended target structure

The eventual structure should be:

```text
Sources/Service/skyline/css/
    tokens.css
    components.css
    image-editor.css
    account-view.css
    order-view.css
    work-dashboard.css
    animations.css
```

Do not create all files up front. Each file should appear only when its first
verified extraction needs it.

## Migration invariants

- Preserve selector text and selector order during first extraction.
- Preserve every property value, prefix, and `!important`.
- Preserve existing root and variant classes.
- Do not rename DOM IDs or classes.
- Do not combine migration with selector cleanup, token redesign, blur
  reduction, animation changes, or layout refactoring.
- Remove only the runtime rules proven equivalent to the static extraction.
- Keep rollback possible at each component boundary.
- Do not migrate AccountView first.

## Stage 0 — Establish the static loading contract

Before extracting a component:

1. Confirm where a new Skyline feature stylesheet is linked.
2. Confirm Service target resource copying exposes the expected URL.
3. Confirm the service worker does not require an additional asset declaration.
4. Record CSSOM order relative to `/css/style.css`,
   `/skyline/css/main.css`, and existing runtime styles.
5. Choose one loading location and keep it stable across pilot migrations.

Recommended direction: add the first feature sheet after
`/skyline/css/main.css` in the Work route so it follows the legacy Work
stylesheet. Verify that this does not create a first-frame flash before using it
as the permanent contract.

## Stage 1 — Exact token extraction

Create `tokens.css` only when the first migrated component needs shared values.
Start with exact duplicates:

- `#49b9f5`
- `#edf7ff`
- `#252c3b`
- `#245a7c`
- `#ff9f0a`

Rules:

1. Preserve existing component custom-property names initially.
2. If introducing shared variables, prove the computed color is identical.
3. Do not merge same-RGB values with different alpha into one opaque token.
4. Keep semantic renaming for a later cleanup commit.

Token extraction must not be a prerequisite for the pilot if it would enlarge
the first patch. Exact component extraction is more important than early
deduplication.

## Stage 2 — First pilot: `TCMessageObjectTheme`

Use `TCMessageObjectTheme` as the first isolated component migration.

Why:

- It applies only to `MessageObject`.
- It has 14 rules in two guarded stylesheet batches.
- Its root is
  `.tc-message-object.tc-message-object-dark`.
- It has limited legacy interaction compared with Account, Order, Crystal, and
  Work themes.
- It exercises important declarations, state variants, and one
  standard/WebKit backdrop-filter pair without migrating a complete page.

### Step A — Exact extraction

1. Capture baseline screenshots for customer, user, general, high-priority, and
   media messages.
2. Record computed styles for root, metadata, bubble, avatar/media, and action
   controls.
3. Copy the 14 selectors to `components.css` in their current order.
4. Copy properties byte-for-byte, including gradients, alpha values, prefixes,
   and `!important`.
5. Load `components.css` using the stage-0 loading contract.
6. Keep the runtime installer temporarily enabled for a diagnostic build and
   verify that the static rules parse and match the intended roots.

### Step B — Visual verification

Compare at the same viewport and state:

- geometry and wrapping
- typography
- borders and left/right rails
- gradients and transparency
- blur and shadows
- hover/focus states
- high-priority presentation

Any computed-style or screenshot difference blocks the migration.

### Step C — Remove the runtime installer block

After equivalence:

1. Remove only `TCMessageObjectTheme.install()` rule construction.
2. Keep `TCMessageObjectTheme.apply(to:)` or replace it with a class-only helper
   so root-class behavior remains unchanged.
3. Do not change `MessageObject` business logic or class selection.

### Step D — Verify cascade

Repeat computed-style, screenshot, interaction, and route-reload checks with the
runtime rules removed. Verify first-load and subsequent-load behavior because
the static stylesheet now exists earlier than the old lazy installer.

### Step E — Optional simplification

Only in a separate reviewed change:

- consolidate exact token duplicates
- reduce safe `!important` declarations
- simplify selectors
- evaluate blur/shadow cost

The optional cleanup must have its own before/after evidence and rollback.

## Stage 3 — Expand by risk

Recommended sequence after the pilot:

1. A second isolated component group from `TCTripBetaTheme`, such as one
   self-contained control family.
2. Remaining stable Trip beta primitives, preserving the requirement that
   Crystal `.trip` selectors win where both roots are present.
3. `TCWorkDashboardTheme`, excluding startup animations until the animation
   audit is approved.
4. `TCOrderViewTheme`, one panel/toolbar group at a time.
5. `TCCrystalSurfaceTheme`, split into shared primitives and individual
   variants rather than migrated as one block.
6. `TCAccountViewTheme.detail`.
7. Account overview themes last, after resolving and visually baselining the
   currently commented overview root application.

`AccountViewTripBetaStyle` and `TCAccountViewTheme.overview` must not be migrated
until their intended root-class composition and effective cascade are explicit.

## File-by-file destination

### `components.css`

Small isolated shared components, beginning with MessageObject. Avoid turning
this file into an unstructured catch-all; each extracted component should have a
clearly delimited section and matching source ownership.

### `image-editor.css`

Only ImageEditor-specific presentation and cropper integration overrides.
Third-party/legacy `/skyline/css/jcrop.css` should remain separate during the
performance work.

### `account-view.css`

Account detail first; overview and Trip-beta Account overrides only after their
cascade is resolved. Preserve `.tc-account-view-theme`,
`.tc-account-overview`, `.tc-account-detail`, and
`.tc-account-trip-beta-style`.

### `order-view.css`

Extract by functional surface: host/shell, toolbar, content columns, messages
and files, finance, status, then responsive rules. Preserve source order when
selectors have equal specificity.

### `work-dashboard.css`

Extract structural/dashboard rules first. Keep startup animations isolated until
the phase-10 animation proposal is reviewed.

### `animations.css`

Create only after the animation inventory establishes which animations are
shared and which are feature-owned. Moving an animation here must not alter its
timing, easing, delay, fill mode, or selector order.

## Verification gates for every extraction

### Source and packaging

- Static CSS path exists under `Sources/Service/skyline/css`.
- Package resource copying still includes `skyline`.
- No generated `DevPublic` or `DistPublic` file is edited manually.
- The stylesheet URL resolves and is not loaded twice.

### Cascade

- CSSOM ordering is recorded.
- Root/variant matching is unchanged.
- Equal-specificity source order is unchanged.
- Inline styles retain the same winner.
- `!important` is preserved during exact extraction.

### Visual

- Same viewport, data, and interaction state.
- Pixel comparison or documented overlay comparison.
- Computed-style comparison for representative nodes.
- No flash of unstyled or legacy-styled content.

### Behavior

- Root classes still activate/deactivate with the same state.
- Hover, focus, active, selected, modal, and responsive states work.
- Route reload and repeated component construction match current behavior.

### Performance

Measure separately:

- first-use Wasm/script time and stylesheet insertion
- style recalculation
- layout
- paint
- compositing/layer count

Static migration is successful when appearance and behavior are unchanged and
first-use construction cost is removed. It must not claim paint/compositing
improvement unless those metrics also improve.

## Commit boundaries for the future migration

The user owns commits. Recommended change boundaries are:

1. Static loading contract only.
2. Exact isolated component extraction with runtime rules still available for
   comparison.
3. Remove only the equivalent runtime installer block.
4. Optional token/selector/performance cleanup, one concern per change.

These boundaries keep rollback clear and prevent visual cleanup from being
mistaken for a mechanical migration.

## Explicitly deferred

- No production stylesheet was created in this phase.
- No stylesheet link or Service resource was changed.
- No runtime installer was removed.
- No AccountView cascade behavior was changed.
- No `!important`, blur, shadow, transition, or animation was simplified.
- No build, browser test, or visual comparison was run.
