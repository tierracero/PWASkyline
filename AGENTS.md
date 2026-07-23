# PWASkyline — Agent Governance

## Repository Identity

PWASkyline is the Swift Web / WebAssembly PWA client for Tierra Cero Skyline 2.0.

The repository is a Swift Package with two executable targets:

- `App` — browser-facing Swift Web application.
- `Service` — Swift ServiceWorker manifest/runtime and static-resource packaging.

The app integrates Skyline business workflows including service orders, point of sale, inventory, fiscal documents, Carta Porte, messaging, mail, social integrations, routes, documentation, rewards, and PWA/mobile helper flows.

## Authority Hierarchy

1. `.agent/SYSTEM_RULES.md` — global invariants.
2. `.agent/WORKFLOW.md` — mandatory PLAN -> IMPLEMENT -> AUDIT workflow.
3. `.agent/COMMIT_RULES.md` — git, staging, and user-work safety.
4. `.agent/PRODUCT_SCOPE.md` — product facts and scope boundaries.
5. `.agent/ARCH_INDEX.md` — architecture routing and ID ownership.
6. `.agent/architecture/*.md` — authoritative architecture chunks.
7. `.agent/OPEN_DECISIONS.md` — unresolved decisions.
8. `.agent/MODULES.md` and `.agent/SOURCE_MAP.md` — repository navigation.
9. `.agent/REFERENCE_PROJECTS.md`, `.agent/CONTEXT_LOADING_RULES.md`, `.agent/SKILL_INDEX.md` — context routing.
10. `.agent/TASKS.md` — active work.
11. `.agent/skills/*` and `.agent/templates/*` — operational guidance.
12. `.artifacts/**` — transient evidence only; never stable authority.

## Mandatory Workflow

**PLAN -> IMPLEMENT -> AUDIT**

- Non-trivial work requires a reviewed plan before source mutation.
- If implementation reveals a broken assumption, stop and re-plan.
- Do not stack speculative fixes on top of unexpected failures.
- Keep source changes focused and preserve existing user edits.

## Context Loading

1. Start with `.agent/SKILL_INDEX.md`.
2. Use `.agent/ARCH_INDEX.md` to identify the primary architecture chunk.
3. Load one primary architecture chunk and at most two supporting chunks by default.
4. Read `.agent/SOURCE_MAP.md` before touching source, generated assets, or build configuration.

## Git Safety

- See `.agent/COMMIT_RULES.md` before any git operation.
- Never disturb unrelated user work.
- Never commit unless explicitly requested by the user.

## Documentation Sync

- Stable docs must match verified implementation state.
- Transient debugging notes, screenshots, logs, and one-off analysis belong in `.artifacts/**`.
- Architecture changes must update the owning architecture chunk and `.agent/ARCH_INDEX.md`.

## Verification

Always ask the user for confirmation before running any build or test command. Do not treat a request to implement or fix code as implicit permission to run builds or tests. If the user does not confirm, complete the audit with non-build checks and clearly report that builds and tests were not run.

No work is complete without concrete evidence: a focused build/test/lint/manual validation result where feasible, a reviewed diff, and git status confirming only intended files changed.
