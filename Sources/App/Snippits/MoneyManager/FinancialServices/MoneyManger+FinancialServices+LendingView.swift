//
//  MoneyManger+FinancialServices+LendingView.swift
//  
//
//  Created by Victor Cantu on 7/31/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.FinancialServicesView {
    
    class LendingView: Div {
        
        override class var name: String { "div" }
        
        @State var user: CustUsername? = nil
        
        @State var financialTitle: String = "Prestamo Personal"
        
        @State var amount: String = "0"
        
        lazy var amountField = InputText(self.$amount)
            .placeholder("Cantidad a otorgar/reportar")
            .class(.textFiledBlackDark)
            .marginBottom(12.px)
            .width(93.percent)
            .textAlign(.right)
            .height(36.px)
            .onKeyDown({ tf, event in
                
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
                
            })
            .onFocus { tf in
                tf.select()
            }
        
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.subView)
                            .onClick {
                                self.remove()
                            }
                        
                        H2("Prestamo Personal")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    /// No target select view
                    Div{
                        Table{
                            Tr{
                                Td{
                                    Span("🐼 Seleccione Usuario")
                                    if custCatchHerk > 1 {
                                        Div("Seleccione Usuario").class(.uibtnLargeOrange)
                                            .onClick {
                                                
                                                var type = SelectCustUsernameView.LoadType.store(custCatchStore)
                                                
                                                if custCatchHerk > 3 {
                                                    type = .all
                                                }
                                                
                                                addToDom(SelectCustUsernameView(
                                                    type: type,
                                                    ignore: [],
                                                    callback: { user in
                                                        self.user = user
                                                        self.amountField.select()
                                                    }
                                                ))
                                            }
                                    }
                                }
                                .verticalAlign(.middle)
                                .align(.center)
                            }
                        }
                        .height(100.percent)
                        .width(100.percent)
                    }
                    .hidden(self.$user.map{ $0 != nil })
                    .height(400.px)
                    
                    /// Finicial data view
                    Div{
                        /// Select User
                        Div("Usuario a Otorgar")
                            .marginBottom(3.px)
                            .color(.lightGray)
                        
                        Div(self.$user.map{ $0?.username ?? "" })
                            .marginBottom(12.px)
                            .fontSize(24.px)
                            .color(.white)
                        
                        Div().clear(.both)
                        
                        Div{
                            /// Amount
                            Div("Cantidad del Prestamo")
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.amountField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both).marginBottom(7.px)
                        
                        Div{
                            Div("Motivo o nombre")
                                .marginBottom(3.px)
                                .color(.lightGray)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.amountField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                        
                        Div{
                            
                            Div("Otorgar Prestamo")
                                .class(.uibtnLargeOrange)
                                .marginBottom(7.px)
                                .onClick {
                                    self.createReport()
                                }
                            
                        }
                        .align(.center)
                        
                    }
                    .hidden(self.$user.map{ $0 == nil })
                    
                }
                .padding(all: 12.px)
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .width(35.percent)
            .left(30.percent)
            .top(20.percent)
            .color(.white)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            var type = SelectCustUsernameView.LoadType.store(custCatchStore)
            
            if custCatchHerk > 3 {
                type = .all
            }
            
            addToDom(SelectCustUsernameView(
                type: type,
                ignore: [],
                callback: { user in
                    self.user = user
                    self.amountField.select()
                }
            ))
        }
        
        func createReport(){
            
            guard let user else {
                showError(.generalError, "Seleccione usuario.")
                return
            }
            
            guard let amount = Double(self.amount)?.toCents else {
                showError(.generalError, "Ingrese una Cantidad valida.")
                amountField.select()
                return
            }
            
            if financialTitle.isEmpty {
                showError(.generalError, "Ingrese descripción del evento.")
                amountField.select()
                return
            }
    
            loadingView(show: true)
            
            API.custAPIV1.createFinancialService(
                type: .lending,
                targetUser: user.id,
                amount: amount,
                description: financialTitle,
                vendorid: nil,
                vendorName: nil,
                reciptType: nil,
                reciptId: nil,
                reciptFolio: nil,
                reciptImage: nil
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else{
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, .unexpenctedMissingPayload)
                    return
                }
                
                let printBody = CustUserFinacialServicesPrintEngine(
                    item: payload,
                    createdBy: custCatchUser,
                    targetUser: user.username,
                    vendor: nil
                ).innerHTML
                
                _ = JSObject.global.renderGeneralPrint!(custCatchUrl, payload.folio, printBody)
                
                self.remove()
               
           }
        }
    }
}
