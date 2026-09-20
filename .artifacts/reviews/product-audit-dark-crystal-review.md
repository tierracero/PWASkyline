# Product Audit Dark Crystal — Modification Review

## Theme foundation
- Added `productAudit` to `TCCrystalSurfaceVariant`.
- Added centralized semantic audit class names to `TCCrystalSurfaceClass` for workspace, shell, header, tabs, actions, panels, toolbars, results, metrics, report headers, charts, modals, and product rows.
- Added `ProductManager+Audit+Theme.swift` to install audit-scoped dark-crystal CSS only once and reuse the existing `TCCrystalSurfaceTheme` palette/root behavior.
- Added responsive rules for desktop, tablet, and narrow/mobile widths.
- Added reusable `reportMetric(...)` and `reportBarChart(...)` presentation helpers derived only from already-loaded report data.

## Audit root
- Applied the product-audit crystal theme at `ProductManagerView.AuditView` root.
- Converted the old audit container into a translucent dark-crystal shell with workspace veil/blur.
- Restyled the main header with the standard `#252c3b` dark-crystal header surface and cyan left rail.
- Restyled Inventarios, Cardex, Transferencias, and Mermas navigation as compact crystal tabs while preserving the existing `currentView` state and click behavior.
- Restyled the Compras/history action as a crystal action.
- Marked each major child content surface as an audit panel.

## Inventory report
- Crystal-styled filter toolbar and results surface.
- Existing inventory KPI cards now participate in the audit metric treatment.
- Added an `Estado de inventario` visual bar comparison for low, out-of-stock, and shortage-unit counts.
- Preserved all existing user work for general inventory summaries, low inventory, aging, store/department detail, Cardex loading, and daily-sales averages.

## Cardex / Products report
- Crystal-styled filter toolbar and results surface.
- Preserved existing user work adding sold units, daily average, grouping, and per-product Cardex graph buttons.
- Added a concise report header showing store and date range.
- Added KPIs for products, initial units, entries, removals, sold units, sales/day, final inventory, and final inventory value.
- Added a `Movimiento de unidades` bar visualization comparing initial, incoming, outgoing, sold, and final units.
- Detailed table remains the authoritative detail view after the summary.

## Transfers report
- Crystal-styled filter toolbar and results surface.
- Added a concise origin → destination/date-range report header.
- Added KPIs for outgoing/incoming documents, outgoing/incoming units, outgoing/incoming cost, net unit balance, and affected Cardex products.
- Added a simple incoming-vs-outgoing unit-flow chart.
- Preserved all existing outgoing, incoming, totals, detail tables, and document drill-down behavior.

## Mermas report
- Crystal-styled filter toolbar and results surface.
- Added report header with store/date range.
- Added KPIs for document count, affected units, average units per document, and largest document.
- Added a chart of the eight documents with the greatest unit loss.
- Preserved existing row rendering and document drill-down behavior.

## Standalone audit child views
- `ProductSearch`: dark-crystal modal/workspace, crystal result surface, and themed selected-product rows.
- `ProductItemRow`: crystal row surface while preserving image/remove behavior.
- `InventoryDetail`: dark-crystal standalone workspace, header, and modal panel; detail table remains unchanged functionally.
- `CardexGraphView`: dark-crystal standalone workspace/modal/report header; balance metrics use crystal KPI cards while preserving the existing graph logic.

## Behavior intentionally unchanged
- API endpoints and request payloads.
- Audit navigation/state semantics.
- Search callbacks and selection semantics.
- Existing report download actions.
- Existing Cardex/inventory calculations and pre-existing uncommitted report enhancements.
- No commits or pushes.

## Verification
- Reviewed focused source diffs and final git status.
- Build/tests were not run because PWASkyline repository governance requires explicit user confirmation before any build or test command.
