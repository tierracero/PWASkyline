# Reapply the asset avatar gallery

Date: 2026-10-13

## PLAN

The gallery remains intact in `/Users/victorcantu/.codex/worktrees/ee63/PWASkyline`. The requested behavior is absent from the main checkout `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`. That checkout has substantial unrelated user changes, including a newer MediaViewer implementation and a 22px upload icon. Restore only the missing gallery there.

Architecture IDs: SWWEB-001, SWWEB-002, SWWEB-003. Primary checklist: `.agent/skills/swifweb_ui_skill.md`.

- Restore image-list initialization, avatar-first ordering, selected preview, at most four 12px selection dots, clicked-image MediaViewer opening, and the existing guarded gallery upload updates in `Sources/App/VirtualControlers/CustAssetsAvatarUploader.swift`.
- Restore only the `images:` argument in `Sources/App/Snippits/CustAssetsView/CustAssets+AssetItemView.swift`, mapping its existing image records. Preserve all unrelated item, service-card, Kardex, layout and API changes.
- Keep the main checkout's MediaViewer unchanged: it already supports the selected index, absolute media sources, and `allowsMediaActions: false`.
- Preserve the current title/upload layout and the 22px upload icon. Do not copy entire source files or apply the prior store-location patch.
- Synchronize the gallery fact and task record in the main checkout's existing UI architecture, project memory, and task archive. No architecture boundary rules, source paths, or modules change.
- Prepare and review a baseline-relative patch in this writable worktree first. Apply it to the main checkout only after filesystem escalation succeeds, with exact-content guards to prevent overwriting concurrent edits.

Completion: main uploader accepts an image list, focuses the avatar first, shows no more than four dots, switches its preview without changing the saved avatar, and opens the selected image in the existing viewer. Existing callers remain valid via the empty default image list.

## Reviewed before source mutation

Self-reviewed against repository PLAN → IMPLEMENT → AUDIT and the UI checklist. The complete previous restoration is available as a source reference; only missing hunks will be applied. MediaViewer support and the asset-item media field mapping were verified read-only. No independent reviewer is required by repository instructions, and no subagents are authorized.

No build, test, full compilation, browser execution, staging, or commit is authorized. Audit uses source/diff inspection, whitespace checks, and git status. Filesystem escalation is needed because the main checkout is outside this task's writable roots.
