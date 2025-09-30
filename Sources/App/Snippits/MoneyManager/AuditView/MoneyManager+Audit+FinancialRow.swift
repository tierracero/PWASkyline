//
//  MoneyManager+History+FinancialRow.swift
//  
//
//  Created by Victor Cantu on 7/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.AuditView {
    
    class FinancialRow: Div {
        
        override class var name: String { "div" }
        
        let item: API.custAPIV1.FinancialsRender
        
        let showControlers: Bool
        
        init(
            _ item: API.custAPIV1.FinancialsRender,
            _ showControlers: Bool = true
        ) {
            self.item = item
            self.showControlers = showControlers
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
            /// Date
            Div(getDate(self.item.self.createdAt).formatedShort)
                .width(120.px)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .minHeight(35.px)
                .width(120.px)
                .float(.left)
            /// bankDeposit, generalTransfer, safeBoxDeposit
            Div(self.item.type.description)
                .width(170.px)
                .float(.left)
            /// Origin Order sale
            Div(self.item.comments)
                .custom("width", "calc(100% - 550px)")
                .minHeight(35.px)
                .float(.left)
            /// Cost
            Div(self.item.balance.formatMoney)
                .textAlign(.right)
                .width(120.px)
                .float(.left)
            
            if showControlers {
                
                /// maximizeWindow
                Div{
                    
                    Img()
                        .src("/skyline/media/maximizeWindow.png")
                        .class(.iconWhite)
                        .marginLeft(7.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            
                            loadingView(show: true)
                            
                            API.custAPIV1.getFianancialService(id: .id(self.item.id)) { resp in
                                
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
                                    showError(.errorDeCommunicacion, .unexpenctedMissingPayload)
                                    return
                                }
                                
                                addToDom(MoneyManagerView.FinancialServicesView.DetailView(
                                    financial: payload.financial,
                                    notes: payload.notes,
                                    vendor: payload.vendor,
                                    updated: { }
                                ))
                                
                            }
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
                
                /// cross
                Div{
                    Img()
                        .src("/skyline/media/cross.png")
                        .marginLeft(7.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            /*
                            addToDom(ConfirmView(
                                type: .aproveDeny,
                                title: "Confirme Accion",
                                message: "¿Seguro que desea eliminar pago \(self.item.folio) por: \(self.item.total.formatMoney)?\n" +
                                "Se generara un contra cargo al usuario",
                                requiersComment: true
                            ){ auth, reason in
                                if auth {
                                    
                                    loadingView(show: true)
                                    
                                    API.custAPIV1.paymentRejection(
                                        id: self.item.id,
                                        reason: reason
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
                                     
                                        showSuccess(.operacionExitosa, "Pago eliminado")
                                        self.remove()
                                    }
                                }
                            })
                             */
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
                
                /// checkmark
                Div{
                    Img()
                        .src("/skyline/media/checkmark.png")
                        .marginLeft(7.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            
                            loadingView(show: true)
                            
                            API.custAPIV1.paymentApproval(
                                id: self.item.id
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
                             
                                showSuccess(.operacionExitosa, "Pago Archivado")
                                self.remove()
                            }
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
            }
            
            
            Div().clear(.both)
        }
        
        override func buildUI() {
            super.buildUI()
            marginTop(3.px)
            
        }
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
    }
}
