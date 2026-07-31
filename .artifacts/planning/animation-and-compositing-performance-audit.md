# Animation and Compositing Performance Audit

Date: 2026-07-29

## Scope

This is the phase-10 source audit from the approved ImageEditor and CSS
performance plan. It inventories:

- broad `transition` declarations
- transitions or animations involving `top`, `left`, `width`, or `height`
- animated `filter`
- large-area `backdrop-filter`
- long delays and durations
- nested animated transparent layers

No animation, transition, filter, theme, or production stylesheet was changed.
No browser profiling or visual comparison was run.

## Executive findings

1. The most direct layout-animation candidate is the Work startup scan:
   `top 1650ms ... 80ms`. It can likely become a transform animation, but the
   mobile viewport and final pixel position must be compared before activation.
2. The Work startup also animates filters on the full dashboard background and
   workspace while multiple large layers fade and translate. This is the
   highest-risk animation/compositing cluster.
3. `SKMainStyle` contains an active malformed transition string,
   `all.2s ease-out`. The browser is expected to reject it. Correcting it would
   introduce a visual change where there is currently likely no transition, so
   it must be reviewed separately rather than silently fixed.
4. Several legacy declarations omit the transition property. CSS defaults
   those declarations to `all`, even though the literal does not say `all`.
5. Current Swift keyframe animations use transform and opacity rather than
   top/left/width/height. They are generally compositor-friendly.
6. Nested backdrop filters are more likely to create sustained compositing cost
   than guarded runtime stylesheet installation.

## Transition inventory

### Explicit or implicit `all`

| Source | Declaration | Runtime state | Risk |
|---|---|---|---|
| `SKMainStyle.swift:164` | `all.2s ease-out` | Active rule for `.uibutton`; malformed | Browser likely rejects the declaration. Fixing it changes current behavior. |
| `SKMainStyle.swift:421` | `300ms ease-in-out` | Active `.uibtn`; property omitted, so defaults to `all` | Any changed property can animate, including layout or paint properties. |
| `SKMainStyle.swift:464` | `1s ease-in-out` | Active `.uibtn svg`; property omitted | Intended changed value appears to be `stroke-dashoffset`; broad matching is unnecessary. |
| `SKMainStyle.swift:470` | `300ms ease-in-out` | Active `.uibtn:hover`; property omitted | Broad transition on a shared legacy button class. |
| `Sources/Service/skyline/css/main.css:90-103` | `transition: 0.4s` and prefixed duplicates | Active legacy switch styles | Property defaults to `all`; current state changes are background color and pseudo-element transform. |
| `Sources/Service/css/main.css:90-103` | same | Copied legacy resource | Same broad transition; source tree contains duplicate implementations. |
| `Sources/Service/css/style.css:38-51` | same | Globally linked stylesheet copy | Same broad transition can also enter the page through `/css/style.css`. |
| `OrderRowView.swift:199` | `all 1200ms ease-in-out 300ms` | Inside a block comment | No runtime cost today. Do not optimize dead code as production behavior. |

Recommended future treatment:

- Keep `SKMainStyle.swift:164` unchanged until a visual owner decides whether
  the currently rejected transition should remain absent or be restored.
- If restored, enumerate only properties actually changed by the relevant
  states. `.uibutton` is used broadly across service, sale, payment, rental, and
  customer flows, so a global behavior change needs regression coverage.
- Replace `.uibtn svg` with
  `transition: stroke-dashoffset 1s ease-in-out`.
- Replace legacy switch shorthands with:
  - slider: `background-color 0.4s`
  - slider `::before`: `transform 0.4s`
- Narrow `.uibtn` only after identifying every active style mutation in global
  and scoped theme rules.

### Layout-related transitions

| Source | Property | Duration/delay | Status | Proposal |
|---|---|---:|---|---|
| `TCWorkDashboardTheme.swift:656` | `top` | 1650ms / 80ms | Active startup scan | Keep a fixed `top` and animate `transform: translateY(...)`. Verify dynamic/mobile viewport height and the exact `-8px` endpoint. |
| `SKMainStyle.swift:513` | `width` | 500ms / 300ms | Active `.communicationBox` hover expansion from 58px to 400px | Width affects surrounding layout. Consider a fixed 400px compositor layer revealed with `clip-path`/`scaleX`, but only if hit testing, text wrapping, and neighboring toolbar layout remain identical. |
| `OrderRowView.swift:206` | `max-height` | 1ms | Commented | No current action. |

No active explicit transition or keyframe animation of `left` or `height` was
found in the reviewed App and Service sources. Static positions use those
properties, but are not animated by named property transitions.

The legacy switch pseudo-element moves with `transform: translateX(26px)`,
which is already preferable to animating `left`.

### Filter transitions

| Source | Target | Transition | Animated filter state | Risk |
|---|---|---|---|---|
| `TCWorkDashboardTheme.swift:568` | dashboard background | filter 620ms | `blur(8px) brightness(0.45)` to normal | Full dashboard background, likely a large composited surface. |
| `TCWorkDashboardTheme.swift:580` | workspace | filter 520ms after 340ms | `blur(5px)` to normal | Large content surface animated alongside opacity and transform. |
| `SKLogInStyle.swift:182` | mesh canvas | filter 520ms | handoff applies brightness and 2px blur | Full-screen/large canvas. |
| `SKLogInStyle.swift:185` | content layer and main root | filter 420ms | 4px/5px blur to normal | Large transparent layers over animated canvas. |

Recommended future treatment:

1. Preserve the endpoint filters.
2. Evaluate two fixed-state layers—one filtered and one unfiltered—and
   cross-fade opacity rather than interpolating blur every frame.
3. Do not apply this automatically: cross-fading fixed blur states is not
   mathematically identical to interpolated blur at intermediate frames.
4. Compare a screen recording at the same viewport, GPU setting, and startup
   timing before approval.
5. If exact mid-animation equivalence is required, retain the filter animation
   and focus first on the `top` and broad-transition fixes.

## Keyframe animation inventory

| Animation | Source | Properties | Assessment |
|---|---|---|---|
| `lds-ring` | `SKMainStyle.swift`, `SKLogInStyle.swift` | transform rotation | Compositor-friendly; infinite by design. |
| `anibox1` | `MainStyle.swift` | transform rotation, opacity | Compositor-friendly. |
| `tc-login-recovery-enter` | `SKLogInStyle.swift` | translate transform, opacity | Compositor-friendly; reduced-motion fallback exists. |
| `tc-login-main-enter` | `SKLogInStyle.swift` | translate transform, opacity | Compositor-friendly; reduced-motion fallback exists. |
| `anibox1` through `anibox10` | both Service login CSS copies | transform/scale/rotation, opacity | No layout properties animated. |

`LoginViewcontroler.swift:622` requests `anibox110`, while the static CSS defines
`anibox10`. This appears to be a pre-existing name mismatch, but it is outside
an animation-performance-only change. Verify the visible login ornament before
correcting it in a separate bug fix.

No keyframe in the inspected sources animates `top`, `left`, `width`, or
`height`.

## Long durations and delays

The Work startup is intentionally staged:

- background: up to 760ms transform and 620ms filter
- top bar: 120ms delay
- left rail: 220ms delay
- workspace: 340ms delay
- message rail: 420ms delay
- order column: 620ms delay
- stat cards: base 720ms, then 800ms, 880ms, and 960ms delays
- startup status rows: 560ms, 760ms, and 960ms delays
- ring: 1100ms transform after 160ms
- scan: 1650ms top transition after 80ms
- progress fill: 1650ms transform after 120ms

These delays do not inherently cause layout work while waiting, but they keep
multiple transparent/composited layers alive for roughly two seconds. The
existing `prefers-reduced-motion` rule disables the startup overlay and resets
dashboard transitions, which should be preserved.

Login ornament animations run for 0.5–1.21 seconds. They animate transform and
opacity and are lower priority than the Work startup cluster.

## Backdrop-filter inventory

Counts are standard `backdrop-filter` source declarations; prefixed duplicates
are not counted separately. `none` and commented declarations are included in
the raw source count and identified below.

| Source cluster | Raw declarations | Notable active layers | Priority |
|---|---:|---|---|
| `TCCrystalSurfaceTheme.swift` | 18 | modal/popup 12px, panel up to 28px, title/body/box 8–22px | High: shared broadly and commonly nested |
| `TCOrderViewTheme.swift` | 9 | order shell and nested panels 8–14px; root also sets `none` | High on full OrderView |
| `AccountViewTripBetaStyle` | 6 | host 14px, root 12px, summary/content 14px, panels 12px; two `none` host resets | High when matching roots are active |
| `TCWorkDashboardTheme.swift` | 6 | dashboard surfaces 9–18px, including startup core | High during startup |
| `TCAccountViewTheme.swift` | 5 | detail host/root 8px, editor shell 22px, body 12px | High: explicitly nested |
| `SKLogInStyle.swift` | 5 | recovery and main surfaces 12–28px | High during login |
| `MoneyManagerView.swift` | 5 | host 8px, popup 12px, panel 24px, title/box 14px | High: five-level glass stack |
| `CustTaskAuthorizationView.swift` | 5 | popup reset `none`, panel 24px, title/box 14px, card 12px | Medium/high |
| `InternalCommunicationView.swift` | 4 | host 8px, popup reset `none`, panel 24px, box 14px | Medium/high |
| `addToDom.swift` | 2 | standard host 3px; interactive mode `none` | High only because standard host covers viewport |
| `OrderCatchControler.swift` | 2 | two 4px menu backdrops | Medium, dependent on menu size |
| `TCMessageObjectTheme.swift` | 1 | message bubble 10px | Low/medium per item; multiplicity matters |
| `SideMenuRightView.swift` | 1 | 3px | Low/medium |
| `LoginViewcontroler.swift` | 1 | 3px important | Medium with login layers |
| `TCTripBetaTheme.swift` | 1 | commented declaration | No active cost |

The table is not a measured GPU ranking. Area, overlap, movement, device GPU,
and browser layer promotion determine actual cost.

## Nested transparent-layer clusters

### Standard modal composition

`SuperView` applies a full-screen 3px backdrop blur and fades opacity for 340ms
while its child fades and translates. This preserves the established modal
appearance but may composite the full viewport during entry. Phase 7 now offers
an unused opt-in interactive mode; it must not be enabled until visual
comparison shows its no-blur host is acceptable.

### Crystal modal composition

A typical crystal popup may combine:

1. modal host blur: 8px
2. popup backdrop: 12px
3. panel blur: 24px
4. title blur: 14px
5. inner box blur: 14px

This layered effect is intentional under the dark-crystal visual guidelines.
Do not flatten it during mechanical CSS migration. Profile a representative
modal first, then optimize only layers shown to be redundant.

### Account detail

The detail host and detail root each apply 8px blur, followed by a 22px editor
shell and 12px body. The host/root pair is the clearest candidate for checking
whether two adjacent full-area filters produce a visible difference.

### Money Manager

The host, popup, panel, title, and box use 8px, 12px, 24px, 14px, and 14px
respectively. This is another controlled profiling candidate because the same
surface family is present in one modal hierarchy.

### Work startup

The full-screen startup overlay fades while the background and workspace
animate opacity, transform, and filter. The startup core adds an 18px backdrop
blur. This cluster combines long staging, large animated filters, and
transparent layers; it should be profiled before static modal surfaces.

### Login handoff

The mesh canvas, content layer, and main root animate filter, opacity, and
transform while the main card can use 28px backdrop blur. This is visually
intentional and has reduced-motion handling, but remains a high-value trace
candidate.

## Prioritized proposal

### Proposal 1 — Work scan transform pilot

Replace only the startup scan's `top` transition:

1. Give the scan a fixed endpoint position.
2. Express the start/end vertical travel with `translateY`.
3. Keep the same 1650ms duration, 80ms delay, easing, line height, glow, and
   final `-8px` location.
4. Verify desktop and mobile/dynamic viewport heights.
5. Compare first frame, midpoint, final frame, and completion removal.

This is the smallest likely layout-saving change.

### Proposal 2 — Narrow legacy broad transitions

In separate changes:

1. narrow `.uibtn svg` to `stroke-dashoffset`
2. narrow switch track/pseudo-element transitions
3. inventory actual `.uibtn` property changes, then replace implicit `all`
4. decide whether malformed `.uibutton` should remain visually instant or be
   restored with an explicit property list

Do not combine these because the classes have different usage surfaces.

### Proposal 3 — Work filter cross-fade experiment

Prototype off the production path:

1. capture a baseline screen recording and Layers/Performance trace
2. create fixed filtered/unfiltered background layers
3. animate opacity/transform only
4. compare mid-animation appearance and frame time
5. discard if the blur interpolation is visibly different

Repeat separately for workspace content; do not change both in one experiment.

### Proposal 4 — Adjacent backdrop deduplication experiments

Start with Account detail's host/root 8px pair or Money Manager's host/popup
pair. Disable one layer only in a temporary comparison build and inspect:

- background legibility
- edge glow and color accumulation
- blur radius at panel borders
- dashboard visibility
- layer count and GPU paint/composite time

No layer should be removed merely because another ancestor also blurs.

## Verification required before any implementation

Functional:

- Work startup completes and removes its overlay.
- Dashboard remains interactive after startup.
- Login handoff and recovery modal complete correctly.
- Buttons, switches, communication box hover, and modal close behavior remain
  unchanged.

Visual:

- Same viewport, theme, data, and device scale.
- Screen recording comparison for full animation, not screenshots alone.
- Pixel comparison at start, midpoint, and endpoint.
- Verify reduced-motion mode.

Performance:

- Chrome Performance trace for the same startup duration.
- Compare layout events, paint time, compositing time, layer count, long tasks,
  and dropped frames.
- Record whether the change affects first-use stylesheet installation or only
  ongoing animation.

## Deferred decisions

- Whether the rejected `all.2s` transition should be restored.
- Whether Work filter interpolation may be approximated by a cross-fade.
- Whether a crystal glass layer is visually redundant.
- Whether the communication box may use reveal/clip animation instead of width.
- Whether the login `anibox110` name mismatch should be corrected.

Each decision can change appearance or behavior and therefore requires review
before production edits.
