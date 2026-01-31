//
//  Account+ConfimeSiweCard.swift
//  
//
//  Created by Victor Cantu on 9/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

extension AccountView {
    
    class ConfimeSiweCard: Div {
        
        override class var name: String { "div" }
        
        let custAcct: UUID
        
        let cc: Countries
        
        let mobile: String
        
        let tokens: [String]
        
        let cardId: String
        
        private var callback: ((
            _ cardId: String
        ) -> ())
        
        init(
            custAcct: UUID,
            cc: Countries,
            mobile: String,
            tokens: [String],
            cardId: String,
            callback: @escaping ( (
                _ cardId: String
            ) -> ())
        ) {
            self.custAcct = custAcct
            self.cc = cc
            self.mobile = mobile
            self.tokens = tokens
            self.cardId = cardId
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var pin = ""
        
        lazy var pinField = InputText(self.$pin)
            .class(.textFiledBlackDarkLarge)
            .placeholder("0000")
            .textAlign(.center)
            .fontSize(48.px)
            .pattern("\\d*")
            .width(150.px)
            .height(64.px)
            .onEnter {
                self.confirmPin()
            }
            .onKeyDown { tf, event in
                
                if ignoredKeys.contains(event.key) {
                    return
                }
                
                guard let _ = Int64(event.key) else {
                    event.preventDefault()
                    return
                }
                
                if self.pin.count > 3 {
                    event.preventDefault()
                }
            }
        
        @DOM override var body: DOM.Content {
            
            Div{
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.uiView2)
                            .onClick{
                                self.remove()
                            }
                        
                        H2("Confimar PIN")
                            .color(.lightBlueText)
                            .height(35.px)
                    }
                    
                    Div().clear(.both)
                    
                    Div{
                        self.pinField
                    }
                    .marginBottom(12.px)
                    .marginTop(18.px)
                    .align(.center)
                    .height(78.px)
                    
                    Div("Ingresa PIN recibido por SMS")
                        .color(.goldenRod)
                        .margin(all: 3)
                    
                    Div().clear(.both).height(7.px)
                    
                    Div{
                        
                        A("Confirmar")
                            .class(.uibtnLargeOrange)
                            .width(95.percent)
                            .position(.sticky)
                            .zIndex(1)
                            .onClick {
                                self.confirmPin()
                            }
                        
                    }
                    .align(.center)
                    
                }
                .height(100.percent)
                .margin(all: 7.px)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 175px)")
            .custom("top", "calc(50% - 100px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .width(350.px)
                
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
            pinField.select()
        }
        
        
        func confirmPin() {
            
            pin = pin.purgeSpaces
            
            if pin.isEmpty {
                showError(.generalError, "Ingrese PIN")
                return
            }
            
            guard let _ = Int(pin) else {
                showError(.generalError, "Ingrese PIN valido")
                return
            }
            
            guard pin.count == 4 else {
                showError(.generalError, "Ingrese PIN valido (4 digitos)")
                return
            }
            
            loadingView(show: true)
            
            API.custAccountV1.activateSiweCard(
                custAcct: custAcct,
                cardId: cardId,
                tokens: tokens,
                pin: pin,
                cc: cc,
                mobile: mobile
            ) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, "Error de comunicación")
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                self.callback(self.cardId)
                
                self.remove()
                
            }
            
        }
        
    }
}
