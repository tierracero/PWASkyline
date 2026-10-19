# OrderView compact layout cleanup

Date: 2026-10-15

Primary checklist: swifweb_ui_skill. Architecture IDs: SWWEB-001/002/003. Source map, owning UI architecture, theme and existing state/control lifecycle reviewed in this session.

## PLAN

Implement the seven numbered screenshot requests in four source files only:

1. AccoutOverview: add a reactive, highlighted order folio next to the Cuenta / Órdenes breadcrumb, visible only in order mode. Remove the duplicate folio from the OrderView side panel.
2. OrderView: extract the existing complete status selector/menu without changing handlers or permission/terminal-state restrictions; place it on the priority/alert row. Theme it as a 32px-high, 16px-text compact pill while retaining tint, text/border state colors, dropdown format and menu. Anchor its menu to a relative holder. Exclude it from generic header button background overrides.
3. EquipmentView: replace only the ten configurable inspection toggles with native InputCheckbox bound to the same boolean states and disabled state; preserve loading, save permissions, payloads and other rental/prepared/delivered controls. Reduce their 70px slots to 24px, and style 17px native checkboxes. Reduce only the add diagnosis/resolution action typography to 14px.
4. Wrap existing configurable tag1/tag2 (Marca/Modelo in the screenshot) fields into one compact row, keeping each edit/read/visibility binding. Preserve every other tag.
5–6. Add decorative blue service-letter and contract SVG icons next to existing labels; keep existing header/add actions.
7. Replace the service-address zoom icon with a blue map icon and align its title left. Keep the existing address toggle and contents.

Keep the inset holder, floating corner icon, all API/business actions and unrelated user changes intact. Reuse the theme palette and the established SVG data-URI pattern (no generated assets/new icon dependency).

Synchronize the owning UI fact, memory and archived task. No architecture boundary/source ownership changes; ARCH_INDEX and SOURCE_MAP do not need rerouting.

Audit all seven mappings, checkbox state/edit restrictions, folio order-switch binding, status DOM/cascade/menu anchoring, action handler preservation and task-relative diff/whitespace/protected hashes/status. A new build/test requires explicit confirmation; prior build approval was for the completed package-sync task.

## Reviewed before source mutation

Self-reviewed against the UI checklist and repository workflow. The existing InputCheckbox(State<Bool>) binding already updates native checkbox state, so the old slider inversion callbacks must be removed with the slider wrappers. The order folio can bind to AccoutOverview.$order without a new state authority. Existing status handlers can be moved verbatim into a retained lazy component. Scoped class selectors will avoid changing controls outside the production order root. No subagents or independent reviewer required.

Completion: screenshot items 1–7 implemented, original order actions/permissions/state preserved, protected source unchanged, concrete source/diff audit and user-approved focused build if confirmed. Browser layout remains unverified unless executed.


## Source-review refinements

The pinned Web implementation confirms hidden() sets an HTML attribute, and InputCheckbox(State) merges change events directly into the existing state. Explicit scoped hidden selectors preserve terminal-status/menu visibility after moving into flex layout, and an absent order hides the reactive folio badge. The inspection rows retain two columns with scoped 50% border-box sizing, matching the existing layout while reclaiming the slider slot/padding. StartServiceOrder.swift changed externally during this task; it was never written by this work and must remain untouched.


## Build authorization

The user explicitly confirmed the focused App build after source completion. Run the same workspace-cache App target build used by the package-sync task, with automatic resolution disabled and four jobs. Fix only diagnostics attributable to this layout change; then update verification records and preserve current user edits.


## Build finding and scope review

The approved build compiled all four layout sources without diagnostics, but found missing LoadBudgetObjectSOCDecoder.codeType in Budget+HistoricItemPreView.swift, BudgetView.swift and SalePointView.swift. Those sources changed externally during the layout work and belong to the concurrent charge-balance-adjustments task. Both pinned and local TCFundamentals model sources lack codeType. Preserve that ongoing work; do not invent billing semantics or widen this layout change. Let the approved build finish, report its full result and update the layout verification evidence. No layout source or package changes are indicated.
