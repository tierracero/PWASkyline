# Plan — Remove login gray flash

## Scope

- `Sources/App/Styles/SKLogInStyle.swift`
- No authentication, session, routing, startup-sequence, generated asset, or service-worker changes.

## Architecture

- `SWWEB-001` — the fix remains in the browser UI style layer.
- `SWWEB-002` — preserve the existing login-to-work route and lifecycle timing.

## Diagnosis

The `.tc-login-handoff` transition fades the login mesh canvas to `opacity: 0` before `History.pushState(path: "work")` runs 560 ms later. During the last part of that delay, the page exposes the flat `#1D2026` fallback background, creating the visible gray flash.

## Implementation

1. Keep the login content/card fade-out unchanged.
2. Keep the mesh canvas rendered through the handoff instead of fading it fully transparent.
3. Retain a subtle scale/darken/blur treatment so the transition still communicates progress without exposing the flat fallback color.
4. Preserve the reduced-motion behavior and route delay.

## Completion Criteria

- The handoff selector no longer drives the mesh canvas to zero opacity.
- No authentication or session code changes.
- Focused diff contains only the intended style adjustment plus this transient plan.
- Build/test is not run without explicit user confirmation, per repository rules.
