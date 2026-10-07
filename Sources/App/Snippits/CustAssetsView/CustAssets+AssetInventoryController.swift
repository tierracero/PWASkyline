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

        @State var items: State<[CustAssetsComponents.AssetsItemPayload]>

        private lazy var list = Div{

            emptyState("No hay unidades registradas para este activo.").custom("height", "calc(100% - 45px)")
            .hidden(self.items.map{ !$0.isEmpty })
            .display(self.items.map{ !$0.isEmpty ? .none : .block })

            ForEach(self.items)  { item in
                AssetInventoryItemController(item: item)
            }
            .hidden(self.items.map{ $0.isEmpty })
            .display(self.items.map{ $0.isEmpty ? .none : .block })

        }
            .id(.init("cust_asset_grid_\(callKey(7))"))
            .custom("height", "calc(100% - 7px)")
            .custom("gap", "8px")
            .display(.block)

        init(
            items: State<[CustAssetsComponents.AssetsItemPayload]>
        ) {
            self.items = items
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
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
            
        }

        func addItems(_ newItems: [CustAssetsComponents.AssetsItemPayload]) {
            guard !newItems.isEmpty else { return }
            items.wrappedValue.append(contentsOf: newItems)
        }

    }
}