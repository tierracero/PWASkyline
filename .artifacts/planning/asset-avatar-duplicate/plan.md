# Prevent a duplicate avatar gallery entry

Date: 2026-10-14

## PLAN

User scope: stop the first asset photo appearing twice. Screenshot shows four dots while the created Kardex event contains three images.

Primary checklist: `.agent/skills/swifweb_ui_skill.md`. Architecture IDs: SWWEB-001/002/003. Source map and primary UI architecture loaded earlier remain applicable.

- Add a private comparison-only image identity helper in CustAssetsAvatarUploader. Resolve the current destination source, ignore query/fragment cache suffixes, and strip one recognized thump_/og_/wap_ filename variant prefix. Preserve source directory/host and original render URLs.
- Use the identity to reconcile the saved avatar against existing file/avatar references before adding a standalone fallback. Reuse the matched MediaFile (including original URL/fileId) and move it first.
- Apply the same comparison to upload reconciliation so an existing variant is replaced consistently instead of appended separately.
- Keep unrelated photos, original media records, saved avatar state, five-dot cap, selected-index viewer behavior, Kardex, upload transport and other views intact.
- Synchronize the existing uploader architecture fact and append memory/task archive.
- Review baseline-relative source diff, identity cases, empty/fallback behavior, original-file preservation and git status. No builds/tests without explicit confirmation.

## Reviewed before source mutation

Self-reviewed against repository workflow and UI checklist. refreshImages currently adds a synthetic image when both exact URL comparisons fail; derivative/cache variants can therefore create an extra gallery item. Existing ImageEditor/MediaViewer naming and prior asset fileNet evidence establish og_/thump_/wap_ variants. Comparing canonical names fixes this insertion path without removing genuine photos or rewriting media URLs. Directory/host are retained to avoid collapsing same-named files from different paths. A truly absent avatar still gets the existing fallback. No independent reviewer or subagent work required.

Completion: an avatar matching a known file or its derivative shares one dot/viewer entry; all genuine photos remain, with five-dot navigation and original media filenames retained. Browser reproduction remains pending runtime validation. Screenshot inspected; recording not decoded because no video frame extraction runtime is available locally.


## Reviewed plan extension before caller mutation

The pinned CustGeneralFiles contract includes isAvatar. In AssetItemView's existing MediaFile mapping, use the nonempty saved item avatar as the preview reference for the explicitly marked avatar record. This preserves that record's original file and ID while making its association explicit, even for different filename formats. Preserve the record's own avatar when unmarked or when the saved avatar is empty. This small caller extension supplements filename-variant reconciliation without changing shared MediaViewer contracts or runtime/API ownership. Source contract and render ordering were reviewed before changing the caller.
