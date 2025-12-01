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

        init(
            consetionId: UUID,
            consetionName: String,
            bodega: CustStoreBodegasQuick
        ) {
            self.consetionId = consetionId
            self.consetionName = consetionName
            self.bodega = bodega
        }

        @State var bodegaName = ""

        required init() {
            fatalError("init() has not been implemented")
        }

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
            
            H2(self.$bodegaName)

        }


        override func buildUI() {
            super.buildUI()
            self.class(.uibtnLarge)
            custom("width", "calc(100% - 14px)")

            bodegaName = bodega.name
        }

    }
}