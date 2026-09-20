//
// CustAssets+AssetInventoryController.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class AssetInventoryController: Div {

        override class var name: String { "div" }

        private let items: [CustCommercialAssetsItem]
        private let onSelect: (CustCommercialAssetsItem) -> Void
        private lazy var list = Div()
            .id(.init("cust_asset_grid_\(callKey(7))"))
            .custom("gap", "8px")
            .height(100.percent)
            .display(.grid)

        init(
            items: [CustCommercialAssetsItem],
            onSelect: @escaping (CustCommercialAssetsItem) -> Void = { _ in }
        ) {
            self.items = items
            self.onSelect = onSelect
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            self.list
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            
            render()
        }

        private func render() {
            list.innerHTML = ""

            guard !items.isEmpty else {
                list.appendChild(emptyState("No hay unidades registradas para este activo.").custom("height", "calc(100% - 35px)"))
                return
            }

            items.forEach { item in
                list.appendChild(
                    VBox(.raised) {
                        Div {
                            Div {
                                USubTitle(item.name).class(.oneLineText)
                                UMinorTitle(item.serial ?? "Sin número de serie")
                                    .class(.oneLineText)
                                    .marginTop(2.px)
                            }

                            Div {
                                Div(item.currentCost.formatMoney)
                                    .fontWeight(.bold)
                                UMinorTitle(item.status.rawValue.capitalized)
                            }
                            .textAlign(.right)
                        }
                        .display(.flex)
                        .custom("align-items", "center")
                        .custom("justify-content", "space-between")
                        .custom("gap", "12px")

                        Div {
                            self.detail("Folio de compra", item.purchasFiscalDocumentFolio)
                            self.detail(
                                "Tarjeta de servicio",
                                item.serviceCard.isEmpty ? "—" : item.serviceCard.joined(separator: ", ")
                            )
                            self.detail("Costo de adquisición", item.acquisitionCost.formatMoney)
                            self.detail("Ubicación", item.currentLocation.description)
                        }
                        .display(.grid)
                        .custom("grid-template-columns", "repeat(auto-fit, minmax(170px, 1fr))")
                        .custom("gap", "8px")
                        .marginTop(10.px)
                    }
                    .cursor(.pointer)
                    .onClick {
                        self.onSelect(item)
                    }
                )
            }
        }

        private func detail(_ label: String, _ value: String) -> Div {
            Div {
                UMinorTitle(label)
                Div(value)
                    .class(.oneLineText)
                    .marginTop(2.px)
                    .attribute("title", value)
            }
            .padding(all: 8.px)
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("border-radius", "8px")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("min-width", "0")
        }
    }
}
