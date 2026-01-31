//
//  MoneyManager+Audit+MoneyManagerView.swift
//  
//
//  Created by Victor Cantu on 7/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.AuditView {
    
    class MoneyManagerSubView: Div {
        
        override class var name: String { "div" }
        
        let item: CustMoneyManager
        
        let autoPrint: Bool
        
        private var removeView: ((
        ) -> ())
        
        init(
            _ item: CustMoneyManager,
            _ autoPrint: Bool,
            _ removeView: @escaping ((
            ) -> ())
        ) {
            self.item = item
            self.autoPrint = autoPrint
            self.removeView = removeView
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        /// NON Cash Payments Recived
        @State var validations: [PaymentRow] = []
        @State var validationsBalance: Int64 = 0
        
        /// Cash Payments Recived
        @State var payment: [PaymentRow] = []
        @State var paymentBalance: Int64 = 0
        
        var foliorefs: [UUID?: String] = [:]
        /// Money manager Orders
        @State var moneyManager: [MoneyManagerRow] = []
        
        /// Finacial
        /// tae, money, lending
        @State var financials: [FinancialRow] = []
        @State var financialsBalance: Int64 = 0
        
        @State var createdBy = ""
        
        @State var targetUser = ""
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Ver Money Manager: ")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    H2("\(self.item.type.description.uppercased()) [\(self.item.status.description)]")
                        .color(.darkOrange)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    
                    
                    Div().class(.clear)
                    
                }
                
                /// Grid
                Div{
                    
                    Div{
                        
                        Div{
                            Div{
                                Label("Fecha").color(.gray)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Label("Folio").color(.gray)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Label("Creado Por").color(.gray)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Label("Usuario Auditado").color(.gray)
                            }
                            .margin(all:3.px)
                        }
                        .class(.oneLineText)
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div{
                                Strong(getDate(self.item.createdAt).formatedLong).color(.white)
                            }
                            .margin(all:3.px)
                            Div{
                                Strong(self.item.folio).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.$createdBy).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.$targetUser).color(.white)
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
                                Label("# Validaciones")
                                    .color(.gray)
                                Strong(self.item.validations.count.toString)
                                    .marginLeft(7.px)
                                    .color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Label("# Pagos")
                                    .color(.gray)
                                Strong(self.item.payments.count.toString)
                                    .marginLeft(7.px)
                                    .color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Label("# Finansaz")
                                    .color(.gray)
                                Strong(self.item.financials.count.toString)
                                    .marginLeft(7.px)
                                    .color(.white)
                            }
                            .margin(all:3.px)
                            
                            
                            Div{
                                Label("# Managers")
                                    .color(.gray)
                                Strong(self.item.moneyManager.count.toString)
                                    .marginLeft(7.px)
                                    .color(.white)
                            }
                            .margin(all:3.px)
                            
                            
                        }
                        .class(.oneLineText)
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            
                            Div{
                                Strong(self.item.validationsTotal.formatMoney).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.item.paymentsTotal.formatMoney).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.item.financialsTotal.formatMoney).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.item.moneyManagerTotal.formatMoney).color(.white)
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
                                Strong(self.item.inBoxOld.formatMoney).color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.item.inBoxNew.formatMoney).color(.white)
                            }
                            .margin(all:3.px)
                        
                            Div{
                                Strong(self.item.faltante.formatMoney).color(.white)
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
                    
                    /*
                     Deposit  detail
                     */
                    
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
                                Strong("--").color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong("--").color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong("--").color(.white)
                            }
                            .margin(all:3.px)
                            
                            Div{
                                Strong(self.item.comments).color(.white)
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
                    
                    H1("Puntos, Tarjetas, Transferencias, Cheques y Condonacions")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 💰 No hay elementos que procesar -")
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
                            .custom("width", "calc(100% - 500px)")
                            .float(.left)
                        
                        Div("Sub Total")
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)

                        Div().clear(.both)
                    }.hidden(self.$validations.map{ $0.isEmpty })
                    ForEach(self.$validations) {
                        $0
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
                        .textAlign(.right)
                        .float(.left)
                        
                        Div(self.$validationsBalance.map{ $0.formatMoney })
                            .color(.yellowTC)
                            .width(120.px)
                            .float(.left)

                        Div().clear(.both)
                    }.hidden(self.$validations.map{ $0.isEmpty })
                    
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
                            .custom("width", "calc(100% - 500px)")
                            .float(.left)
                        
                        Div("Total")
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)

                        Div().clear(.both)
                    }.hidden(self.$payment.map{ $0.isEmpty })
                    ForEach(self.$payment) {
                        $0
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
                        .textAlign(.right)
                        .float(.left)
                        
                        Div(self.$paymentBalance.map{ $0.formatMoney })
                            .color(.yellowTC)
                            .width(120.px)
                            .float(.left)

                        Div().clear(.both)
                    }
                    .hidden(self.$payment.map{ $0.isEmpty })
                    .marginTop(3.px)
                    
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
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)

                        Div().clear(.both)
                    }.hidden(self.$moneyManager.map{ $0.isEmpty })
                    ForEach(self.$moneyManager) {
                        $0
                    }
                    
                    /// financials
                    H1("Cortes Recibidos / Servicios Financieros")
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
                            .custom("width", "calc(100% - 600px)")
                            .float(.left)
                        
                        Div("Total")
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }.hidden(self.$financials.map{ $0.isEmpty })
                    ForEach(self.$financials) {
                        $0
                    }
                    Div{
                        /// Date
                        Div("")
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        /// Folio
                        Div("")
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        /// bankDeposit, generalTransfer, safeBoxDeposit
                        Div("")
                            .height(35.px)
                            .width(170.px)
                            .float(.left)
                        /// Origin Order sale
                        Div("Total")
                            .custom("width", "calc(100% - 600px)")
                            .textAlign(.center)
                            .float(.left)
                        
                        Div(self.$financialsBalance.map{ $0.formatMoney })
                            .textAlign(.center)
                            .width(120.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }.hidden(self.$financials.map{ $0.isEmpty })
                    
                }
                .custom("height", "calc(100% - 70px)")
                .overflow(.auto)
                
                Div{
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/icon_print.png")
                            .class(.iconWhite)
                            .marginLeft(7.px)
                            .cursor(.pointer)
                            .height(18.px)
                        
                        Span("Imprimir")
                            .marginLeft(7.px)
                        
                    }
                    .class(.uibtnLarge)
                    .float(.left)
                    .onClick {
                        self.printDocument()
                    }
                    
                    /// TODO Make that  only specified user can  di this action
                    if custCatchHerk > 4 {
                        
                        Div{
                            
                            Img()
                                .src("/skyline/media/checkmark.png")
                                .marginLeft(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            
                            Span("Aprobar")
                                .marginLeft(7.px)
                            
                        }
                        .class(.uibtnLarge)
                        .float(.right)
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
                             
                                showSuccess(.operacionExitosa, "Evento Archivado")
                                
                                self.removeView()
                                self.remove()
                            }
                        }
                    
                        Div{
                            Img()
                                .src("/skyline/media/cross.png")
                                .marginLeft(7.px)
                                .cursor(.pointer)
                                .height(18.px)
                            
                            Span("Rechazar")
                                .marginLeft(7.px)
                            
                        }
                        .class(.uibtnLarge)
                        .float(.right)
                        
                    }
                    
                }
                
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
            
            getUserRefrence(id: .id(self.item.createdBy)) { user in
                guard let user else {
                    self.createdBy = "Usuario no encontrado"
                    return
                }
                self.createdBy = user.username.explode("@").first ?? ""
            }
            
            getUserRefrence(id: .id(self.item.targetUser)) { user in
                guard let user else {
                    self.targetUser = "Usuario no encontrado"
                    return
                }
                self.targetUser = user.username.explode("@").first ?? ""
            }
            
            loadingView(show: true)
            
            API.custAPIV1.getMoneyManager(id: .id(self.item.id)) { resp in
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
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
             
                self.financialsBalance = payload.financials.map{ $0.balance }.reduce(0, +)
                
                if self.autoPrint {
                    self.printDocument()
                }
                
            }
        }
        
        func printDocument(){
            
            let printBody = MoneyManagerPrintEngine(
                item: item,
                validations: validations.map{ .init(item: $0.item, relatedFolio: $0.relatedFolio, showControlers: false) },
                payment: payment.map{ .init(item: $0.item, relatedFolio: $0.relatedFolio, showControlers: false) },
                moneyManager: moneyManager.map{ .init($0.item, $0.showControlers) },
                financials: financials.map{ .init($0.item, $0.showControlers) },
                createdBy: createdBy,
                targetUser: targetUser
            ).innerHTML
            
            _ = JSObject.global.renderGeneralPrint!(custCatchUrl, self.item.folio, printBody)
            
        }
    }
}
