# System Rules

Global invariants for PWASkyline development.

## Documentation-First Development

- Every non-trivial change requires a reviewed plan before implementation.
- Stable documentation must reflect verified implementation state.
- Transient debugging notes belong in `.artifacts/**`, never in stable docs.

## Preserve Existing User Work

- The repository may contain uncommitted user changes.
- Before editing, inspect git status and limit changes to the approved path scope.
- Do not reformat, rename, move, or regenerate unrelated files.
- Do not overwrite generated assets unless the task explicitly requires it.

## Single Authority Per Rule

- Each rule, state category, and architecture concern has exactly one authoritative owner document.
- Router documents may link to authority but must not restate alternate rule text.
- `.agent/ARCH_INDEX.md` owns the architecture ID ownership table.

## Verified Fact vs Planned Design

Stable docs must distinguish:

- **Verified facts**: confirmed in the current codebase or repository layout.
- **Stable boundaries**: reviewed architectural rules with owned IDs.
- **Open decisions**: unresolved questions tracked in `.agent/OPEN_DECISIONS.md`.
- **Deferred work**: future tasks listed in `.agent/TASKS.md`.

Do not describe planned mechanisms as settled implementation facts.

## Swift Web Boundary Discipline

- Browser-facing UI code belongs to the `App` target.
- Service worker behavior and manifest/resource packaging belong to the `Service` target.
- Generated public artifacts are outputs, not primary source authority.
- JavaScript/WASI bootstrap code must remain a boundary layer for Swift/WASM execution.

## API and Runtime Boundary Discipline

- API endpoint wrappers must keep request/response contracts explicit.
- WebSocket message handling must preserve causality and idempotency.
- Local browser storage and global caches must not silently become independent source-of-truth state when server/API authority exists.
- Security-sensitive logic must be centralized and reviewed, not scattered through UI handlers.

## No Speculative Implementation

- Do not implement new subsystems without a scoped task and architecture owner.
- Do not mix unrelated refactors with bug fixes.
- When a task touches fiscal, payment, authorization, session, or file-upload flows, prefer small verified changes over broad rewrites.

