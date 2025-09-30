//
//  MoneyManager+Audit+MoneyManagerPrintEngine.swift
//  
//
//  Created by Victor Cantu on 7/20/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.AuditView {
    
    class MoneyManagerPrintEngine: Div {
        
        override class var name: String { "div" }
        
        let item: CustMoneyManager
        
        /// NON Cash Payments Recived
        let validations: [PaymentRow]
        /// Cash Payments Recived
        let payment: [PaymentRow]
        /// Money manager Orders
        let moneyManager: [MoneyManagerRow]
        /// Finacial
        /// tae, money, lending
        let financials: [FinancialRow]
        
        let createdBy: String
        
        let targetUser: String
        
        init(
            item: CustMoneyManager,
            validations: [PaymentRow],
            payment: [PaymentRow],
            moneyManager: [MoneyManagerRow],
            financials: [FinancialRow],
            createdBy: String,
            targetUser: String
        ){
            self.item = item
            self.validations = validations
            self.payment = payment
            self.moneyManager = moneyManager
            self.financials = financials
            self.createdBy = createdBy
            self.targetUser = targetUser
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        var validationsBalance: Int64 = 0
        var paymentBalance: Int64 = 0
        var financialsBalance: Int64 = 0
        
        @DOM override var body: DOM.Content {
            /// Header
            Div {
                
                H3("\(self.item.type.description.uppercased()) [\(self.item.status.description)]")
                    .marginLeft(7.px)
                
            }
            
            Div().class(.clear)
            
            /// Main Data
            Div{
                Div{
                    
                    Div{
                        Strong(getDate(self.item.createdAt).formatedLong).color(.black)
                    }
                    .margin(all:3.px)
                    
                    Div{
                        
                        Div{
                            Label("Folio").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Creador").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Auditor").color(.gray)
                        }
                        .margin(all:3.px)
                    }
                    .class(.oneLineText)
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            Strong(self.item.folio).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.createdBy).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.targetUser).color(.black)
                        }
                        .margin(all:3.px)
                    }
                    .class(.oneLineText)
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                .width(25.percent)
                .float(.left)
                
                Div{
                    
                    Div{
                        
                        Div{
                            Label("# Val.")
                                .color(.gray)
                            Strong(self.item.validations.count.toString)
                                .marginLeft(7.px)
                                .color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("# Pag")
                                .color(.gray)
                            Strong(self.item.payments.count.toString)
                                .marginLeft(7.px)
                                .color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("# Fin")
                                .color(.gray)
                            Strong(self.item.financials.count.toString)
                                .marginLeft(7.px)
                                .color(.black)
                        }
                        .margin(all:3.px)
                        
                        
                        Div{
                            Label("# Man")
                                .color(.gray)
                            Strong(self.item.moneyManager.count.toString)
                                .marginLeft(7.px)
                                .color(.black)
                        }
                        .margin(all:3.px)
                        
                        
                    }
                    .class(.oneLineText)
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            Strong(self.item.validationsTotal.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.paymentsTotal.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.financialsTotal.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.moneyManagerTotal.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        
                    }
                    .class(.oneLineText)
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                }
                .width(25.percent)
                .float(.left)
                
                Div{
                    
                    Div{
                        
                        Div{
                            Label("Caja Antes").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Caja Despues").color(.gray).color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Faltante").color(.gray).color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("TOTAL").color(.gray).color(.yellowTC)
                        }
                        .margin(all:3.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            Strong(self.item.inBoxOld.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.inBoxNew.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                    
                        Div{
                            Strong(self.item.faltante.formatMoney).color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.total.formatMoney).color(.yellowTC)
                        }
                        .margin(all:3.px)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    Div().clear(.both)
                }
                .width(25.percent)
                .float(.left)
                
                Div{
                    
                    
                    Div{
                        
                        Div{
                            Label("Fecha Dep").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Dia Dep").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Folio Dep").color(.gray)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Label("Comentarios").color(.gray)
                        }
                        .margin(all:3.px)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        Div{
                            Strong("--").color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong("--").color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong("--").color(.black)
                        }
                        .margin(all:3.px)
                        
                        Div{
                            Strong(self.item.comments).color(.black)
                        }
                        .margin(all:3.px)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().class(.clear)
                    
                }
                .width(25.percent)
                .float(.left)
                
                Div().clear(.both)
                
            }
            .fontSize(14.px)
            
            Div().class(.clear)
            
            H3("Puntos, Tarjetas, Transferencias, Cheques y Condonacions")
                .hidden(self.validations.isEmpty)
                .marginBottom(7.px)
                .marginTop(12.px)
            Div{
                /// Date
                Div("Fecha")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Folio
                Div("Folio")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Origin Order sale
                Div("Ord/Vnta")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Origin Order sale
                Div("Descripcion")
                    .custom("width", "calc(100% - 500px)")
                    .float(.left)
                
                Div("Sub Total")
                    .textAlign(.center)
                    .width(120.px)
                    .float(.left)

                Div().clear(.both)
            }
            .hidden(self.validations.isEmpty)
            ForEach(self.validations) {
                $0.fontSize(14.px)
            }
            Div{
                /// Date
                Div("")
                    .width(120.px)
                    .float(.left)
                /// Folio
                Div("")
                    .width(120.px)
                    .float(.left)
                /// Origin Order sale
                Div("")
                    .width(120.px)
                    .float(.left)
                /// Origin Order sale
                Div{
                    Span("TOTAL")
                        .color(.yellowTC)
                        .marginRight(7.px)
                        
                }
                .custom("width", "calc(100% - 500px)")
                .float(.left)
                
                Div(self.validationsBalance.formatMoney)
                    .color(.yellowTC)
                    .width(120.px)
                    .float(.left)

                Div().clear(.both)
            }
            .hidden(self.validations.isEmpty)
            
            /// payment
            H3("Pagos Recibidos")
                .hidden(self.payment.isEmpty)
                .marginBottom(7.px)
                .marginTop(12.px)
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
                    .custom("width", "calc(100% - 500px)")
                    .float(.left)
                
                Div("Total")
                    .textAlign(.center)
                    .width(120.px)
                    .float(.left)

                Div().clear(.both)
            }
            .hidden(self.payment.isEmpty)
            ForEach(self.payment) {
                $0.fontSize(14.px)
            }
            Div{
                /// Date
                Div("")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Folio
                Div("")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Origin Order sale
                Div("")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Origin Order sale
                Div{
                    Span("TOTAL")
                        .color(.yellowTC)
                        .marginRight(7.px)
                        
                }
                .custom("width", "calc(100% - 500px)")
                .float(.left)
                
                Div(self.paymentBalance.formatMoney)
                    .color(.yellowTC)
                    .width(120.px)
                    .float(.left)

                Div().clear(.both)
            }
            .hidden(self.payment.isEmpty)
            .marginTop(3.px)
            
            /// moneyManager
            H3("Dinero Recibido")
                .hidden(self.moneyManager.isEmpty)
                .marginBottom(7.px)
                .marginTop(12.px)
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
                    .textAlign(.center)
                    .width(120.px)
                    .float(.left)

                Div().clear(.both)
            }
            .hidden(self.moneyManager.isEmpty)
            ForEach(self.moneyManager) {
                $0.fontSize(14.px)
            }
            
            /// financials
            H3("Cortes Recibidos / Servicios Financieros")
                .hidden(self.financials.isEmpty)
                .marginBottom(7.px)
                .marginTop(12.px)
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
                    .custom("width", "calc(100% - 600px)")
                    .float(.left)
                
                Div("Total")
                    .textAlign(.center)
                    .width(120.px)
                    .float(.left)
                
                Div().clear(.both)
            }
            .hidden(self.financials.isEmpty)
            ForEach(self.financials) {
                $0.fontSize(14.px)
            }
            Div{
                /// Date
                Div("")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// Folio
                Div("")
                    .width(120.px)
                    .height(35.px)
                    .float(.left)
                /// bankDeposit, generalTransfer, safeBoxDeposit
                Div("")
                    .width(170.px)
                    .height(35.px)
                    .float(.left)
                /// Origin Order sale
                Div("Total")
                    .custom("width", "calc(100% - 600px)")
                    .textAlign(.right)
                    .float(.left)
                
                Div(self.financialsBalance.formatMoney)
                    .textAlign(.center)
                    .width(120.px)
                    .float(.left)
                
                Div().clear(.both)
            }
            .hidden(self.financials.isEmpty)
                
        }
            
        override func buildUI() {
            super.buildUI()
            
            validationsBalance = validations.map{ $0.item.cost }.reduce(0, +)
            
            paymentBalance = payment.map{ $0.item.cost }.reduce(0, +)
            
            financialsBalance = financials.map{ $0.item.balance }.reduce(0, +)
               
            /*
            API.custAPIV1.getMoneyManager(id: .id(self.item.id)) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
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
                
                payload.foliorefs.forEach { ref in
                    self.foliorefs[ref.id] = ref.folio
                }
                
                self.validations = payload.validations.map{ PaymentRow(item:$0, relatedFolio: self.foliorefs[$0.custFolio] ?? "N/A", showControlers: false) }
                
                self.validationsBalance = payload.validations.map{ $0.cost }.reduce(0, +)
                
                self.payment = payload.payment.map{ PaymentRow(item:$0, relatedFolio: self.foliorefs[$0.custFolio] ?? "N/A", showControlers: false) }
             
                self.paymentBalance = payload.payment.map{ $0.cost }.reduce(0, +)
                
                self.moneyManager = payload.moneyManager.map{ MoneyManagerRow($0, false) }
                
                self.financials = payload.financials.map{ FinancialRow($0, false) }
                
            }
             */
        }
        
        
        
    }
    
    
}
