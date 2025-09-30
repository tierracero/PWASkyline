//
//  MoneyManager+NewDailyCut+ReciveDepositView.swift
//  
//
//  Created by Victor Cantu on 7/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.NewDailyCutView {
    
    class ReciveDepositView: Div {
        
        override class var name: String { "div" }
        
        let type: MoneyManagerType
        let userid: UUID
        let username: String
        let storeid: UUID
        let storeBalance: Int64
        /// Non cash payments
        let validations: [API.custAPIV1.PaymentToRender]
        /// Cash payments
        let payments: [API.custAPIV1.PaymentToRender]
        let custMoneyManager: [CustMoneyManager]
        let financials: [API.custAPIV1.FinancialsRender]
        
        private var success: ((
        ) -> ())
        
        init(
            type: MoneyManagerType,
            userid: UUID,
            username: String,
            storeid: UUID,
            storeBalance: Int64,
            validations: [API.custAPIV1.PaymentToRender],
            payments: [API.custAPIV1.PaymentToRender],
            custMoneyManager: [CustMoneyManager],
            financials: [API.custAPIV1.FinancialsRender],
            success: @escaping ((
            ) -> ())
        ) {
            self.type = type
            self.userid = userid
            self.username = username
            self.storeid = storeid
            self.storeBalance = storeBalance
            self.validations = validations
            self.payments = payments
            self.custMoneyManager = custMoneyManager
            self.financials = financials
            self.success = success
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var storename = "N/A"
        
        @State var balance: Int64 = 0
        
        @State var actionTitle = ""
        
        @State var remainsInBox = "0"
        
        @State var missingInBox = "0"
        
        var isCreatingDaylyCut = false
        
        lazy var remainsInBoxField = InputText(self.$remainsInBox)
            .custom("width","calc(100% - 18px)")
            .class(.textFiledBlackDark)
            .placeholder("0.00")
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onKeyUp {
                self.calculateBalance()
            }
            .onFocus { tf in
                tf.select()
            }
        
        lazy var missingInBoxField = InputText(self.$missingInBox)
            .placeholder("0.00")
            .custom("width","calc(100% - 18px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            .onKeyDown({ tf, event in
                guard let _ = Float(event.key) else {
                    if !ignoredKeys.contains(event.key) {
                        event.preventDefault()
                    }
                    return
                }
            })
            .onKeyUp {
                self.calculateBalance()
            }
            .onFocus { tf in
                tf.select()
            }
        
        @DOM override var body: DOM.Content {
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2(self.type.description)
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
                Div{
                    
                    H2("Tarjeta y otros pagos sin efectivo")
                        .color(.gray)
                    
                    Div(self.validations.map{ $0.cost }.reduce(0, +).formatMoney)
                        .marginBottom(23.px)
                        .fontSize(32.px)
                        .color(.white)
                    
                    H2("Caja chica actual")
                        .color(.gray)
                    
                    Div(self.storeBalance.formatMoney)
                        .marginBottom(7.px)
                        .fontSize(32.px)
                        .color(.white)
                    
                    H2("Balance")
                        .color(.gray)
                    
                    Div(self.balance.formatMoney)
                        .marginBottom(7.px)
                        .fontSize(32.px)
                        .color(.white)
                        
                    H2("Deja en caja")
                        .color(.gray)
                    
                    Div{
                        self.remainsInBoxField
                    }
                    .marginBottom(7.px)
                    .fontSize(32.px)
                    .color(.white)
                    
                    H2("Faltante")
                        .color(.gray)
                    
                    Div{
                        self.missingInBoxField
                    }
                    .marginBottom(7.px)
                    .fontSize(32.px)
                    .color(.white)
                    
                    H2(self.$actionTitle)
                        .color(.gray)
                    
                    Div(self.$balance.map{ $0.formatMoney })
                        .marginBottom(7.px)
                        .fontSize(32.px)
                        .color(.white)
                }
                
                Div{
                    Div(self.type.description)
                        .class(.uibtnLargeOrange)
                        .width(90.percent)
                        .onClick {
                            self.dailyCutCreate()
                        }
                }
                .marginTop(24.px)
                .align(.center)
                
            }
            .custom("left", "calc(50% - 250px)")
            .custom("top", "calc(50% - 300px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(570.px)
            .width(500.px)
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
            
            stores.forEach { id, store in
                if storeid == id {
                    storename = store.name
                }
            }
            
            remainsInBox = storeBalance.formatMoney
            
            calculateBalance()
            
            switch self.type {
            case .bankDeposit:
                self.actionTitle = "Total de deposito a banco"
            case .generalTransfer:
                self.actionTitle = "Total a Recibir"
            case .safeBoxDeposit:
                self.actionTitle = "Total de deposito a caja fuerte"
            }
            
        }
        
        func calculateBalance() {
            
            if remainsInBox == "" {
                remainsInBox = "0"
                remainsInBoxField.select()
            }
            
            if missingInBox == "" {
                missingInBox = "0"
                missingInBoxField.select()
            }
            
            remainsInBox = remainsInBox.replace(from: ",", to: "")
            
            missingInBox = missingInBox.replace(from: ",", to: "")
            
            guard let _remainsInBox = Double(remainsInBox)?.toCents else {
                print("❌ remainsInBox \(remainsInBox)")
                return
            }
            guard let _missingInBox = Double(missingInBox)?.toCents else {
                print("❌ missingInBox \(missingInBox)")
                return
            }
            
            balance = 0
            
            balance += payments.map{ $0.cost }.reduce(0, +)
            
            balance += custMoneyManager.map{ $0.total }.reduce(0, +)
            
            balance += financials.map{ $0.balance }.reduce(0, +)
            
            balance -= _missingInBox
            
            balance += (storeBalance - _remainsInBox)
            
        }
        
        func dailyCutCreate() {
            
            if isCreatingDaylyCut {
                return
            }
            
            if remainsInBox == "" {
                remainsInBox = "0"
                remainsInBoxField.select()
            }
            
            if missingInBox == "" {
                missingInBox = "0"
                missingInBoxField.select()
            }
            
            guard let _remainsInBox = Double(remainsInBox)?.toCents else {
                showError(.formatoInvalido, "Ingrese balance de caja valido.")
                remainsInBoxField.select()
                return
            }
            
            guard let _missingInBox = Double(missingInBox)?.toCents else {
                showError(.formatoInvalido, "Ingrese balance faltante.")
                missingInBoxField.select()
                return
            }
            
            balance = 0
            
            balance += payments.map{ $0.cost }.reduce(0, +)
            
            balance += custMoneyManager.map{ $0.total }.reduce(0, +)
            
            balance += financials.map{ $0.balance }.reduce(0, +)
            
            balance -= _missingInBox
            
            balance += (storeBalance - _remainsInBox)
            
            let validationsIds = validations.map{ $0.id }
            
            let paymentsIds = payments.map{ $0.id }
            
            let custMoneyManagerIds = custMoneyManager.map{ $0.id }
            
            let financialsIds = financials.map{ $0.id }
            
            loadingView(show: true)
            
            isCreatingDaylyCut = true
            
            API.custAPIV1.dailyCutCreate(
                type: type,
                userid: userid,
                hasStoreBalance: true,
                storeid: storeid,
                torender: balance,
                inBoxOld: storeBalance,
                inBoxNew: _remainsInBox,
                faltante: _missingInBox,
                validations: validationsIds,
                payments: paymentsIds,
                financials: financialsIds,
                moneyManager: custMoneyManagerIds
            ) { resp in
                
                self.isCreatingDaylyCut = false
                
                loadingView(show: false)
                
                guard let resp = resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let moneyManager = resp.data else  {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                var msg = "Folio de Transaccion:\n\(moneyManager.folio)"
                
                switch self.type {
                case .bankDeposit:
                    msg += "\n1) Anote el folio en el sobre de deposito" +
                    "\n2)Regrese a anotar los datos del deposito una vez que los tenga" +
                    "\n(Dinero y Corte -> Depositos)"
                case .generalTransfer:
                    msg = ""
                case .safeBoxDeposit:
                    msg += "\nAnote el folio en el sobre de deposito."
                }
                
                addToDom( ConfirmView(type: .ok, title: "🟢 Operacion Exitosa", message: msg){ isConfirmed,comment in
                    
                    let view = MoneyManagerView.AuditView.MoneyManagerSubView(moneyManager, true) {
                        // No procedure requiered
                    }
                    
                    addToDom(view)
                    
                    self.success()
                    self.remove()
                })
            }
        }
    }
}
