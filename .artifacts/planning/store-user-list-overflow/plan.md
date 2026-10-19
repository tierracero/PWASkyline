# Store user-list scrolling

Date: 2026-10-14

## PLAN

Primary checklist: `.agent/skills/swifweb_ui_skill.md`. Architecture IDs: SWWEB-001, SWWEB-002.

Target the main checkout `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`, continuing the location used for the previous requested fix. Preserve its unrelated pending user work, including the existing extra blank line in StoreView.

The inspected theme already sets the user list to `overflow: auto`, `min-height: 0`, and `flex: 1 1 auto`. The surrounding StoreView is a bounded flex column, its cards occupy the remaining space, and each card is a flex column with hidden overflow. Constrain `usersContainers` explicitly to a zero flex basis/initial height, allow it to grow inside the card, and retain `min-height: 0` and automatic scrolling. This avoids depending on the list's intrinsic content height and makes overflowing users scroll within the available card area.

- Change only the usersContainers style chain in `Tools+SystemSettings+UserStoreConfiguration+StoreView.swift`: `flex: 1 1 0`, `height: 0`, `min-height: 0`, `overflow: auto`.
- Preserve user loading, counts, cards, clicks, headers, actions, and the existing theme.
- Record the verified source layout in the owning UI architecture chunk and project memory, and archive the scoped fix with an explicit runtime-verification limitation.
- Prepare and review the exact baseline-relative patch before source mutation. Apply to the main checkout through filesystem escalation with content guards.

Completion: list sizing is bounded by its card, excess rows can scroll, and all existing user interactions remain unchanged.

## Review before implementation

Self-review completed against the repository workflow and UI checklist. The full shell → workspace → content → store container → StoreView → cards → card → user list height/overflow chain was inspected. The fix is confined to the user list rather than adding a fixed viewport maximum or changing every card. No architecture boundary rule, path or module changes; source-map/index updates are unnecessary. No subagents are authorized or required.

Audit: inspect the focused diff, validate patch whitespace/application, and compare git status to the starting snapshot. Builds, tests and full compilation require separate user confirmation and will not be run. Browser rendering remains unverified. No staging or commit.
