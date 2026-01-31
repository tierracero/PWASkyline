//
//  .swift
//  
//
//  Created by Victor Cantu on 5/29/24.
//

import Foundation
import TCFundamentals
import Web
import SiweAPICore
import TCFireSignal

extension AddPaymentFormView {

    class AddPaymentWithPointsView: Div {
        
        override class var name: String { "div" }
        
        let accountId: UUID
        
        /// Premier Card Id
        let cardId: String
        
        @State var currentBalance: Int64
        
        let points: RewardPoints
        
        private var callback: ((
            _ code: FiscalPaymentCodes,
            _ description: String,
            _ amount: Int64,
            _ provider: String,
            _ lastFour: String,
            _ auth: String,
            _ uts: Int64?
        ) -> ())
            
        init(
            accountId: UUID,
            cardId: String,
            currentBalance: Int64,
            points: RewardPoints,
            callback: @escaping ((
                _ code: FiscalPaymentCodes,
                _ description: String,
                _ amount: Int64,
                _ provider: String,
                _ lastFour: String,
                _ auth: String,
                _ uts: Int64?
            ) -> ())
        ) {
            self.accountId = accountId
            self.cardId = cardId
            self.currentBalance = currentBalance
            self.points = points
            self.callback = callback
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var payment = "0"
        
        @State var newBalance = "0.00"
        
        lazy var paymentInput = InputText(self.$payment)
            .class(.textFiledBlackDarkLarge)
        
        lazy var changeBalance = H1(self.$newBalance)
            .color(.white)
        
        @DOM override var body: DOM.Content {
            Div{
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Pagar con puntos")
                        .color(.lightBlueText)
                    
                    Div().class(.clear)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                // BALANCE
                Div{
                    
                    Div{
                        Label("Balance Actual")
                            .marginRight(12.px)
                            .fontSize(24.px)
                            .color(.white)
                    }
                    .width(50.percent)
                    .align(.right)
                    .float(.left)
                    
                    Div {
                        H1(self.currentBalance.formatMoney)
                            .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                // POINTS STATUS
                Div{
                    
                    Div{
                        Label("Puntos Disponibles")
                            .marginRight(12.px)
                            .fontSize(24.px)
                            .color(.white)
                    }
                    .width(50.percent)
                    .align(.right)
                    .float(.left)
                    
                    Div {
                        H1{
                            Span(self.points.balance.toString).color(.goldenRod)
                            Span("/")
                                .marginRight(3.px)
                                .color(.gray)
                                .marginLeft(3.px)
                            Span(self.points.preactive.map{ ($0.type == .positive) ? $0.points : 0}.reduce(0, +).toString)
                                .color(.gray)
                        }
                            .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                // POINTS TO PAY
                Div{
                    
                    Div {
                        Label("Pago")
                            .marginRight(12.px)
                            .fontSize(24.px)
                            .color(.white)
                    }
                    .width(50.percent)
                    .align(.right)
                    .float(.left)
                
                    Div{
                        self.paymentInput
                            .class(.textFiledLight)
                            .placeholder("0.00")
                            .width(150.px)
                            .height(28.px)
                            .onFocus{ input in
                                input.select()
                            }
                            .onKeyUp { input, event in
                                self.calcNewBalance()
                            }
                            .onKeyDown({ tf, event in
                                guard let _ = Float(event.key) else {
                                    if !ignoredKeys.contains(event.key) {
                                        event.preventDefault()
                                    }
                                    return
                                }
                            })
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                /// BALANCE
                Div{
                    
                    Div {
                        Label("Nuevo Balance")
                            .color(.init(r: 86, g: 230, b: 86))
                            .marginRight(12.px)
                            .fontSize(32.px)
                    }
                    .width(50.percent)
                    .align(.right)
                    .float(.left)
                
                    Div{
                        self.changeBalance
                    }
                    .width(50.percent)
                    .float(.left)
                    
                }
                
                Div().class(.clear).height(12.px)
                
                Div("⚠️ El consumo de puntos no puede ser rembolsado.")
                    .fontSize(18.px)
                    .color(.white)
                
                Div().class(.clear).height(12.px)
                
                Div{
                    Div("Usar Puntos")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.usePoints()
                        }
                }
                .align(.right)
                
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("top","calc(50% - 250px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(40.percent)
            .left(30.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            newBalance = currentBalance.formatMoney
            
        }
        
        func calcNewBalance(){
            
            newBalance = "0.00"
            
            self.changeBalance.color(.white)
            
            print("payment \(payment)")
            
            if payment.isEmpty {
                print("🔴 001")
                return
            }
            
            guard let thisPayment = Float(payment.replace(from: ",", to: ""))?.toCents else{
                print("🔴 002")
                return
            }
            
            let newbal = currentBalance - thisPayment
            
            newBalance = newbal.formatMoney
            
            if newbal > 0 {
                self.changeBalance.color(.init(r: 86, g: 230, b: 86))
            }
            else {
                self.changeBalance.color(.red)
            }
            
            
        }
        
        func usePoints(){
            
            if payment.isEmpty {
                showError(.generalError, "Ingrese una cantidad valida")
                return
            }
            
            guard let thisPayment = Double(payment.replace(from: ",", to: ""))?.toCents else{
                showError(.generalError, "Ingrese una cantidad valida")
                return
            }
            
            let newbal = currentBalance - thisPayment
            
            if newbal < 0 {
                showError(.generalError, "Los puntos deben ser igual o menor al balance de la cuenta")
                return
            }
            
            if thisPayment.fromCents.toInt > points.balance {
                showError(.generalError, "No cuenta con puntos sufficientes")
                return
            }
            
            
            addToDom(ConfirmationView(
                type: .aproveDeny,
                title: "Confirmar uso de \(thisPayment.formatMoney).",
                message: "Eduque al cliente que los punto usados no podran ser rembolsados."
            ){ isConfirmed, message in
                
                if !isConfirmed {
                    return
                }
                
                self.callback(.dineroElectronico, "Puntos Premier", thisPayment, "", "", "", nil)
         
                self.remove()
                
            })
        }
    }
}
