//
//  MoneyManager+History+PaymentRow.swift
//  
//
//  Created by Victor Cantu on 7/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.AuditView {

    class PaymentRow: Div {
        
        override class var name: String { "div" }
        
        let item: API.custAPIV1.PaymentToRender
        
        let relatedFolio: String
        
        let showControlers: Bool
        
        init(
            item: API.custAPIV1.PaymentToRender,
            relatedFolio: String,
            showControlers: Bool = true
        ) {
            self.item = item
            self.relatedFolio = relatedFolio
            self.showControlers = showControlers
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
            /// Date
            Div(getDate(self.item.createdAt).formatedShort)
                .class(.oneLineText)
                .width(120.px)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .class(.oneLineText)
                .width(120.px)
                .float(.left)
            /// Origin Order sale
            Div(self.relatedFolio)
                .class(.oneLineText)
                .width(120.px)
                .float(.left)
            /// Description
            Div("\(self.item.description) \(self.item.fiscCode.description) \(self.item.ref)  \(self.item.auth)")
                .custom("width", "calc(100% - 550px)")
                .class(.oneLineText)
                .float(.left)
            /// Cost
            Div(self.item.cost.formatMoney)
                .textAlign(.right)
                .width(120.px)
                .float(.left)
            
            if showControlers {
                
                Div{
                    
                    Img()
                        .src("/skyline/media/cross.png")
                        .marginLeft(7.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            addToDom(ConfirmView(
                                type: .aproveDeny,
                                title: "Confirme Accion",
                                message: "¿Seguro que desea eliminar pago \(self.item.folio) por: \(self.item.cost.formatMoney)?\n" +
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
                                            showError(.comunicationError, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            showError(.generalError, resp.msg)
                                            return
                                        }
                                     
                                        showSuccess(.operacionExitosa, "Pago eliminado")
                                        self.remove()
                                    }
                                }
                            })
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
                
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
                                    showError(.comunicationError, .serverConextionError)
                                    return
                                }
                                
                                guard resp.status == .ok else {
                                    showError(.generalError, resp.msg)
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
            
            Div().clear(.both).marginBottom(7.px)
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
