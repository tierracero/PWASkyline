# WASM settings parameter limit

Reviewed plan — 2026-10-05

Primary skill: API endpoint checklist; supporting PWA build checklist. IDs API-001/API-002/PWA-002/STATE-001. No boundary changes.

## Diagnosis

- Read the existing DevPublic/app.wasm type/function/name sections without compiling or executing the module. Type 309 starts at byte 12303 and has a 1001 parameter count at byte 12304, matching the reported browser offset. Type 310 has 1016 parameters. Six functions use these types; their names identify optional copy/take helpers for CustComponents.SincCustSettingsResponse and APIResponseGeneric<SincCustSettingsResponse>.
- DevPublic/app.wasm is 348180665 bytes; DistPublic/app.wasm is 65167160 bytes and its largest signature has 985 parameters. Do not replace artifacts with that older release.
- V8's official src/wasm/wasm-limits.h defines kV8MaxWasmFunctionParams = 1000. This is module validation before app startup, not a JavaScript loader or recent-view error.
- The shared settings response is a large value aggregate. The app wrapper is its only client callback/decoder specialization; loadBasicConfiguration consumes inferred settings fields.
- Existing inspected preload links have resource-appropriate as attributes. Their warnings can follow aborted startup; individual URL-specific preload issues cannot be established from the redacted messages alone.

## Scope and implementation

1. Sources/App/API/CustEndpoint/CustAPI+SincCustSettings.swift: define a final immutable Payloadable class snapshot with the exact shared response fields/required-optionality and JSON keys. Decode and return APIResponseGeneric<snapshot> directly, avoiding creation or boxing of the oversized shared struct. Preserve POST route/payload, status/data envelope, callback shape, failure behavior, and inferred consumer field access.
2. .agent/architecture/API_AND_BACKEND.md: record the local reference-backed settings response and shared wire contract ownership.
3. .agent/architecture/PWA_ASSETS_AND_SERVICE_WORKER.md: record the browser limit and source fix; distinguish current artifact evidence from pending rebuilt validation.
4. Record focused diff/status/static contract checks. Rebuild/validate only with explicit user confirmation (requested asynchronously). Do not manually edit generated outputs, dependencies, lockfiles, or unrelated preload/loader code.

Plan review: Payloadable requires Codable/Sendable; final immutable class fields use the same shared types, permitting synthesized Codable with identical keys and optional handling. Avoid generic box<Value> around the original struct, which could still emit oversized value-copy helpers. No new global state is introduced, and settings/cache assignment logic remains unchanged.

Completion criteria: compare all 15 payload fields with shared declarations, inspect obsolete aggregate specializations, review task-only diff and staged-index preservation, and record explicit build authorization/result or unverified artifact limitation.

## Source audit

- Recorded offending function/type/name evidence in wasm-settings-offending-functions.json. Existing development type 309 has 1001 parameters at byte 12304, precisely matching the reported error; type 310 has 1016. This is a read-only binary inspection, not an instantiation/test or rebuilt validation.
- Static declaration comparison confirms all 15 client fields match the shared response in name, type, order, and optionality. The snapshot is final and immutable and synthesizes the same Codable field keys. POST routing, EmptyPayload, transport/decode errors, status/data envelope, and loadBasicConfiguration's inferred field accesses are preserved. No conversion to the shared settings aggregate remains in App.
- Reviewed the focused patch in wasm-settings.diff. All three task-only no-index whitespace checks emitted no diagnostics (exit 1 indicates changed files). The cached binary diff SHA-256 is unchanged; status comparison shows only the intended wrapper/document modifications and new task artifacts. Source-only changes have not modified WASM, generated HTML/JS, dependencies, or lockfiles.
- Existing inspected preload links specify appropriate style/script/image as values. Because startup stops before Swift runs, unused-resource warnings may be a consequence; the provided URL placeholders do not allow attributing individual preload warnings. No speculative preload edits were made.
- Explicit authorization for a WASM rebuild/validation was requested asynchronously. No affirmative response has arrived, so no build/test or runtime validation has run. Existing DevPublic/app.wasm still contains the original oversized signatures; rebuilding is required to validate and deploy the source fix.
- Official limit reference: https://chromium.googlesource.com/v8/v8/+/refs/heads/main/src/wasm/wasm-limits.h (kV8MaxWasmFunctionParams = 1000).
