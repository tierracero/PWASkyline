# Work folio single submission — 2026-10-09

## Request and observed cause

Investigate and fix matching codes loading twice from WorkViewControler.searchFolio. The work search input installs two key-up handlers: its own delayed formatted-code search and InputText.onEnter's immediate search. Enter currently schedules the delay as well as submitting immediately, and timers created by earlier keys remain eligible while the input text is unchanged. The ignored-key check compares field text instead of event.key. Formatted-code API dispatch already returns after one branch; the duplicate originates before dispatch.

## Scope and architecture

- Source: Sources/App/ViewControlers/WorkViewControler.swift, limited to search presentation state, search input events, searchFolio entry/result query snapshot and removal cleanup.
- Documentation: one verified fact in .agent/architecture/SWIFWEB_APP_ARCHITECTURE.md and completed-task entry in .agent/TASKS_ARCHIVE.md.
- IDs: SWWEB-001 (App owns UI), SWWEB-002 (preserve routing/lifecycle), SWWEB-003 (local presentation state only).
- Preserve existing user edits, search dispatch branches, mobile-scanner routing, API wrappers, caches, themes, assets, dependencies and startup configuration. No commit or staging.

## Implementation

1. Add a controller-owned debounce generation token, without global state.
2. Exclude Enter/NumpadEnter and ignored event keys from automatic search scheduling. Ignored navigation/modifier keys leave a valid pending search intact.
3. Capture raw input plus its normalized formatted code. Only the latest generation for unchanged input in the attached controller may submit after 0.37 seconds.
4. Invalidate the pending generation whenever searchFolio is invoked (Enter, search button, mobile scanner or automatic search) and when the controller leaves the DOM.
5. Pass the captured normalized code to searchFolio. Clear the automatically submitted field immediately, eliminating the existing 0.25-second interval in which Enter could submit the already searched code again. Manual submissions retain their existing text behavior.
6. Pass the submitted local term to the advanced-results view, preserving the result query when automatic clearing or later typing changes the live field.
7. Check for an empty submitted term before minimizing account views. After automatic clearing, later Enter/click should neither submit again nor hide the result that just opened.

## Completion and verification

- Review exact event traces for fast typing, Enter before/after the debounce, NumpadEnter, ignored keys, click/mobile submission before the debounce, input replacement, normalized separators and DOM removal.
- Run Swift frontend parsing and the previously user-approved focused App build using existing resolved dependencies/module cache. No new test suite, browser/server mutations, or scanner redesign.
- Review baseline-relative diff and whitespace; compare repository status/staging and dependency pins to baseline. Preserve unrelated modified/untracked files.
- Record evidence and browser/hardware-scanner validation limits in AUDIT.md; synchronize verified docs only after implementation review.

## Plan review

Reviewed against the local InputText.onEnter and Web KeyUpHandleable implementations. The fix handles both key-up subscribers without relying on their callback order, cancels earlier timers on all submissions, and preserves intentional subsequent searches. Immediate automatic clearing closes the auto-first/Enter-later race. No architecture boundary or new file ownership changes are required.

Follow-up plan review: source audit found the fallback result view reading self.searchTerm after the network response. Earlier field clearing would discard that label. Before editing this response line, the plan was amended to use the submitted term already captured by searchFolio, with no API or dispatch-branch changes.

Final plan review: searchFolio currently minimizes account views before rejecting an empty term. Immediate automatic clearing makes this order observable when a later Enter follows a fast result. Move the existing empty check before minimization while retaining generation invalidation at entry. This is a focused response-preservation adjustment within searchFolio's planned entry scope; no lookup or valid-submission behavior changes.
