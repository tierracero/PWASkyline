# App-wide small-font readability — reviewed plan

User scope confirmed: across the whole app. Primary UI skill; supporting resource checklist for the two source-owned main.css copies. IDs SWWEB-001/002/003 and PWA-001/002/003. Exact font declaration inventory: ui-small-fonts-inventory.json; exact affected paths follow below. Preserve prior staged/unstaged user changes.

Implementation: enlarge explicit 8–11px UI text to 13px and 12–13px UI text to 14px in shared themes and individual views. Retain the required-field superscript as a smaller 10px mark (was 7px). Include state-dependent small font branches and SVG chart label sizes. Keep declarations >=14px, print/receipt/PDF/barcode engines, third-party normalization styles, and superscript relative-size resets unchanged. Increase source-owned footer/version typography in both main.css copies from 10px to 13px. Preserve selector specificity, !important and responsive rule ordering.

Review compact layouts: enlarge too-short fixed label heights in ManagePOC/report hints, adjust small badge padding/width only where larger text would clip, and increase chart edge-label space if needed. No global browser zoom or universal CSS override, no new palette/colors or component refactors. Update owning verified UI fact; no new paths/architecture boundaries.

Completion: inspect proposed numeric edits and remaining small declarations for intentional exclusions. Review shared theme sizing/cascade and compact affected layouts. Record reviewed snapshot diff, focused whitespace check, status and staged hash. User's static-only preference persists: no builds/tests/browser execution or generated public output refresh.

Review: modest, explicit typography increases preserve heading hierarchy and avoid changing printed documents or vendor controls. Approved by self-review before source mutations.

## Exact font-change scope

- `Sources/App/Snippits/AddServiceFormView.swift`
- `Sources/App/Snippits/AdvancesSearchViewControler.swift`
- `Sources/App/Snippits/CartaPorteMerchendise.swift`
- `Sources/App/Snippits/CustAssetsView/CustAssetsView.swift`
- `Sources/App/Snippits/CustConcession/CustConcession+AddManualInventorieView.swift`
- `Sources/App/Snippits/CustConcession/CustConcession+BodegaView.swift`
- `Sources/App/Snippits/CustConcession/CustConcessionView.swift`
- `Sources/App/Snippits/CustFollowUpRowView.swift`
- `Sources/App/Snippits/CustRemoveFromConcessionView.swift`
- `Sources/App/Snippits/FollowupControler/FollowupControler.swift`
- `Sources/App/Snippits/IMChatBubbleView.swift`
- `Sources/App/Snippits/ManagePOC/ManagePOC.swift`
- `Sources/App/Snippits/ManageSOCView.swift`
- `Sources/App/Snippits/MessageObject.swift`
- `Sources/App/Snippits/MoneyManager/FinancialServices/MoneyManger+FinancialServices+DetailView.swift`
- `Sources/App/Snippits/MoneyManager/MoneyManagerView.swift`
- `Sources/App/Snippits/OldChargeTrRow.swift`
- `Sources/App/Snippits/OrderCalendarView.swift`
- `Sources/App/Snippits/OrderView/EquipmentView/OrderView+EquipmentView.swift`
- `Sources/App/Snippits/OrderView/OrderView.swift`
- `Sources/App/Snippits/POCStorageControlItemView.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Activity.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+CardexGraph.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+FastAndFurios.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Inventory.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Merms.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Products.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Theme.swift`
- `Sources/App/Snippits/ProductManager/Audit/ProductManager+Audit+Transfers.swift`
- `Sources/App/Snippits/ProductManager/ProductManagerView.swift`
- `Sources/App/Snippits/ProductTransferReportView.swift`
- `Sources/App/Snippits/SalePoint/SalePoint+HistoryView.swift`
- `Sources/App/Snippits/SideMenuRightView.swift`
- `Sources/App/Snippits/SkylineDocumentation/SkylineDocumentation+DocumentView.swift`
- `Sources/App/Snippits/SkylineDocumentation/SkylineDocumentationView.swift`
- `Sources/App/Snippits/SocialManagerItem.swift`
- `Sources/App/Snippits/StartManualInventory.swift`
- `Sources/App/Snippits/StartServiceOrder.swift`
- `Sources/App/Snippits/StartServiceOrderEquipmentView.swift`
- `Sources/App/Snippits/ToolFiscal/ToolFiscal.swift`
- `Sources/App/Snippits/ToolFiscal/ToolFiscalItemView.swift`
- `Sources/App/Snippits/ToolFiscal/ToolFiscalViewDocument.swift`
- `Sources/App/Snippits/ToolProductAuditTrRow.swift`
- `Sources/App/Snippits/ToolReciveSendInventory.swift`
- `Sources/App/Snippits/ToolReciveSendInventoryManualDispertionsView.swift`
- `Sources/App/Snippits/ToolViewFiscalXMLDocument.swift`
- `Sources/App/Snippits/ToolViewHistoricalInventoryManualDispertionsView.swift`
- `Sources/App/Snippits/Tools/HistorySettings/Tools+HistorySettings+OrderProcessing/Tools+HistorySettings+OrderProcessing+Reports.swift`
- `Sources/App/Snippits/Tools/HistorySettings/Tools+HistorySettings+TripProcessing/Tools+HistorySettings+TripProcessing+Reports.swift`
- `Sources/App/Snippits/Tools/HistorySettings/Tools+HistorySettings+TripProcessing/Tools+HistorySettings+TripProcessing+Settings.swift`
- `Sources/App/Snippits/Tools/SystemSettings/Tools+SystemSettings+UserStoreConfiguration/Tools+SystemSettings+UserStoreConfiguration+UserView/Tools+SystemSettings+UserStoreConfiguration+PermitionManager.swift`
- `Sources/App/Snippits/Tools/Tools+ServiceManager.swift`
- `Sources/App/Snippits/TripControler/TripControler+CreateTripView.swift`
- `Sources/App/Snippits/TripControler/TripControler+TripViewBeta.swift`
- `Sources/App/Snippits/TripControler/TripsControlerView.swift`
- `Sources/App/Styles/SKLogInStyle.swift`
- `Sources/App/Styles/SKMainStyle.swift`
- `Sources/App/TierraCeroCustomUI/Components/TCSpeechRecognitionFloatingButton.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCreateUserTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCCrystalSurfaceTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCMessageObjectTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCOrderViewTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCStoreUserConfigurationTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCTripBetaTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCUserCancelationRequestTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCUserConfigurationTheme.swift`
- `Sources/App/TierraCeroCustomUI/Theme/TCWorkDashboardTheme.swift`
- `Sources/App/ViewControlers/WorkViewControler.swift`
- `Sources/Service/css/main.css`
- `Sources/Service/skyline/css/main.css`

## Audit

- Enlarged 390 explicit font declaration lines across 68 Swift UI files and two source-owned CSS files. Fixed sizes <=11px now use 13px; prior 12–13px supporting text uses 14px. State-dependent equipment/Trip label branches and unitless SVG chart text are included. Superscript required mark increases from 7px to 10px; two compact Work counters, a follow-up status badge, and message folios increase to 12px instead of 13px.
- Reviewed the small-font source inventory and resulting diff. Final non-print scan leaves only five <=12px UI declarations: those four compact labels and the required mark. Print/receipt/PDF/barcode engines, third-party normalization/superscript rules, icons and typography >=14px are unchanged. JS small-font markup belongs to the existing print functions and was excluded.
- Product-price labels now use minimum 20px height instead of fixed 12/18px. Three report help rows use minHeight(20px), allowing wrapped text to grow. Work message folio column/max-width grows from 38px to 48px; folio text becomes 12px. Kardex chart insets and top label baseline gain room for the larger axis/date/value text. Follow-up status has a title tooltip for any existing ellipsis.
- Theme specificity, !important markers, responsive ordering, colors, blur and event/business logic remain unchanged. Default body and heading sizes remain untouched. Shared UI hierarchy still keeps main titles larger than labels/supporting text.
- Focused git diff --no-index --check reports no whitespace diagnostics for all 71 changed source/doc files (exit 1 means different snapshots). Reviewed non-font hunks as only intentional label-height/column/chart-space changes plus the status tooltip. Preserved original file-ending whitespace. Staged diff hash remains unchanged; new status entries are limited to intended typography files and task evidence.
- Updated the owning UI architecture fact; there are no path/module or boundary-ID ownership changes. Generated public outputs were not refreshed.
- User retained static-checks-only validation. No builds, tests, browser execution or resource/public asset regeneration were run. Actual rendering at narrow widths remains unverified; use the normal app/resource rebuild to publish the source changes.
