# Work startup background clarity — focused plan

## Scope and constraints
- Only the authenticated `/work` initial animation backdrop.
- Source: `Sources/App/TierraCeroCustomUI/Theme/TCWorkDashboardTheme.swift`.
- Do NOT edit `WebSources/main.html`, `DevPublic/main.html`, or `DistPublic/main.html`.
- Preserve all previously modified source/notes; Git initially contains uncommitted startup version edits.
- No build, test, service worker refresh, or generated output changes without explicit approval.
- Preserve work screen readiness states, progress, exit timing and accessibility mode.

## Changes
1. Lighten the radial background of `startupOverlay` from nearly black to a more transparent luminous blue/navy atmosphere, keeping sufficient contrast for the card, cyan line art and version.
2. Soften `startupRoot .background` suppression: raise underlying background opacity from 0.08 to 0.28; reduce the heavy blur and brightness darkening so the background detail remains visible without revealing interactive content.
3. Do not change `startupCore`, progress bar, version, side-frame geometry, page layout, JS or HTML.

## Audit
- Inspect exact scoped diff and Git status; no edits outside named theme file and this plan or relevant architecture notes.
- Source inspection only; build/browser tests require user approval.
