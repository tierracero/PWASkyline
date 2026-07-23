# Project Memory

Durable facts and current state for PWASkyline. Link to authority instead of duplicating rules.

## Product Identity

- **Project**: PWASkyline.
- **Owner/product family**: Tierra Cero Skyline 2.0.
- **Type**: Swift Web / WebAssembly PWA.
- **Primary language**: Swift, with JavaScript/WASI bootstrap support.

## Current Baseline Verified 2026-07-08

- Root project path: `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`.
- Git repository exists on branch `main...origin/main`.
- No pre-existing `AGENTS.md` or `.agent` docs existed before this bootstrap.
- Agent governance bootstrap created 36 documentation files total: root `AGENTS.md` plus 35 Markdown files under `.agent/**`.
- `Package.swift` defines executable products `App` and `Service`.
- `Sources/App/App.swift` registers `./service.js`, manages lifecycle hooks, sets localization defaults, defines route pages, and switches between main/skyline/login styles.
- `Sources/Service/Service.swift` defines PWA manifest fields and service-worker lifecycle handlers.
- `WebSources/package.json` includes webpack/WASI/JavaScriptKit-related dev dependencies.

## Current Caution

When this governance bootstrap began, the repository already contained many modified and untracked source files. Future agents must preserve those user changes and avoid broad formatting or regeneration.

## Error Reporting Baseline Verified 2026-07-16

- `ErrorReportingControler` is the single owner of diagnostic capture, IndexedDB persistence, immediate and 10-minute retries, account isolation, and 60-day cleanup.
- All three `sendPost` overloads use one internal transport with callback-once protection and automatic encoding, network, timeout, abort, HTTP-status, and empty-response reporting.
- API decoding under `Sources/App/API/**` uses `decodeAPIResponse`; the error-report endpoint intentionally uses a direct decoder and reporting-disabled transport to prevent recursion.
- `WebSources/errorReportingIndexedDB.js` owns the `PWASkylineDiagnostics/errorReports` schema and multi-tab atomic claims.
- Diagnostic priority uses `TCFundamentals.ErrorReportingPriorty` directly and is persisted as `priorty` plus `priorityRank` (`zero`/`low`/`med`/`high`, ranks `0`/`1`/`2`/`3`). IndexedDB schema version 2 migrates legacy `medium` and `critical` queue values to `med` and `high`.
- Generated public output trees were not refreshed by the error-reporting implementation.

## Authoritative References

- Product facts: `PRODUCT_SCOPE.md`.
- Architecture boundaries: `ARCH_INDEX.md` and `architecture/*.md`.
- Source layout: `SOURCE_MAP.md`.
- Modules: `MODULES.md`.
- Open decisions: `OPEN_DECISIONS.md`.
