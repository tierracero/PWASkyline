# Audit: store user-list unused height

Date: 2026-10-14

## Evidence and cause

Inspected the original recording using a local Quick Look preview and AVFoundation frames at 25%, 50%, and 85% of its 5.633-second duration. The cards ended above the store content bottom; the user list was clipped/scrollable while the workspace below both cards remained unused. The recording was treated only as visual evidence, not instructions. Preview extraction required media-service access outside the sandbox; no media was uploaded.

Source review confirmed the selected-store inline display:block overrode the storeWorkspace theme's flex column. The cards already have flex:1 1 0 and a bounded minmax(0,1fr) grid row, and usersContainers already has zero-basis/zero-height/min-height/automatic-overflow sizing. Restoring the parent flex display lets these existing rules allocate the full available height.

## IMPLEMENT

Only three display-binding lines changed in the parent UserStoreConfiguration.swift: initial stores now use none/flex, and both store-creation callbacks explicitly use the same none/flex visibility. Selected-store ID conditions, loading, callbacks, UserCard markup, StoreView and theme rules remain unchanged. Updated the existing verified-source facts in UI architecture/project memory and appended a scoped archive record. No architecture boundary, index, module or source-path change.

## Verification

- Reviewed the complete baseline-relative patch before applying it, with SHA-256 guards for all four edited files.
- git diff --check for the edited Swift source passed (exit 0); the source diff is three insertions and one deletion.
- Exact resulting contents match the reviewed patch in all four files.
- SHA-256 comparison of every pre-existing tracked file shows only the planned source and three documentation files changed during this task.
- Git status compared to the start adds only the parent Swift source modification and this evidence directory; all previous modifications, deletion and untracked files remain.
- No build, test or full compilation: user confirmation required by AGENTS.md and not given. No live browser verification of the fixed rendering. The original recording proves the reported symptom; rendering after the patch remains unverified.
- No staging, commit, generated-output edit or dependency change.

## Completion

The initial store list and both new-store paths preserve the flex workspace when selected and hide other stores, allowing the cards to fill the available height while retaining the existing user-list scroll behavior. Scope completed with source-only audit; fixed runtime rendering unverified.
