# Store user-list unused height

Date: 2026-10-14

## PLAN

Primary checklist: `.agent/skills/swifweb_ui_skill.md`; supporting documentation-sync checklist. Architecture IDs: SWWEB-001 and SWWEB-002.

The supplied five-second recording shows the users and tools cards ending roughly 150px above the content area's bottom. Preview plus frames at 25%, 50%, and 85% were inspected locally. The cards' height follows the four tool rows while the store container extends lower. The parent UserStoreConfiguration binds the selected StoreView to display:block, overriding the storeWorkspace theme's display:flex. Consequently the cards' flex growth does not apply. The previous usersContainers zero-basis scroll sizing is retained.

Scope in the main checkout `/Users/victorcantu/Development/SwifWeb2.0/PWASkyline`:
- `Sources/App/Snippits/Tools/SystemSettings/Tools+SystemSettings+UserStoreConfiguration/Tools+SystemSettings+UserStoreConfiguration.swift`: bind existing and newly created StoreView visibility to none/flex, preserving the selected-store condition. This lets the card grid fill the bounded workspace and grow the user scroll area.
- Update the existing store-list fact in `.agent/architecture/SWIFWEB_APP_ARCHITECTURE.md` and `.agent/PROJECT_MEMORY.md`; append scoped completion evidence to `.agent/TASKS_ARCHIVE.md`.
- Preserve StoreView.usersContainers, theme rules, loading, APIs, cards, actions, unrelated user changes, and generated output.

Completion: all three StoreView creation paths use flex for the selected store and none otherwise; the already bounded flex/grid chain can use the full available height. Excess user rows keep scrolling within their card.

## Reviewed plan

Self-review before source mutation: confirmed the theme's storeWorkspace flex column, cards flex growth/grid track, flex cards, and user overflow sizing; inspected Swift Web display/hidden implementations. The hidden attribute alone can be overridden by author CSS display, so the newly-created-store path also needs the explicit display binding. All conditions use the same selected-store IDs as before. No server behavior, architecture boundary, ownership, module or path changes; ARCH_INDEX/SOURCE_MAP/MODULES need no update.

Audit uses baseline-relative diff/whitespace review and git status/content comparisons. No build, test, compiler or live-browser execution without user confirmation. The supplied recording is evidence of the original problem; the fixed rendering remains unverified. No staging or commit.

## Plan refinement before mutation

The patch guard found two new-store creation paths (default store creation and chosen-type creation), in addition to the initial store list. Re-reviewed scope: change the initial display binding to none/flex and add matching visibility to both creation callbacks, in the same parent source file. No source mutation occurred before this refinement.
