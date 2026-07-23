# PWA Build Skill

Checklist for service worker, manifest, WebSources, and public output tasks.

## When to Use

Use before changing:

- `Sources/Service/**`
- `WebSources/**`
- `DevPublic/**`
- `DistPublic/**`
- service-worker registration or manifest paths in `Sources/App/App.swift`

## Checklist

1. Read `architecture/PWA_ASSETS_AND_SERVICE_WORKER.md`.
2. Confirm whether generated/deployable outputs are in scope.
3. For resource changes, prefer source resources under `Sources/Service/**`.
4. For webpack/WASI changes, validate both app and service worker entry behavior when feasible.
5. Verify path consistency: `main.html`, `app.js`, `app.wasm`, `service.js`, `service.wasm`, `site.webmanifest`, icons, and compressed WASM files.
6. Document whether public outputs were regenerated or manually edited.

## Output Safety

Do not edit minified/generated files or WASM artifacts directly unless this is an explicit deployed-output hotfix and source follow-up is tracked.

