# Startup version and blue boot progress — scoped plan

## Sources
- WebSources/main.html — browser/WASM boot loader (source-owned, not generated public copies)
- Sources/App/ViewControlers/WorkViewControler.swift — authenticated system boot overlay
- Sources/App/TierraCeroCustomUI/Theme/TCWorkDashboardTheme.swift — Work boot styles

## Architecture / constraints
- PWA-002: DevPublic and DistPublic are generated; leave untouched.
- PWA-003: do not alter the JS loader, service-worker paths, resource hints or events.
- SWWEB-001/002: Work Swift UI changes only inside startupOverlay; do not change readiness/state transitions.
- Existing version SkylineWeb.swift = beta 0.90.30; HTML cannot access Swift runtime before WASM starts.
- Respect performance mode / reduced-motion selectors in HTML.
- Preserve all prior user work; git status clean prior to source editing.
- Do not build/test without user's specific approval.

## Implementation
1. Scope the animated shining-blue gradient fill, white shine sweep and subtle blue track glow to main.html `#element_03` only; preserve determinate and indeterminate behavior.
2. Add orange 'SISTEMA · BETA 0.90.30' to main.html startup footer below bar; comment that static label must track SkylineWeb.version.
3. Add version label to Work system-boot footer, compute it from SkylineWeb().version (mode + major/minor/patch) at Swift runtime.
4. Add a Work-startup-only class and orange style; do not modify Work progress fill color.
5. Update focused architecture verified facts for both startup screens if scope remains as described.

## Audit / acceptance
- Only named source/style/docs changes; no public output edits.
- No change to WASM events, startup readiness, logging, route handling, exits, or quiet-mode semantics.
- Blue shine only initial browser boot. Both screens orange version matching beta 0.90.30.
- Check diff and git status; build/tests not run pending confirmation.
