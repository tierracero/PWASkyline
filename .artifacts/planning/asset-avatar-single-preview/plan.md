# Single asset avatar preview

Date: 2026-10-14

## PLAN

User scope: remove the lower photo from the asset item panel; retain one main preview with up to five clickable image dots; clicking that preview opens all associated photos in MediaViewer at the selected image.

Primary checklist: `.agent/skills/swifweb_ui_skill.md`. Architecture IDs: SWWEB-001, SWWEB-002, SWWEB-003. No boundary, API, upload or theme changes.

- Remove the separate mediaGrid render from AssetItemView and its now-unused private mediaGrid/imageSource helpers.
- Change CustAssetsAvatarUploader's dot prefix from four to five. Preserve existing preview selection, saved avatar state, upload controls, full image list and selected-index MediaViewer opening.
- Synchronize the existing architecture fact, project memory and task archive. Keep all pre-existing source/document changes intact.
- Audit against saved working-tree baselines, inspect selection/full-gallery paths, run whitespace checks and compare git status. Do not run builds or tests without explicit user confirmation.

Completion: a single photo preview in the asset detail media panel, at most five dots that each select their corresponding photo, and all associated photos reachable in the existing viewer starting at the selected photo.

## Reviewed before source mutation

Self-reviewed against the UI checklist and repository workflow. The duplicate is explicitly rendered by mediaColumn's mediaGrid call. Both private helpers are used only for that redundant grid. The uploader already switches selectedImageSource by index and passes the full images array plus selectedImageIndex to MediaViewer; only its dot cap needs changing. No independent review or subagent work is required. Saved baselines preserve the user's existing edits.
