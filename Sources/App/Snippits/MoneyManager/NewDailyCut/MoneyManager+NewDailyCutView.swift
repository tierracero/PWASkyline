//
//  MoneyManager+NewDailyCutView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView {
    
    class NewDailyCutView: Div {
        
        override class var name: String { "div" }
        
        /// bankDeposit, generalTransfer, safeBoxDeposit
        @State var type: MoneyManagerType
        
        let user: API.custAPIV1.UserList
        
        init(
            type: MoneyManagerType,
            user: API.custAPIV1.UserList
        ) {
            self.type = type
            self.user = user
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var storeid: UUID? = nil
        
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
        
        @State var storeBalance: Int64 = 0
        
        @State var validationCheckBox = true
        
        @State var paymentCheckBox = true
        
        @State var moneyManagerCheckBox = true
        
        @State var financialsCheckBox = true
        
        @State var total = ""
        
        /// If it has "caja chika"
        var hasStoreBalance: Bool = false
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Corte de Caja/Banco")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                /// Grid
                Div{
                    
                    Div{
                        
                        H1("Balance de la caja")
                            .marginBottom(7.px)
                            .marginTop(12.px)
                            .float(.left)
                        
                        H1(self.$storeBalance.map{ $0.formatMoney })
                            .marginBottom(7.px)
                            .marginTop(12.px)
                            .float(.right)
                        
                        Div().class(.clear)
                    }




                    /// validations
                    H1("Puntos, Tarjetas, Transferencias, Cheques y Condonacions")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 💰 No hay elementos que procesar -")
                        .hidden(self.$payment.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Toggle
                        Div{
                            InputCheckbox(self.$validationCheckBox)
                                .marginLeft(12.px)
                        }
                        .align(.left)
                        .width(80.px)
                        .float(.left)
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
                            .custom("width", "calc(100% - 560px)")
                            .float(.left)
                        /// Origin Order sale
                        Div("Costo")
                            .textAlign(.center)
                            .width(110.px)
                            .float(.left)
                        Div().clear(.both)
                    }.hidden(self.$validations.map{ $0.isEmpty })
                    Div{
                        ForEach(self.$validations) {
                            $0
                        }
                    }
                    Div{
                        Div()
                            .height(35.px)
                            .align(.left)
                            .width(80.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div{
                            Span("TOTAL")
                                .color(.yellowTC)
                                .marginRight(12.px)
                        }
                            .custom("width", "calc(100% - 560px)")
                            .textAlign(.right)
                            .float(.left)
                        
                        Div(self.$validationsBalance.map{$0.formatMoney})
                            .color(.yellowTC)
                            .width(120.px)
                            .float(.left)
                        
                        Div().clear(.both)
                    }
                    .hidden(self.$validations.map{ $0.isEmpty })
                    .marginTop(3.px)
                    



                    /// payment
                    H1("Pagos en Efectivo")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 💰 No hay pagos en efectivo recibidos -")
                        .hidden(self.$payment.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Toggle
                        Div{
                            InputCheckbox(self.$paymentCheckBox)
                                .marginLeft(12.px)
                        }
                        .align(.left)
                        .width(80.px)
                        .float(.left)
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
                            .custom("width", "calc(100% - 560px)")
                            .float(.left)
                        /// Origin Order sale
                        Div("Costo")
                            .textAlign(.center)
                            .width(110.px)
                            .float(.left)
                        Div().clear(.both)
                    }.hidden(self.$payment.map{ $0.isEmpty })
                    Div{
                        ForEach(self.$payment) {
                            $0
                        }
                    }
                    
                    Div{
                        Div()
                            .height(35.px)
                            .align(.left)
                            .width(80.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div()
                            .height(35.px)
                            .width(120.px)
                            .float(.left)
                        Div{
                            Span("TOTAL")
                                .color(.yellowTC)
                                .marginRight(12.px)
                        }
                            .custom("width", "calc(100% - 560px)")
                            .textAlign(.right)
                            .float(.left)
                        Div(self.$paymentBalance.map{$0.formatMoney})
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
                        /// Toggle
                        Div{
                            InputCheckbox(self.$moneyManagerCheckBox)
                                .marginLeft(12.px)
                        }
                        .width(10.percent)
                        .align(.left)
                        .float(.left)
                        /// Date
                        Div("Fecha")
                            .width(10.percent)
                            .float(.left)
                        /// Folio
                        Div("Folio")
                            .width(10.percent)
                            .float(.left)
                        /// Pagos
                        Div("Pagos")
                            .width(10.percent)
                            .float(.left)
                        /// Dinero
                        Div("Dinero")
                            .width(10.percent)
                            .float(.left)
                        /// Gastos
                        Div("Gastos")
                            .width(10.percent)
                            .float(.left)
                        /// Depositos
                        Div("Depositos")
                            .width(10.percent)
                            .float(.left)
                        /// Faltantes
                        Div("Faltantes")
                            .width(10.percent)
                            .float(.left)
                        /// Cortes
                        Div("Cortes")
                            .width(10.percent)
                            .float(.left)
                        /// SubTotoles
                        Div("SubTotales")
                            .textAlign(.center)
                            .width(10.percent)
                            .float(.left)
                        
                        Div().clear(.both)
                        
                    }.hidden(self.$moneyManager.map{ $0.isEmpty })
                    Div{
                        ForEach(self.$moneyManager) {
                            $0
                        }
                    }
                    
                     
                    /// financials
                    H1("Cortes Recibidos / Servicios Financieros")
                        .marginBottom(7.px)
                        .marginTop(12.px)
                    Table().noResult(label: "- 📈 No hay cortes generados -")
                        .hidden(self.$financials.map{ !$0.isEmpty })
                        .height(150.px)
                    Div{
                        /// Toggle
                        Div{
                            InputCheckbox(self.$financialsCheckBox)
                                .marginLeft(12.px)
                        }
                        .align(.left)
                        .width(5.percent)
                        .float(.left)
                        /// Date
                        Div("Fecha")
                            .width(15.percent)
                            .float(.left)
                        /// Folio
                        Div("Folio")
                            .width(15.percent)
                            .float(.left)
                        /// Origin Order sale
                        Div("Tipo/Descripción")
                            .width(50.percent)
                            .float(.left)
                        /// Cost
                        Div("Balance")
                            .textAlign(.center)
                            .width(15.percent)
                            .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    .hidden(self.$financials.map{ $0.isEmpty })
                    Div{
                        ForEach(self.$financials) {
                            $0
                        }
                    }
                    Div{
                        /// Toggle
                        Div("")
                        .align(.left)
                        .width(5.percent)
                        .height(35.px)
                        .float(.left)
                        /// Date
                        Div("")
                            .width(15.percent)
                            .height(35.px)
                            .float(.left)
                        /// Folio
                        Div("")
                            .width(15.percent)
                            .height(35.px)
                            .float(.left)
                        /// Origin Order sale
                        Div("Total")
                            .color(.goldenRod)
                            .textAlign(.right)
                            .width(50.percent)
                            .height(35.px)
                            .float(.left)
                        /// Cost
                        Div(self.$financialsBalance.map{ $0.formatMoney })
                            .color(.goldenRod)
                            .textAlign(.center)
                            .width(15.percent)
                            .height(35.px)
                            .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    .hidden(self.$financials.map{ $0.isEmpty })
                    
                }
                .custom("height", "calc(100% - 70px)")
                .overflow(.auto)
                Div{
                    Span(self.$total).color(.yellowTC)
                        .fontSize(32.px)
                    
                    /// Transferir
                    Div(self.type.description)
                        .class(.uibtnLarge)
                        .float(.right)
                        .onClick {
                            self.reciveDailyCut(type: .generalTransfer)
                        }
                        .hidden(self.$type.map{ $0 != .generalTransfer })
                    
                    /// Deposito Bancario
                    Div{
                    
                        Img()
                            .src("/skyline/media/money_bag.png")
                            .marginRight(12.px)
                            .height(24.px)
                            .width(24.px)
                        
                        Span("Deposito Bancario")
                    }
                        .class(.uibtnLarge)
                        .float(.right)
                        .onClick {
                            self.reciveDailyCut(type: .bankDeposit)
                        }
                        .hidden(self.$type.map{ $0 != .bankDeposit && $0 != .safeBoxDeposit })
                    
                    /// Deposito Caja Fuerte
                    Div{
                        
                            Img()
                                .src("/skyline/media/security.png")
                                .marginRight(12.px)
                                .height(24.px)
                                .width(24.px)
                        Span("Deposito Caja Fuerte")
                    }
                        .class(.uibtnLarge)
                        .marginRight(7.px)
                        .float(.right)
                        .onClick {
                            self.reciveDailyCut(type: .safeBoxDeposit)
                        }
                        .hidden(self.$type.map{ $0 != .bankDeposit && $0 != .safeBoxDeposit })
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
            
            $validationCheckBox.listen { state in
                self.validations.forEach { item in
                    item.isChecked = state
                }
                self.calculateBalance()
            }
            
            $paymentCheckBox.listen { state in
                self.payment.forEach { item in
                    item.isChecked = state
                }
                self.calculateBalance()
            }
                
            $moneyManagerCheckBox.listen {state in
                self.moneyManager.forEach { item in
                    item.isChecked = state
                }
                self.calculateBalance()
            }
                
            $financialsCheckBox.listen { state in
                self.financials.forEach { item in
                    item.isChecked = state
                }
                self.calculateBalance()
            }
            
            loadingView(show: true)
            
            API.custAPIV1.dailyCut(id: self.user.id) { resp in
                
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
                
                self.storeid = payload.store
                
                payload.foliorefs.forEach { ref in
                    self.foliorefs[ref.id] = ref.folio
                }
                
                Console.clear()

                print("payload.validations")
                print(payload.validations.count)

                print("payload.payment")
                print(payload.validations.count)


                print("payload.financials")
                print(payload.financials.count)

                self.validations = payload.validations.map{ PaymentRow(item:$0, relatedFolio: self.foliorefs[$0.custFolio] ?? "N/A"){
                    Dispatch.asyncAfter(0.25) {
                        self.calculateBalance()
                    }
                }}
                
                self.validationsBalance = payload.validations.map{ $0.cost }.reduce(0, +)
                
                self.payment = payload.payment.map{ PaymentRow(item:$0, relatedFolio: self.foliorefs[$0.custFolio] ?? "N/A"){
                    Dispatch.asyncAfter(0.25) {
                        self.calculateBalance()
                    }
                }}
                
                self.paymentBalance = payload.payment.map{ $0.cost }.reduce(0, +)
                
                self.moneyManager = payload.moneyManager.map{ MoneyManagerRow($0) {
                    Dispatch.asyncAfter(0.25) {
                        self.calculateBalance()
                    }
                }}
                
                self.financials = payload.financials.map{ FinancialRow($0) {
                    Dispatch.asyncAfter(0.25) {
                        self.calculateBalance()
                    }
                }}
                
                self.financialsBalance = payload.financials.map{ $0.balance }.reduce(0, +)
                
                self.storeBalance = payload.storeBalance
                
                self.calculateBalance()
                
            }
        }
        
        func calculateBalance(){
            
            validationsBalance = validations.map{ $0.isChecked ? $0.item.cost : 0 }.reduce(0, +)
            
            var _total: Int64 = 0
            
            paymentBalance = payment.map{ $0.isChecked ? $0.item.cost : 0 }.reduce(0, +)
            
            _total += paymentBalance
            
            _total += moneyManager.map{ $0.isChecked ? $0.item.total : 0 }.reduce(0, +)
            
            _total += financials.map{ $0.isChecked ? $0.item.balance : 0 }.reduce(0, +)
            
            _total += storeBalance
            
            self.total = _total.formatMoney
            
        }
        
        func reciveDailyCut(type reciveDailyCutType: MoneyManagerType){
            
            guard let storeid else {
                showError(.invalidField, "So se localizo tienda")
                return
            }
            
            var _validations: [API.custAPIV1.PaymentToRender] = []
            
            var _payments: [API.custAPIV1.PaymentToRender] = []
            
            var _moneyManager: [CustMoneyManager] = []
            
            var _financials: [API.custAPIV1.FinancialsRender] = []
            
            validations.forEach { view in
                if view.isChecked {
                    _validations.append(view.item)
                }
            }
            
            payment.forEach { view in
                if view.isChecked {
                    _payments.append(view.item)
                }
            }
            
            moneyManager.forEach { view in
                if view.isChecked {
                    _moneyManager.append(view.item)
                }
            }
            
            financials.forEach { view in
                if view.isChecked {
                    _financials.append(view.item)
                }
            }
            
            addToDom(ReciveDepositView(
                type: reciveDailyCutType,
                userid: user.id,
                username: user.name,
                storeid: storeid,
                storeBalance: storeBalance,
                validations: _validations,
                payments: _payments,
                custMoneyManager: _moneyManager,
                financials: _financials
            ){
                self.remove()
            })
            
        }
    }
}


