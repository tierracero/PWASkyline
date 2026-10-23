# Work startup outer HUD reference adaptation

## Approved intent and boundaries
- Reference image 1 supplies ONLY the outer HUD treatment: pale angled corner brackets, delicate perspective/connector lines, calibration ticks across the top, small instrument details.
- Reference image 2 supplies the current Skyline blue/teal inner box, status labels, logo, progress, version and background; preserve them verbatim and preserve the same startup states, timing, event handlers, and accessibility behavior.
- `WebSources/main.html` must not change; `DevPublic/**` and `DistPublic/**` are generated and remain untouched.
- Limit source changes to Work overlay decorative container in `Sources/App/ViewControlers/WorkViewControler.swift`, owning scoped style in `Sources/App/TierraCeroCustomUI/Theme/TCWorkDashboardTheme.swift`, and one new source-owned transparent SVG under `Sources/Service/skyline/media/`.
- No external dependencies or routes. `Package.swift` already copies `skyline` resources. Decor is non-interactive/aria-hidden and hidden at <=900 px.
- Governance: SWWEB-001 / SWWEB-002 and PWA-001 / PWA-002 / PWA-003. Preserve existing uncommitted user changes; don't run builds or tests without user permission.

## Implementation
1. Create vector asset `workStartupOuterHUD.svg` with transparent background at 1200x650 viewBox. Thin near-white/icy lines in a symmetric calibration frame: four diagonal exterior brackets, perspective rails and subtle center targeting marks, upper ruler/ticks and miniature readouts.
2. Inside `startupSideFrames`, place exactly one decorative Img using the bundled SVG, aria-hidden. No change within `startupAssembly` / `startupCore`.
3. Replace old `startupSideFrames::before/::after` cyan trapezoids with a scoped style for the transparent SVG; retain responsive hiding, fade/scale intro and pointer-events none. Retain prior lightened blue background.
4. Update architecture verified fact in SWIFWEB_APP_ARCHITECTURE; source mapping if needed for new static asset.

## Acceptance / audit
- Diff confirms original inner Work box, progress, status, version, and main.html untouched.
- Decor sits behind center in larger screens, does not catch pointer events, and remains hidden <=900px.
- No generated files modified, no commits; source and git status audit only. Browser/build are pending user authorization.
