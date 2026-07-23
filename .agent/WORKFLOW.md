# Workflow

Mandatory workflow for PWASkyline development.

## PLAN -> IMPLEMENT -> AUDIT

Every non-trivial task follows this sequence:

1. **PLAN**: Produce a reviewed plan before mutation. The plan must name exact scope, affected architecture IDs, and completion criteria.
2. **IMPLEMENT**: Execute the reviewed plan. Do not stack speculative fixes.
3. **AUDIT**: Verify the result with concrete evidence, update docs, and record durable findings.

## Planning Requirement

Planning is required when a task:

- Touches Swift source, JavaScript/WASI bootstrap, service worker behavior, PWA output, API wrappers, WebSocket behavior, fiscal/payment/security flows, or build configuration.
- Changes architecture boundaries, directory structure, target membership, or generated-public-asset rules.
- Introduces or modifies dependencies.

Trivial documentation typo fixes may skip formal planning but still require audit.

## Implementation Fidelity

- Implementation must follow the reviewed plan.
- If implementation reveals a broken assumption, stop and re-plan.
- Do not widen the scope because adjacent code looks messy.

## Smallest Focused Verification

Use the narrowest validation that can confirm the change:

- Swift-only source change: focused `swift build` or target-specific build when feasible.
- WebSources change: `npm`/webpack validation only for affected entry points when feasible.
- Service worker/PWA asset change: validate manifest, generated paths, and dev/dist public output expectations.
- Docs-only change: validate links, source-map accuracy, and git status.

## Documentation Synchronization

After implementation, update affected stable docs before closing work:

- Architecture chunks for changed rules.
- `SOURCE_MAP.md` and `MODULES.md` for path/module changes.
- `PROJECT_MEMORY.md` for durable facts.
- `OPEN_DECISIONS.md` for unresolved design questions.
- `TASKS.md` / `TASKS_ARCHIVE.md` for task status.

## Final Review Evidence

No work is complete without:

- Summary of changed files.
- Verification command/result or explanation of why validation was not run.
- Git status confirming no unintended changes.

