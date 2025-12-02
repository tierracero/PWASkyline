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

        let consetionId: UUID
        
        let consetionName: String

        let bodega: CustStoreBodegasQuick

        var bodegas: [CustStoreBodegasQuick]
        
        var pocs: [CustPOCQuick]

        private var relinquishItems: ((
            _ items: CustPOCInventorySoldObject,
            _ alocatedTo: UUID?
        ) -> ())

        init(
            consetionId: UUID,
            consetionName: String,
            bodega: CustStoreBodegasQuick,
            bodegas: [CustStoreBodegasQuick],
            pocs: [CustPOCQuick],
            relinquishItems: @escaping ((
                _ items: CustPOCInventorySoldObject,
                _ alocatedTo: UUID?
            ) -> ())
        ) {
            self.consetionId = consetionId
            self.consetionName = consetionName
            self.bodega = bodega
            self.bodegas = bodegas
            self.pocs = pocs
            self.relinquishItems = relinquishItems
        }

        @State var bodegaName = ""

        required init() {
            fatalError("init() has not been implemented")
        }

        @State var items: [CustPOCInventorySoldObject] = []

        @DOM override var body: DOM.Content {

            Div{
                Img()
                .src( "/skyline/media/pencil.png" )
                .cursor(.pointer)
                .marginLeft(7.px)
                .height(18.px)
            }
            .float(.right)
            .onClick {

                loadingView(show: true)

                API.custAPIV1.getBodegaDetails(
                    bodegaId: self.bodega.id
                ) { resp in

                    loadingView(show: false)
        
                    guard let resp else {
                        showError(.errorDeCommunicacion, .serverConextionError)
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    guard let payload = resp.data else {
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }
                    
                    let view: ManageBodegaView = .init(
                        relationType: .consessioner(self.consetionId),
                        relationName: "Crear bodega para concesionario",
                        loadBy: .bodega(.init(
                            bodega: payload.bodega,
                            secciones: payload.sections
                        )),
                        onUpdate: { id, name, _ in
                            self.bodegaName = name
                        })
                    addToDom(view)
                }

            }
            
            Div{
                Div("Unidades")
                .marginBottom(7.px)
                .fontSize(12.px)
                .color(.gray)

                Div(self.$items.map{ $0.count.toString })
                .fontSize(28.px)
            }
            .marginRight(7.px)
            .float(.right)

            H2(self.$bodegaName)

        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.uibtnLarge)
            custom("width", "calc(100% - 14px)")
            onClick {
                let view = BodegaDetailView(
                    consetionId: self.consetionId,
                    consetionName: self.consetionName,
                    pocs: self.pocs,
                    items: self.items,
                    bodega: self.bodega,
                    bodegas: self.bodegas
                ) { items, to in

                }

                addToDom(view)

            }
            bodegaName = bodega.name
        }

        func takeInItems(items: [CustPOCInventorySoldObject]) {
            print("🟢 takeInItems")
            self.items.append(contentsOf: items)
        }

    }
}