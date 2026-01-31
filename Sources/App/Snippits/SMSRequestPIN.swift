//
//  SMSRequestPIN.swift
//
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import LanguagePack
import Web

class SMSRequestPIN: Div {
    
    override class var name: String { "div" }
    
    let custAcct: UUID
    
    let firstName: String
    
    let cc: Countries
    
    let mobile: String
    
    private var callback: ((
        _ token: String
    ) -> ())
    
    init(
        custAcct: UUID,
        firstName: String,
        cc: Countries,
        mobile: String,
        callback: @escaping ( (
            _ token: String
        ) -> ())
    ) {
        self.custAcct = custAcct
        self.firstName = firstName
        self.cc = cc
        self.mobile = mobile
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var cardId = ""
    
    ///Countries
    @State var countriesListener = ""
    
    lazy var mobileField = InputText(self.mobile)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Celular")
        .width(90.percent)
        .marginRight(7.px)
        .fontSize(23.px)
        .disabled(true)
    
    lazy var countriesSelect = Select(self.$countriesListener)
        .class(.textFiledBlackDarkLarge)
        .borderRadius(12.px)
        .width(95.percent)
        .fontSize(23.px)
        .marginTop(3.px)
    
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
                    
                    H2("Solicitar PIN")
                        .color(.lightBlueText)
                }
                
                Div{
                   
                    Div("Confirmar Celular SMS")
                        .marginBottom(3.px)
                        .marginTop(7.px)
                        .color(.white)
                    
                    Div{
                        Div{
                            self.countriesSelect
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            self.mobileField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                    }
                    
                    Div{
                        Div("Enviar SMS")
                            .class(.uibtnLargeOrange)
                            .textAlign(.center)
                            .marginBottom(3.px)
                            .marginTop(7.px)
                            .onClick {
                                self.solicitarPIN()
                            }
                    }
                    .align(.right)
                        
                }
                .padding(all: 7.px)
                
            }
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
        
        Countries.allCases.forEach { country in
            
            countriesSelect.appendChild(
                Option("+\(country.code) \(country.description)")
                    .value(country.code.toString)
            )
            
        }
        
        countriesListener = "52"
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func solicitarPIN() {
        
        guard let int = Int(countriesListener) else {
            showError(.generalError, "Seleccione Codigo de Pais")
            return
        }
        
        guard let cc = Countries(rawValue: int) else {
            showError(.generalError, "Seleccione Codigo de Pais Valido")
            return
        }
        
        if mobile.isEmpty {
            showError(.generalError, "Ingrese Numero Movil")
            mobileField.select()
            return
        }
        
        guard mobile.count == 10 else {
            showError(.generalError, "Ingrese Numero Movil a 10 Digitos")
            return
        }
        
        guard let _ = Int64(mobile) else {
            showError(.generalError, "Ingrese Numero Movil Valido")
            return
        }
        
        addToDom(HCaptchaView { response in
            
            if response.isEmpty {
                return
            }
        
            loadingView(show: true)
            
            API.custAPIV1.sendConfirmartionSMS(
                hCaptchResponse: response,
                firstName: self.firstName,
                cc: cc,
                mobile: self.mobile
            ){ resp in
            
                loadingView(show: false)
                
                guard let resp else{
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.generalError, .unexpectedError("No se localizo data de la respueta"))
                    return
                }
                
                self.callback(payload.token)
             
                self.remove()
            }
        })
        
    }
}
