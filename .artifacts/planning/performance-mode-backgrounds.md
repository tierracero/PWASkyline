# Performance mode background fallback

Date: 2026-09-29

## PLAN — reviewed against current source

- Scope: `Sources/Service/skyline/js/visualPerformance.js`, with a verified-fact update in `.agent/architecture/SWIFWEB_APP_ARCHITECTURE.md`.
- Architecture IDs: SWWEB-001/SWWEB-002 and PWA-001/PWA-002/PWA-003. Existing ownership, lifecycle, and resource paths remain intact; no boundary rule changes.
- The controller already derives performance mode from the six expensive-effect switches, initializes from the persisted cookie, and removes backdrop filters using high-specificity CSS.
- Publish the derived mode as a root data attribute. Use matching CSS to replace modal veils with 65%-black backgrounds and known glass content shells with 85%-black backgrounds.
- Keep the selectors focused on named overlays and content panels. Preserve inner headers, controls, accent colors, white print canvases, and normal-mode glass presentation.
- Completion: reviewed diff; verify selector names against source, attribute updates on initialization/toggle, and automatic fallback removal when disabled; inspect git status for intended additions only.
- Builds/tests require user confirmation. Perform source/diff review without running them unless authorized. Do not regenerate public outputs.

## Review

The plan uses CSS for existing and newly mounted modals, without DOM scans or observers. Repeated root attributes follow the existing controller's specificity strategy and beat theme `!important` backgrounds. All previously modified files remain outside the edit scope.

## AUDIT — source and diff review

- Added two performance-mode-only background rules and the root attribute update in the existing settings application function.
- Reviewed initialization through the existing persisted settings call, runtime toggling through `setPerformanceModeEnabled`, and attribute removal from matching CSS (`off`) when the mode is disabled. No style mutations are applied to individual elements.
- Reviewed named classes against the Swift theme declarations, including crystal panels, Trip popups, Account detail, Order shell, user dialogs, and login recovery. Existing blur-disable rules remain unchanged.
- Scoped `git diff --check -- Sources/Service/skyline/js/visualPerformance.js .agent/architecture/SWIFWEB_APP_ARCHITECTURE.md` passed. The unscoped check reported existing whitespace in unrelated user changes; those files were left untouched.
- Git status shows only these two tracked files plus this planning artifact added to the starting set of user changes.
- No builds, tests, or browser rendering were run; user confirmation for builds/tests was not provided. Visual appearance remains unverified in a browser.
- Generated `DevPublic`/`DistPublic` outputs were not refreshed. No commits or staging were performed.
