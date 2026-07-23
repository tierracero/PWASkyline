# Context Budget

Token-efficient behavior for PWASkyline.

## Do First

- Read `AGENTS.md` and `SKILL_INDEX.md`.
- Use `ARCH_INDEX.md` to choose one architecture chunk.
- Use `SOURCE_MAP.md` to find exact file locations.
- Search by domain-specific terms before opening large files.

## Avoid By Default

- Do not open all files in `Sources/App/API/**`.
- Do not open all files in `Sources/App/Snippits/**`.
- Do not inspect `WebSources/node_modules/**`.
- Do not inspect `.build/**` unless the task is specifically about build artifacts.
- Do not read generated WASM bundles or minified JS unless debugging output generation.

## Escalate When Needed

Escalate context only when the current file references another exact type, endpoint, message, route, CSS class, or asset path required for correctness.

