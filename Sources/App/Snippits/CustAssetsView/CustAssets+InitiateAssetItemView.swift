//
// CustAssets+InitiateAssetItemView.swift
// 

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import SkylineDocumentationCore

extension CustAssetsView {

    final class InitiateAssetItemView: Div {

        override class var name: String { "div" }

        /// store, warehose, account, subAccount
        let viewType: InitiateAssetItemViewType

        private let availableStores: [CustStore]

        @State private var selectedStoreId = ""

        private var callback: (
            _ folio: String,
            _ units: Int,
            _ registrationType: InitiateAssetItemViewType
        ) -> Void

        init(
            viewType: InitiateAssetItemViewType,
            callback: @escaping (
                _ folio: String,
                _ units: Int,
                _ registrationType: InitiateAssetItemViewType
            ) -> Void
        ) {
            self.viewType = viewType
            self.callback = callback

            let baseStore = viewType.registrationStore
            var choices = Array(stores.values)
            if !choices.contains(where: { $0.id == baseStore.id }) {
                choices.append(baseStore)
            }
            self.availableStores = choices.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            self.selectedStoreId = baseStore.id.uuidString
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var folio: String  = ""

        @State var units: String  = ""

        private lazy var storeSelect = USelectField(self.$selectedStoreId)
            .attribute("aria-label", "Tienda de registro")
            .width(100.percent)

        lazy var folioField = UTextField(self.$folio)
            .placeholder("Folio de la compra")
            .onEnter {
                self.unitsField.select()
            }

        lazy var unitsField = UTextField(self.$units)
            .placeholder("10")
            .onEnter {
                self.save()
            }

        @DOM override var body: DOM.Content {
            
            VPopUp(.fitContent(w: 500)) {
                
                VTitle("Ingresar unidad ", icon: "commertial_assets_icon.png") {
                    USmallTitle(self.viewType.description)
                } onClose: {
                    self.remove()
                }

                VBodyGrid {

                    VGrid(.half) {
                        H3("Tipo de Ingreso")
                    }

                    VGrid(.half) {
                        H3(self.viewType.description)
                    }

                    VGrid(.half) {
                        H3("Relacion")
                    }
                    VGrid(.half) {
                        H3(self.viewType.relationName)
                        .class(.twoLineText)
                    }

                    // MARK: Folio de adquisision / Number of units 
                    VGrid(.oneForth) {
                        H3("Folio de Ingres")
                    }

                    VGrid(.oneForth) {
                        self.folioField
                    }

                    VGrid(.oneForth) {
                        H3("Unidades a Ingresar")
                    }

                    VGrid(.oneForth) {
                        self.unitsField
                    }


                    VGrid(.full) {
                        UField("Tienda de registro") {
                            self.storeSelect
                        }
                    }

                    VGrid(.full) {

                        ULargeButton("Ingresar")
                            .class(Class(TCCrystalSurfaceClass.goodButton))
                            .width(150.px)
                            .onClick { self.save() }

                    }
                    .custom("justify-content","flex-end")
                    .display(.flex)
                }
            }
        }
        
        override func buildUI() {
            super.buildUI()
            TCCrystalSurfaceTheme.apply(to: self, variant: .assets)
            position(.absolute)
            width(100.percent)
            height(100.percent)
            left(0.px)
            top(0.px)
        }

        override func didAddToDOM() {
            super.didAddToDOM()

            storeSelect.innerHTML = ""
            storeSelect.appendChild(
                Option("Seleccione tienda").value("").selected(selectedStoreId.isEmpty)
            )
            availableStores.forEach { store in
                storeSelect.appendChild(
                    Option(store.name)
                        .value(store.id.uuidString)
                        .selected(store.id.uuidString == selectedStoreId)
                )
            }

            folioField.select()

        }

        func save() {
            guard isInDOM else { return }

            guard let units = Int(units), units > 0  else {
                showError(.generalError, "Ingrese numero de unidades valido")
                return
            }

            guard let store = availableStores.first(where: { $0.id.uuidString == selectedStoreId }) else {
                showError(.requiredField, .requierdValid("Tienda"))
                return
            }

            Console.clear()

            print("Selected Store")

            print(store)

            guard let lat = store.lat, let lon = store.lon,
                  Double(lat) != nil, Double(lon) != nil else {
                showError(.unexpectedResult, "La tienda \(store.name.capitalized) requiere cargar mapa")
                return
            }

            callback(folio, units, viewType.registering(in: store))

            self.remove()
            
        }

        override func didRemoveFromDOM() {
            $folio.removeAllListeners()
            $units.removeAllListeners()
            $selectedStoreId.removeAllListeners()
            super.didRemoveFromDOM()
        }
    }

}

extension CustAssetsComponents.InitiateAssetItemViewType {

    var registrationStore: CustStore {
        switch self {
        case .store(let store), .warehose(let store):
            return store
        case .account(_, let store), .subAccount(_, let store):
            return store
        }
    }

    func registering(in store: CustStore) -> Self {
        switch self {
        case .store:
            return .store(store)
        case .warehose:
            return .warehose(store)
        case .account(let account, _):
            return .account(account: account, store: store)
        case .subAccount(let subAccount, _):
            return .subAccount(subAccount: subAccount, store: store)
        }
    }
}
