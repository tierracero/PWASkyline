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

        private var callback: (
            _ folio: String,
            _ units: Int
        ) -> Void

        init(
            viewType: InitiateAssetItemViewType,
            callback: @escaping (
                _ folio: String,
                _ units: Int
            ) -> Void
        ) {
            self.viewType = viewType
            self.callback = callback
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var folio: String  = ""

        @State var units: String  = ""

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
                        H3("Folio de Ingreo")
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

                        Div()

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

            folioField.select()

        }

        func save() {

            guard let units = Int(units), units > 0  else {
                showError(.generalError, "Ingrese numero de unidades valido")
                return
            }

            callback(folio, units)

            self.remove()
            
        }
    }

}

