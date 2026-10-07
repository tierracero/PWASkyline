# SearchComertialAsset modal positioning

Reviewed plan — 2026-10-06

Primary checklist: `.agent/skills/swifweb_ui_skill.md`. Architecture IDs: SWWEB-001/002/003; no boundary-rule change.

## Cause and scope

`SearchComertialAsset` mounts through `addToDom`, whose `SuperView` animates the content with CSS `translate`. A translated ancestor establishes a containing block for the fixed `VPopUp` descendant. Unlike the working customer/address modal roots, the asset picker root has no explicit position or width/height. Its fixed popup therefore centers against a root that does not occupy the overlay. The screenshot is consistent with the panel centered above the screen.

Source scope: `Sources/App/Snippits/SearchComertialAsset.swift` only. Documentation scope: verified picker presentation fact in `.agent/architecture/SWIFWEB_APP_ARCHITECTURE.md` and completion evidence in `.agent/TASKS_ARCHIVE.md`.

## Implementation and review

Add the established absolute root frame: top/left zero, width/height 100%. Preserve TCTripBetaTheme then TCCrystalSurfaceTheme(.trip), VPopUp(.fitContent(w: 800)), local filtering, selection callbacks, and list scrolling. Existing VPopUp rules retain viewport-bounded panel/body dimensions. Do not alter the shared host, global popup styles, or unrelated modals.

Completion criteria: source gives the popup a full-overlay containing block; title/search/results/close remain in the existing centered, viewport-bounded panel. Empty/nonempty filtering paths and selection/lifecycle behavior are unchanged.

Audit: review focused source diff against the current user-owned file, inspect inherited popup limits and the call site, check whitespace and final status/staging. The user's earlier instruction to use non-build checks only remains active. No builds or compiler/test commands will run; this audit is limited to source inspection.

## Audit result

- Source delta contains only the six-line root-frame addition (including its explanatory comment). Theme order, popup width/viewport limits, search, filtering, empty states, selection, and cleanup code remain identical to the saved file.
- The absolute zero-offset 100% root matches the established `SearchSubCustomerView`/address-modal frame. Reviewed `SuperView.prepare` translation, `VPopUp` centering, panel viewport maximum height, fit-content body maximum height, and the body grid's `overflow: auto`.
- Source no-index whitespace review produced no diagnostics (exit 1 represents the source difference). Tracked documentation `git diff --check` passed with exit 0.
- Status comparison found no unexpected changed paths or alterations to pre-existing staging. Task-only diff is saved alongside this plan. No commit was made.
- No builds, compiler checks, tests, or browser execution were run. The code fix has not been verified in the running browser.
