//
// CustAssets+AssetInventoryItemController.swift
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustAssetsView {

    final class AssetInventoryItemController: Div {

        override class var name: String { "div" }

        var item: CustAssetsComponents.AssetsItemPayload

        @State var name: String

        /// Primary image for this concrete commercial asset item.
        @State var avatar: String?

        /// store, warehouse, account, subaccount, user
        @State var location: CustAssetsComponents.GetAssetItemLocationType
        
        @State var department: CustAssetDeps?

        @State var categorie: CustAssetCats?

        /// Optional section classification for the concrete asset item.
        @State var section: CustCommercialAssetsSection?

        /// Optional subsection classification below the asset section.
        @State var subSection: CustCommercialAssetsSubSection?
        
        /// active, unavailable, inactive, merm, returned, transit, tomerm
        @State var status: CustCommercialAssetsItemStatus

        init(
            item: CustAssetsComponents.AssetsItemPayload
        ) {
            self.item = item
            self.name = item.name
            self.avatar = item.avatar
            self.location = item.location
            self.department = item.department
            self.categorie = item.categorie
            self.section = item.section
            self.subSection = item.subSection
            self.status = item.status
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
        
            VBox(.raised) {
                Div {
                    Div {

                        UTitle{
                            Span(self.item.folio)
                            .marginRight(7.px)
                            
                            Span(self.$name)
                        }
                        .class(.oneLineText)
                        .color(.white)
                    }

                    Div {
                        UTitle( self.$status.map{ $0.description.capitalized })
                        .color(.white)
                    }
                    .textAlign(.right)
                }
                .custom("justify-content", "space-between")
                .custom("align-items", "center")
                .custom("gap", "12px")
                .display(.flex)

                Div {
                    //
                    self.detail("Folio", self.item.folio)
                    
                    self.detail("Ubicación", self.$location.map{ $0.description })
                    
                    self.detail( self.$location.map{ "Nombre de \($0.description.capitalized)" }, self.$location.map{ $0.name })

                    self.detail("Seccion", self.$section.map { $0?.name ?? "" })

                    self.detail("Sub Seccion", self.$subSection.map { $0?.name ?? "" })

                }
                .custom("grid-template-columns", "repeat(auto-fit, minmax(170px, 1fr))")
                .custom("gap", "3px")
                .marginTop(10.px)
                .display(.grid)
            }
            .backgroundColor(.slateGray)
            .marginBottom(3.px)
            .cursor(.pointer)
            .onClick {
                self.load()
            }
            
        }

        override func didAddToDOM() {
            super.didAddToDOM()
            
        }

        private func detail(_ label: String, _ value: String) -> Div {
            Div {
                UMinorTitle(label)
                Div(value)
                    .attribute("title", value)
                    .class(.oneLineText)
                    .marginTop(2.px)
            }
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("border-radius", "8px")
            .custom("min-width", "0")
            .padding(all: 8.px)
        }

        private func detail(_ label: String, _ value: State<String>) -> Div {
            Div {
                UMinorTitle(label)
                Div(value)
                    .class(.oneLineText)
                    .marginTop(2.px)
                    .title(value)
            }
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("border-radius", "8px")
            .custom("min-width", "0")
            .padding(all: 8.px)
        }

        private func detail(_ label: State<String>, _ value: State<String>) -> Div {
            Div {
                UMinorTitle(label)
                Div(value)
                    .class(.oneLineText)
                    .marginTop(2.px)
                    .title(value)
            }
            .custom("border", "1px solid rgba(66, 183, 245, 0.18)")
            .custom("background", "rgba(5, 17, 27, 0.42)")
            .custom("border-radius", "8px")
            .custom("min-width", "0")
            .padding(all: 8.px)
        }

        private func load() {
            let view = AssetItemView(assetItemId: item.id) { _ in

            }
            addToDom(view)
        }

    }

}
