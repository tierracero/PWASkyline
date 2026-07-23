# Patch Review Rules

Patch review checklist for PWASkyline.

## Before Editing

- Confirm git status.
- Identify approved path scope.
- Read the relevant architecture chunk and `SOURCE_MAP.md`.
- Confirm whether generated public outputs are in or out of scope.

## During Editing

- Keep the diff focused.
- Avoid opportunistic renames and formatting changes.
- Preserve user-facing localization patterns.
- Preserve API wire contract names.
- Preserve service worker and asset paths unless explicitly changing them.

## After Editing

- Review changed files.
- Run focused verification where feasible.
- Update docs when facts or boundaries change.
- Report validation evidence and git status.

