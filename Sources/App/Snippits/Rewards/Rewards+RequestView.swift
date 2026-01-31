//
//  Rewards+RequestView.swift
//
//
//  Created by Victor Cantu on 2/22/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import TaecelAPICore
import Web

extension RewardsView {
 
    class RequestView: PageController {
        
        override class var name: String { "div" }
        
        let accountId: UUID
        
        let cardId: String
        
        let mobile: String
        
        let product: TaecelAPICore.ProductItem
        
        let categorie: TaecelAPICore.CategoriesItem
        
        var points: State<Int>
        
        init(
            accountId: UUID,
            cardId: String,
            mobile: String,
            product: TaecelAPICore.ProductItem,
            categorie: TaecelAPICore.CategoriesItem,
            points: State<Int>
        ) {
            self.accountId = accountId
            self.cardId = cardId
            self.mobile = mobile
            self.product = product
            self.categorie = categorie
            self.points = points
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        var productName = ""
        
        var originalAmount = ""
        
        var statusRevitions = 0
        
        @State var refrence = ""
        
        @State var confirmRefrence = ""
        
        @State var amount = "0"
        
        @State var purchaseViewIsHidden = true
        
        @State var purchaseIsActive = false
        
        @State var purchaseProcessingText = "Iniciando..."
        
        lazy var amountField = InputText(self.$amount)
            .placeholder("0.00")
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .fontSize(28.px)
            .float(.right)
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
        
        lazy var refrenceField = InputText(self.$refrence)
            .placeholder("Celular o Referencia")
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .fontSize(28.px)
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
        
        lazy var confirmRefrenceField = InputText(self.$confirmRefrence)
            .placeholder("Confirme Celular o Referencia")
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .fontSize(28.px)
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
        
        lazy var processWindow = Div{
            Div{
                Div{
                    Img()
                        .closeButton(.view)
                        .onClick {
                            self.purchaseProcessingText = "Iniciando..."
                            self.purchaseIsActive = false
                            self.purchaseViewIsHidden = true
                        }
                    
                    H2("⭐️ \(self.product.carrierName) \(self.product.name)")
                        .color(.black)
                        .float(.left)
                    
                    
                    H2(self.points.map{ "\($0.toString) pts" })
                        .marginTop(4.px)
                        .color(.yellowTC)
                        .float(.left)
                    
                    Div().clear(.both)
                }
                Div{
                    
                    Div{
                        
                        if self.categorie.avatar.isEmpty {
                            Span("\(self.product.name) \(self.product.carrierName)")
                                .fontSize(32.px)
                        }
                        else {
                            Img()
                                .src(self.categorie.avatar)
                                .width(50.percent)
                        }
                    }
                    .align(.center)
                    .color(.black)
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        
                        H2("$\(self.product.amount.formatMoney)")
                            .color(.black)
                            .float(.right)
                        
                        H2(self.productName)
                            .color(.black)
                            .float(.left)
                    }
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        H2("Puntos")
                            .color(.black)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        H3("\((self.product.amount * 2).rounded(.up).formatMoney)")
                            .color(.black)
                            .float(.right)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        
                        H3("Referencia")
                            .color(.gray)
                        
                        Div().clear(.both).height(3.px)
                        
                        H2(self.$refrence)
                        
                    }
                    Div().clear(.both).height(3.px)
                    
                    
                    Div{
                        Img()
                            .hidden(self.$purchaseIsActive.map{ !$0 })
                            .src("skyline/media/loader.gif")
                        
                        H1(self.$purchaseProcessingText)
                            .color(.blue)
                    }
                    .textAlign(.center)
                    
                    Div().clear(.both).height(3.px)
                    
                    if !self.product.validity.isEmpty {
                        Div("Expira en \(self.product.validity)")
                            .color(.black)
                        Div().clear(.both).height(3.px)
                    }
                    
                    Span(self.product.description)
                        .color(.black)
                    
                    Div().clear(.both).height(7.px)
                    
                    
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
            }
            .backgroundColor(.white)
            .custom("left","calc(50% - 214px)")
            .custom("top","calc(50% - 214px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(400.px)
            .width(400.px)
        }
            .class(.transparantBlackBackGround)
            .position(.absolute)
            .height(100.percent)
            .width(100.percent)
            .left(0.px)
            .top(0.px)
            .hidden(self.$purchaseViewIsHidden)
        
        @DOM override var body: DOM.Content {
            Div{
                Div{
                    Img()
                        .closeButton(.view)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("⭐️ \(self.product.carrierName) \(self.product.name)")
                        .color(.white)
                        .float(.left)
                    
                    H2(self.points.map{ "\($0.toString) pts" })
                        .marginTop(4.px)
                        .color(.yellowTC)
                        .float(.left)
                    
                    Div().clear(.both)
                }
                
                Div{
                    
                    Div{
                        
                        if self.categorie.avatar.isEmpty {
                            Span("\(self.product.name) \(self.product.carrierName)")
                                .fontSize(32.px)
                        }
                        else {
                            Img()
                                .src(self.categorie.avatar)
                                .width(50.percent)
                        }
                    }
                    .align(.center)
                    .color(.white)
                    
                    Div().clear(.both).height(3.px)
                    
                    H3("Producto")
                        .color(.gray)
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        
                        if self.categorie.categorieId == .services {
                            self.amountField
                        }
                        else {
                            H2("$\(self.product.amount.formatMoney)")
                                .color(.white)
                                .float(.right)
                        }
                        
                        H2(self.productName)
                            .color(.white)
                            .float(.left)
                    }
                    
                    
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        H2("Puntos")
                            .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{if self.categorie.categorieId == .services {
                        self.amountField
                        
                        H1(self.$amount.map{ ((Double($0) ?? 0) * 2 ).rounded(.up).formatMoney })
                            .color(.white)
                            .float(.right)
                    }
                    else {
                        H1((self.product.amount * 2).rounded(.up).formatMoney)
                            .color(.white)
                            .float(.right)
                    }
                        
                        
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        
                        H3("Referencia")
                            .color(.gray)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.refrenceField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        
                        H3("Confirme Referencia")
                            .color(.gray)
                        
                        Div().clear(.both).height(3.px)
                        
                        self.confirmRefrenceField
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        Div("Usar Puntos")
                            .class(.uibtnLargeOrange)
                            .align(.center)
                            .onClick {
                                self.purchase()
                            }
                    }
                    .align(.right)
                    
                    Div().clear(.both).height(3.px)
                    
                    if !self.product.validity.isEmpty {
                        Div("Expira en \(self.product.validity)")
                            .color(.white)
                        Div().clear(.both).height(3.px)
                    }
                    
                    Span(self.product.description)
                        .color(.white)
                    
                    Div().clear(.both).height(7.px)
                    
                    
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left","calc(50% - 214px)")
            .custom("top","calc(50% - 289px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(500.px)
            .width(450.px)
            
            self.processWindow
            
        }
        
        override func buildUI() {
            
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            Console.clear()
            
            print("- - - - - - - - - -")
            
            print(categorie)
            
            print("- - - - - - - - - -")
            
            print(product)
            
            productName = ( !product.name.isEmpty ? product.name : product.carrierName )
            
            /*
            loadingView(show: true)
             
            getProduct(taecelId: "") { resp in
            
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
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
                
                let fields = payload.fileds
                
                
                
            }
            */
        }
        
        func purchase(){
            
            if refrence.isEmpty {
                showError( .generalError, "Ingrese Referencia")
                refrenceField.select()
                return
            }
            
            if confirmRefrence.isEmpty {
                showError( .generalError, "Confirme Referencia")
                confirmRefrenceField.select()
                return
            }
            
            if refrence != confirmRefrence {
                showError( .generalError, "Referencia no coinciden")
                refrenceField.select()
                confirmRefrence = ""
                return
            }
            
            var price = product.amount
            
            if self.categorie.categorieId == .services {
                guard let _amount = Double(amount) else {
                    showError( .generalError, "Ingrese una cantidad valida")
                    amountField.select()
                    return
                }
                
                price = _amount
            }
            
            print("price \((price * 2).rounded(.up))")
            
            print("points.wrappedValue.toDouble \(points.wrappedValue.toDouble)")
            
            guard points.wrappedValue.toDouble >= (price * 2).rounded(.up) else {
                showError( .generalError, "Lo sentimos, no cuenta con los puntos suficentes para esta compra.")
                return
            }
            
            purchaseIsActive = true
            
            purchaseViewIsHidden = false
            
            purchaseProcessingText = "Iniciando proceso"
            
            loadingView(show: true, message: "Iniciando proceso")
            
            API.rewardsV1.purchase(
                cardId: cardId,
                custAcctId: accountId,
                product: product.taecelId,
                refrence: refrence,
                price: price
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, "No se pudo comunicar con el servidor")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    self.purchaseProcessingText = resp.msg
                    self.purchaseIsActive = false
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    self.purchaseProcessingText = "Falla inesperada (payload)."
                    self.purchaseIsActive = false
                    return
                }
                
                print(payload)
                
                self.purchaseStatus(
                    transId: payload.transId,
                    phase: .one,
                    newBalance: payload.remaingBalance
                )
                
            }
        }
        
        func purchaseStatus(transId: String, phase: TaecelAPICore.PurchaseRevisionPhase, newBalance: Double){
            
            purchaseProcessingText = "Revisando [\(phase.rawValue)]"
            
            Dispatch.asyncAfter(phase.timeout) {
                
                API.rewardsV1.status(
                    transId: transId,
                    phase: phase
                ) { resp in
                    
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.comunicationError, "No se pudo comunicar con el servir")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        
                        self.purchaseIsActive = false
                        
                        self.purchaseProcessingText = resp.msg
                        
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    guard let casepayload = resp.data else {
                        self.purchaseIsActive = false
                        self.purchaseProcessingText = "Error inesperado..."
                        showError(.unexpectedResult, .unexpenctedMissingPayload)
                        return
                    }
                 
                    switch casepayload {
                    case .wait:
                        
                        if let nextPhase = phase.nextPhase {
                            self.purchaseStatus(
                                transId: transId,
                                phase: nextPhase,
                                newBalance: newBalance
                            )
                        }
                        else{
                            self.purchaseIsActive = false
                            self.purchaseProcessingText = "No se pudo acompletar la operacion revice manualmemte si la operacion se acompleto"
                            showError(.unexpectedResult, "No se pudo acompletar la operacion revice manualmemte si la operacion se acompleto")
                        }
                        
                    case .fail(let message):
                        self.purchaseIsActive = false
                        self.purchaseProcessingText = message
                        showError(.generalError, message)
                    case .success(let payload):
                        
                        print(payload)
                        
                        self.purchaseIsActive = false
                        
                        self.purchaseProcessingText = "🟢 Transacción Exitosa Folio \(payload.folio)"
                        
                        if let pin = payload.pin {
                            self.purchaseProcessingText =  "\(self.purchaseProcessingText)\nPIN:\(pin)"
                        }
                        
                        self.points.wrappedValue = newBalance.toInt
                        
                        showSuccess( .operacionExitosa, "Folio: \(payload.folio)", .verryLong)
                        
                    }
                }
            }
        }
    }
}
