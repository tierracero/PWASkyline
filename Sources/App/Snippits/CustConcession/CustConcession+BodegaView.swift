//
//  CustConcession+BodegaView.swift
//
//
//  Created by Victor Cantu on 7/11/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension CustConcessionView {
    
    class BodegaView: Div {
        
        override class var name: String { "div" }

        let storeId: UUID
        
        let storeName: String

        let bodega: CustStoreBodegasQuick

        @State var seccions: [CustStoreSeccionesQuickRef]

        init(
            storeId: UUID,
            storeName: String,
            bodega: CustStoreBodegasQuick,
            seccions: [CustStoreSeccionesQuickRef]
        ) {
            self.storeId = storeId
            self.storeName = storeName
            self.bodega = bodega
            self.seccions = seccions
        }

        required init() {
            fatalError("init() has not been implemented")
        }

        @DOM override var body: DOM.Content {
            Div("+Agregar Seccion")
            .class(.uibtnLarge)
            .float(.right)
            .onClick {
                let view = CreateSectionView(
                    storeid: self.storeId,
                    storeName: self.storeName,
                    bodid: self.bodega.id,
                    bodName: self.bodega.name,
                    sectionName: ""
                ) { section in
                    self.seccions.append(.init(
                        id: section.id,
                        name: section.name,
                        custStoreBodegas: self.bodega.id
                    ))
                }

                addToDom(view)
            }
            H2(self.bodega.name)
            
            Div{
                ForEach(self.$seccions) { item in

                    Div(item.name)

                    Div().clear(.both).height(7.px)

                }
            }
        }


        override func buildUI() {
            super.buildUI()
            self.class(.uibtnLarge)
            custom("width", "calc(100% - 14px)")
        }

    }
}