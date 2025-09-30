//
//  ConfirmartionSMSView.swift
//
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ConfirmartionSMSView: Div {
    
    override class var name: String { "header" }
    
    let tokens: [String]
    
    let mobile: String
    
    /// Inlcude to crate Profile (Siwe Premier Account) SubProfile (Siwe-Cust Account)
    let customer: API.custAPIV1.ConfirmConfirmartionCustomer?
    
    private var callback: ((
        _ token: String
    ) -> ())
    
    init(
        tokens: [String],
        mobile: String,
        customer: API.custAPIV1.ConfirmConfirmartionCustomer?,
        callback: @escaping ((
            _ token: String
        ) -> ())
    ) {
        self.tokens = tokens
        self.mobile = mobile
        self.customer = customer
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
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.remove()
                    }
                
                Strong(LString(String.confirmPin))
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
            }
            
            Div().clear(.both)
            
            Div{
                self.pinField
            }
            .marginBottom(12.px)
            .marginTop(18.px)
            .align(.center)
            .height(78.px)
            
            Div{
                Span(LString(String.addRecivedPIN))
            }
            .color(.goldenRod)
            .margin(all: 3)
            
            Div{
                
                Div{
                    
                    A("Confirmar")
                        .width(95.percent)
                        .position(.sticky)
                        .zIndex(1)
                        .onClick {
                            self.confirmPin()
                        }
                    
                }
                .class(.uibtnLargeOrange)
            }
            .align(.center)
            
            
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
        self.class(.transparantBlackBackGround)
        height(100.percent)
        width(100.percent)
        position(.fixed)
        left(0.px)
        top(0.px)
        
    }
    
    override public func didAddToDOM() {
        super.didAddToDOM()
        
        pinField.select()
    }
    
    func confirmPin() {
        
        if pin.isEmpty {
            showError(.errorGeneral, "Ingrese PIN")
            return
        }
        
        guard let _ = Int(pin) else {
            showError(.errorGeneral, "Ingrese PIN valido")
            return
        }
        
        guard pin.count == 4 else {
            showError(.errorGeneral, "Ingrese PIN valido (4 digitos)")
            return
        }
        
        loadingView(show: true)
        
        API.custAPIV1.confirmConfirmartionSMS(
            tokens: tokens,
            pin: pin,
            mobile: mobile,
            customer: customer
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, "Error de conexion al servidor")
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.errorGeneral, "Error al obtener payload de data")
                return
            }
            
            if payload.expireSession {
                showError(.errorGeneral, "PIN invalido, inicie de nuevo.")
                self.remove()
                return
            }
            
            guard let token = payload.aprovedToken else {
                showError(.unexpectedResult, "No se obtuvo el token necesario")
                return
            }
            
            self.callback(token)
            
            self.remove()
            
        }
    }
}

