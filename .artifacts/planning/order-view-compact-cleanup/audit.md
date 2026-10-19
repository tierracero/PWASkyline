# AUDIT — OrderView compact cleanup

Date: 2026-10-15

## Seven screenshot changes

1. Reactive folio in the outer toolbar beside Cuenta / Órdenes, highlighted with the existing blue palette; nil order/list/other tabs hide the badge. Removed the old side-panel folio row.
2. Existing complete status selector moved into a lazy component on the priority/alert row. Its body is identical after whitespace normalization. Compact pill/arrow sizing preserves state color/tint/border, read-only permission branch, handlers and terminal restrictions. Scoped hidden rules protect hidden options/arrow from flex display overrides, and the menu anchors below its relative holder.
3. All ten configurable inspection fields now use InputCheckbox(State) with their original disabled State. Read the pinned Web implementation to verify change events merge into that same state. The two prepared/delivered rental toggles are unchanged. Slots shrink from 70px to 24px; native boxes use 17px sizing. Only diagnosis/resolution add actions receive 14px typography.
4. Existing tag1/tag2 fields share a responsive grid while keeping read/edit/visibility bindings; both inactive hides the row.
5–6. Blue decorative SVG service-letter and contract icons added beside the existing text. Original header/add actions retained.
7. Address header uses a blue map SVG and left-aligned title. Its existing expand toggle and map/address body are unchanged.

## Evidence and preservation

- Reviewed changes.diff and original source handlers/layout/cascade. source-audit.json confirms normalized status body match, ten native checkbox state bindings, two rental toggles retained and two diagnosis action classes.
- final-source-audit.json confirms unchanged onClick counts and API call expressions in all four changed source files, plus zero task-added whitespace.
- Four sources changed: AccoutOverview.swift, OrderView.swift, OrderView+EquipmentView.swift and TCOrderViewTheme.swift. UI architecture/memory/task archive synchronized. No new paths, boundaries or ID ownership, so no source-map/index change needed.
- StartServiceOrder.swift changed externally during this task (detected by its protected hash); this task never wrote it. Other protected source files are unchanged. Final git status preserves existing entries and contains no unintended task-created source paths.
- Inset holder geometry, floating corner icon implementation, API contracts, dependency pins, generated assets and all unrelated user work were left intact.

## Approved build follow-up

The user subsequently explicitly approved the focused App build. Ran swift build --target App --jobs 4 --disable-automatic-resolution, with the previously verified workspace module/cache/config/security paths. Exit status: 1.

The log contains compile actions for all four layout sources: AccoutOverview.swift, OrderView.swift, OrderView+EquipmentView.swift and TCOrderViewTheme.swift. No diagnostics reference these layout files. The full target failed on LoadBudgetObjectSOCDecoder.codeType, which is absent from both the pinned and local TCFundamentals source, in three externally edited callers:

- BudgetView/Budget+HistoricItemPreView.swift:282.
- BudgetView/BudgetView.swift:1505.
- SalePoint/SalePointView.swift:2282.

The additional cannot-infer-adjustment messages follow from that missing member. build-errors.txt records the six unique diagnostic lines. These source edits belong to concurrent charge work, not this layout change; no attempt was made to invent a model field, alter their billing semantics, or change package pins. The reviewed plan records this scope decision.

Build-input hashes confirm all four layout sources and Package.swift/Package.resolved were unchanged during the build. The original external source-change note predates further concurrent charge edits, which were also left untouched. Complete App target validation remains incomplete until those independent errors are resolved. No test suite, browser/runtime execution, staging, commit or deployment was run.
