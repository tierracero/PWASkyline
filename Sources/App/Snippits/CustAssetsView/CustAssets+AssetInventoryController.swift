//
// CustAssets+AssetInventoryController.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

/// Presentation-only categories for the currently loaded asset units.
enum AssetInventoryFilter: String, CaseIterable {
    case all
    case available
    case inTrip
    case inOrder
    case toMerm
    case inSubaccount

    var title: String {
        switch self {
        case .all: return "Todos"
        case .available: return "Activos y disponibles"
        case .inTrip: return "En viaje"
        case .inOrder: return "En orden"
        case .toMerm: return "A merma"
        case .inSubaccount: return "En subcuenta"
        }
    }

    func matches(
        status: CustCommercialAssetsItemStatus,
        isInSubaccount: Bool,
        serviceTrip: UUID?,
        serviceOrder: UUID?
    ) -> Bool {
        if self == .all { return true }
        if serviceTrip != nil { return self == .inTrip }
        if serviceOrder != nil { return self == .inOrder }
        if status == .tomerm { return self == .toMerm }
        if isInSubaccount { return self == .inSubaccount }
        return self == .available && status == .active
    }

    func matches(_ item: CustAssetsComponents.AssetsItemPayload) -> Bool {
        let isInSubaccount: Bool
        if case .subaccount = item.location {
            isInSubaccount = true
        } else {
            isInSubaccount = false
        }
        return matches(
            status: item.status,
            isInSubaccount: isInSubaccount,
            serviceTrip: item.serviceTrip,
            serviceOrder: item.serviceOrder
        )
    }
}

extension CustAssetsView {

    final class AssetInventoryController: Div {

        override class var name: String { "div" }

        let items: State<[CustAssetsComponents.AssetsItemPayload]>

        private let searchTerm: State<String>

        private let filter: State<String>

        private var renderId = UUID()

        private lazy var list = Div()
            .id(.init("cust_asset_grid_\(callKey(7))"))
            .custom("height", "calc(100% - 7px)")
            .custom("gap", "8px")
            .display(.block)

        init(
            items: State<[CustAssetsComponents.AssetsItemPayload]>,
            searchTerm: State<String> = State(wrappedValue: ""),
            filter: State<String> = State(wrappedValue: AssetInventoryFilter.all.rawValue)
        ) {
            self.items = items
            self.searchTerm = searchTerm
            self.filter = filter
            super.init()

            items.listen { [weak self] _ in
                self?.scheduleRender(after: 0.01)
            }
            searchTerm.listen { [weak self] _ in
                self?.scheduleRender(after: 0.2)
            }
            filter.listen { [weak self] _ in
                self?.scheduleRender(after: 0.01)
            }
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            inventoryContent()
        }

        private func inventoryContent() -> Div {
            Div {
                Div{
                    self.list
                }
                .margin(all: 3.px)
            }
            .class(.roundDarkBlue)
            .height(100.percent)
            .overflow(.auto)
            
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            if list.superview == nil {
                innerHTML = ""
                appendChild(inventoryContent())
            }
            scheduleRender(after: 0.01)
        }

        private func scheduleRender(after delay: Double) {
            renderId = UUID()
            let scheduledId = renderId
            guard isInDOM else { return }

            Dispatch.asyncAfter(delay) { [weak self] in
                guard let self, self.isInDOM, self.renderId == scheduledId else { return }
                self.renderRows(renderId: scheduledId)
            }
        }

        private func renderRows(renderId: UUID) {
            list.innerHTML = ""
            let allItems = items.wrappedValue
            let query = searchTerm.wrappedValue.purgeSpaces.pseudo
            let selectedFilter = AssetInventoryFilter(rawValue: filter.wrappedValue) ?? .all
            let matches = allItems.filter {
                selectedFilter.matches($0) && (query.isEmpty || [$0.folio, ($0.serial ?? ""), $0.name]
                    .joined(separator: " ").pseudo.contains(query))
            }

            guard !matches.isEmpty else {
                list.appendChild(emptyState(allItems.isEmpty
                    ? "No hay unidades registradas para este activo."
                    : "No hay unidades que coincidan con los filtros.")
                    .custom("height", "calc(100% - 45px)"))
                return
            }

            appendRow(matches, index: 0, renderId: renderId)
        }

        private func appendRow(
            _ rows: [CustAssetsComponents.AssetsItemPayload],
            index: Int,
            renderId: UUID
        ) {
            guard isInDOM, self.renderId == renderId, rows.indices.contains(index) else { return }

            Dispatch.asyncAfter(index == 0 ? 0.01 : 0.03) { [weak self] in
                guard let self, self.isInDOM, self.renderId == renderId else { return }
                self.list.appendChild(AssetInventoryItemController(item: rows[index]))
                self.appendRow(rows, index: index + 1, renderId: renderId)
            }
        }

        override func didRemoveFromDOM() {
            renderId = UUID()
            super.didRemoveFromDOM()
        }

        func addItems(_ newItems: [CustAssetsComponents.AssetsItemPayload]) {
            guard !newItems.isEmpty else { return }
            items.wrappedValue.append(contentsOf: newItems)
        }

    }
}
