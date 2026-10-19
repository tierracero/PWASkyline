# Asset header search — 2026-10-09

## Scope and completion criteria

Complete the VTitle search TODO in Sources/App/Snippits/CustAssetsView/CustAssetsView.swift. Add a compact crystal input and magnifying-glass button; Enter and click use the same explicit submission function. Service-card input must use API.custOrderV1.getWarrantyCard(id: .code(term)), accept only payload.card.type == .asset, and open the asset item using the card's linked orderId. Reject other card types with a Spanish unsupported alert. Ordinary text opens AssetItemView(itemId: .folio(term)) as requested.

IDs: SWWEB-001, SWWEB-002, SWWEB-003, SEC-001. No API contract, dependency, routing, theme, or architecture-boundary changes. Preserve all existing user edits and asset department/category workflows.

## Reviewed implementation

- Own the input state and an isSearching state. Reuse UTextField, USmallButton, TCCrystalSurfaceClass.goodButton and the existing /skyline/media/zoom.png icon; supply button/input accessible labels.
- Trim surrounding input with purgeSpaces. Empty input does nothing. Detect formatted codes using the existing Work pattern (more than seven characters, a hyphen, and CustFolioSequenceTableType prefix); serviceCard and legacy qrCode use card lookup. Other input goes directly to .folio without unrelated broad search or automatic key-up timers.
- While a card lookup is in flight, disable this search field/button and guard repeated submission. Use a request UUID, weak self, isInDOM and the captured custCatchID to ignore removed-view or changed-session responses. Reset local request/busy state on completion/removal; no global loading overlay is needed for card lookup.
- Handle nil response, non-ok response and missing payload with existing showError patterns. Unsupported card types use showAlert; an asset card without orderId gets an inactive/unlinked-card error. Clear the input only after opening a supported asset item; failed/unsupported lookups retain it for correction.
- Invalidate pending search and clean up owned state listeners when the view is removed. Keep existing department requests unchanged.
- Update a verified architecture fact and completed task archive entry after audit. No commit or staging.

## Plan review

Reviewed the exact TODO and existing user diff, VTitle actions/control definitions, WorkViewControler.searchFolio/procesCodeCardAsset and the pinned GetWarrantyCardResponse/CustShortLinkManager contracts. Confirmed card.orderId is the optional asset item UUID for .asset; card.id identifies the card itself. The view is created afresh by AccountView. A single explicit search handler avoids the automatic/Enter double-load behavior fixed in Work. Review accepted before source mutation.

## Verification

Run source parsing and the previously user-approved focused App build with current pins and the existing module cache. Review source traces for plain/empty input, service/legacy QR cards, unsupported types, missing link, each API error, repeated submission, removal and session change. Review task-relative diff/whitespace, status/staging, dependency pin and before/after snapshots. No test suite, live browser/scanner run or server mutations.
