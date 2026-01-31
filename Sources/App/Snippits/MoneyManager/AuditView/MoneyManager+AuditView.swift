//
//  MoneyManager+HistoryView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView {
    
    class AuditView: Div {
        
        override class var name: String { "div" }
        
        /// Payments Recived
        @State var payment: [PaymentRow] = []
        
        var foliorefs: [UUID?: String] = [:]
        /// Money manager Orders
        @State var moneyManager: [MoneyManagerRow] = []
        
        /// Finacial
        /// tae, money, lending
        @State var financials: [FinancialRow] = []
        
        @DOM override var body: DOM.Content {
            //Select Code
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Revicion de Depositos y Cheques")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                /// Grid
                Div{
                    
                    /// payment
                    H1("Pagos Recibidos")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 💰 No hay pagos recibidos -")
                        .hidden(self.$payment.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Date
                        Div("Fecha")
                            .width(120.px)
                            .float(.left)
                        /// Folio
                        Div("Folio")
                            .width(120.px)
                            .float(.left)
                        /// Origin Order sale
                        Div("Ord/Vnta")
                            .width(120.px)
                            .float(.left)
                        /// Origin Order sale
                        Div("Descripcion")
                            .custom("width", "calc(100% - 550px)")
                            .float(.left)
                        
                        Div("Total")
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)

                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }.hidden(self.$payment.map{ $0.isEmpty })
                    ForEach(self.$payment) {
                        $0
                    }
                    
                    /// moneyManager
                    H1("Dinero Recibido")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 💵 No hay ordenes de pago -")
                        .hidden(self.$moneyManager.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Date
                        Div("Fecha")
                            .width(120.px)
                            .float(.left)
                        /// Folio
                        Div("Folio")
                            .width(120.px)
                            .float(.left)
                        /// bankDeposit, generalTransfer, safeBoxDeposit
                        Div("Tipo")
                            .width(180.px)
                            .float(.left)
                        
                        /// Origin Order sale
                        Div("Descripcion")
                            .custom("width", "calc(100% - 640px)")
                            .float(.left)
                        
                        Div("Total")
                            .width(120.px)
                            .float(.left)

                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }.hidden(self.$moneyManager.map{ $0.isEmpty })
                    ForEach(self.$moneyManager) {
                        $0
                    }
                    
                    /// financials
                    H1("Cortes Recibidos")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 📈 No hay cortes generados -")
                        .hidden(self.$financials.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Date
                        Div("Fecha")
                            .width(120.px)
                            .float(.left)
                        /// Folio
                        Div("Folio")
                            .width(120.px)
                            .float(.left)
                        /// bankDeposit, generalTransfer, safeBoxDeposit
                        Div("Tipo")
                            .width(170.px)
                            .float(.left)
                        /// Origin Order sale
                        Div("Descripcion")
                            .custom("width", "calc(100% - 550px)")
                            .float(.left)
                        
                        Div("Total")
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)
                        
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div("")
                            .width(30.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }.hidden(self.$financials.map{ $0.isEmpty })
                    ForEach(self.$financials) {
                        $0
                    }
                    
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
            }
            .custom("height", "calc(90% - 24px)")
            .custom("width", "calc(90% - 24px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(5.percent)
            .top(5.percent)
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
            
            loadingView(show: true)
            
            API.custAPIV1.viewDepositsConfirmation(id: nil) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.generalError, .serverConextionError)
                    self.remove()
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    self.remove()
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .payloadDecodError)
                    self.remove()
                    return
                }
                
                payload.foliorefs.forEach { ref in
                    self.foliorefs[ref.id] = ref.folio
                }
                
                self.payment = payload.payment.map{ PaymentRow(item:$0, relatedFolio: self.foliorefs[$0.custFolio] ?? "N/A") }
                
                self.moneyManager = payload.moneyManager.map{ MoneyManagerRow($0) }
                
                self.financials = payload.financials.map{ FinancialRow($0) }
                
            }
            
        }
    }
    
}
