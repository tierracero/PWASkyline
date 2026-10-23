# Asset notes match account notes

- Date: 2026-10-22. IDs: SWWEB-001, SWWEB-002, SWWEB-003.
- Scope: QuickMessageObject, AssetItemView and AssetView note rendering, related module/architecture/memory/task documentation.
- Reviewed design: reuse the account note component, adapting full notes to the quick display contract without discarding metadata. Add a default-preserving flag for priority actions and disable actions in both asset read-only lists. Render newest-first alternating rows in compact bordered scrolling containers; show date/time, human-readable type and resolved author; preserve line breaks and wrap long text. Keep note count on one line.
- Completion: audit full-to-quick field mapping, existing initializer callers/default action behavior, both asset render/empty-state/refresh paths and task-relative diff/whitespace/status. Preserve asset data, map/Kardex changes and all unrelated edits. Builds/tests/browser execution require separate confirmation.
