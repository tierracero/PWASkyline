//
//  MoneyManager+History+MoneyManagerRow.swift
//  
//
//  Created by Victor Cantu on 7/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.AuditView {
    
    class MoneyManagerRow: Div {
        
        override class var name: String { "div" }
        
        let item: CustMoneyManager
        
        let showControlers: Bool
        
        init(
            _ item: CustMoneyManager,
            _ showControlers: Bool = true
        ) {
            self.item = item
            self.showControlers = showControlers
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        var comment = ""
        
        @DOM override var body: DOM.Content {
            /// Date
            Div(getDate(self.item.self.createdAt).formatedShort)
                .width(120.px)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .width(120.px)
                .float(.left)
            /// bankDeposit, generalTransfer, safeBoxDeposit
            Div(self.item.type.description)
                .width(180.px)
                .float(.left)
            /// Origin Order sale
            Div(self.comment)
                .custom("width", "calc(100% - 650px)")
                .float(.left)
            /// Cost
            Div(self.item.total.formatMoney)
                .textAlign(.right)
                .width(120.px)
                .float(.left)
            
            if showControlers {
                
                Div{
                    
                    Img()
                        .src("/skyline/media/maximizeWindow.png")
                        .class(.iconWhite)
                        .marginLeft(7.px)
                        .cursor(.pointer)
                        .height(18.px)
                        .onClick {
                            addToDom( MoneyManagerSubView(self.item, false){
                                self.remove()
                            } )
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
                
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
                             
                                showSuccess(.operacionExitosa, "Evento Archivado")
                                
                                self.remove()
                            }
                        }
                }
                .align(.center)
                .width(30.px)
                .float(.left)
                
            }
            
            Div().clear(.both)
                .marginBottom(12.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            marginTop(3.px)
            
            if item.comments.isEmpty {
                comment = "- sin comentarios -"
            }
            else {
                comment = item.comments
            }
            
            getUserRefrence(id: .id(item.createdBy)) { user in
                
                guard let user else {
                    return
                }
                
                self.comment = (user.username.explode("@").first ?? "\(user.firstName) \(user.lastName)") + " " + self.item.comments
                
            }
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
        }
    }
}
