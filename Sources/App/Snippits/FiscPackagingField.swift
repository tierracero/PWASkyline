//
//  FiscPackagingField.swift
//  
//
//  Created by Victor Cantu on 1/12/23.
//

import Foundation
import TCFundamentals
// import SkylinePublicAPI
import TCFireSignal
import Web

class FiscPackagingField: Div {
    
    override class var name: String { "div" }
    
    var usedFiscCode: [APISearchResultsGeneral] = []
    
    /// Current Code
    var currentCode: String = ""
    
    @State var textFieldStyle: Class = .textFiledBlackDark
    
    @State var fiscCodeDescription: String = ""
    
    @State var fiscCodeIsSelected: Bool = false
    
    lazy var fiscCodeField: InputText = InputText(self.$fiscCodeDescription)
        //.readonly(true)
        .placeholder("Cajas de Acero, Cajas de Cartón, Sacos...")
        .class(self.$textFieldStyle)
        .width(93.percent)
        .onFocus({ tf in
            
            tf.text = ""
            
            tf
                .removeClass(.isNok)
                .removeClass(.isLoading)
                .removeClass(.isOk)
            
            self.resultBox.innerHTML = ""
            
            self.usedFiscCode.forEach { code in
                self.addCodeResult( term: "", code: code)
            }
            
        })
        .onBlur { tf in
            if tf.text.isEmpty {
                self.loadFiscalCodeData(self.currentCode)
                Dispatch.asyncAfter(0.37) {
                    self.resultBox.innerHTML = ""
                }
            }
        }
        .onKeyUp({ tf, event in
            if ignoredKeys.contains(event.key) { return }
            self.searcCode()
        })
    
    let resultBox = Div()
        .margin(all: 0.px)
        .width(93.percent)
        .position(.absolute)
        .maxHeight(500.px)
        .overflow(.auto)
        .zIndex(1)
    
    /// light, dark
    let style: ThemeStyle
    
    ///service, product, manual, rental
    let type: ChargeType
    
    private var callback: ((_ data: APISearchResultsGeneral) -> ())
    
    init(
        /// light, dark
        style: ThemeStyle,
        ///service, product, manual, rental
        type: ChargeType,
        callback: @escaping ((_ data: APISearchResultsGeneral) -> ())
    ) {
        self.style = style
        self.type = type
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        self.fiscCodeField
        self.resultBox
    }
    
    override func buildUI() {
        super.buildUI()
        
        switch self.style{
        case .light:
            textFieldStyle = .textFiledLight
        case .dark:
            textFieldStyle = .textFiledBlackDark
        }
    }
    
    /*
    func loadBasicData(_ callback: (() -> ())? = nil){
        
        getUsedFiscCodes(type: self.type) { success in
            
            if !success {
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servidor para obtener codigos fiscales.")
                self.remove()
                return
            }
            
            self.usedFiscCode = []
            
            switch self.type{
            case .service:
                self.usedFiscCode.append(contentsOf: serviceUsedFiscCode)
            case .product:
                self.usedFiscCode.append(contentsOf: productUsedFiscCode)
            case .manual:
                self.usedFiscCode.append(contentsOf:  manualUsedFiscCode)
            case .rental:
                self.usedFiscCode.append(contentsOf: rentalUsedFiscCode)
            }
            
            if let callback = callback {
                callback()
            }
            
        }
    }
    */
    
    func loadFiscalCodeData(_ code: String){
        
        self.currentCode = code
        
        if !self.currentCode.isEmpty {
        
            self.fiscCodeIsSelected = true
            
            if let name = fiscCodeRefrence[self.currentCode] {
                
                self.fiscCodeDescription = "\(self.currentCode) \(name)"
                
                self.fiscCodeField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                return
            }
            
            
            self.fiscCodeField
                .removeClass(.isNok)
                .removeClass(.isOk)
                .class(.isLoading)
            
            API.v1.getFiscalPackagingType (code: self.currentCode) { resp in
                
                guard let resp = resp else {
                    self.fiscCodeField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                guard resp.status == .ok else {
                    self.fiscCodeField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                guard let data = resp.data else {
                    self.fiscCodeField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                self.fiscCodeField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                fiscCodeRefrence[self.currentCode] = data.value
                
                self.fiscCodeDescription = "\(self.currentCode) \(data.value)"
                
                self.fiscCodeIsSelected = true

            }
        }
        
    }
    
    func searcCode(){
    
        let term = self.fiscCodeDescription.pseudo.purgeSpaces
        
        Dispatch.asyncAfter(0.37) {
         
            if term != self.fiscCodeDescription.pseudo.purgeSpaces {
                return
            }
            
            var included: [String] = []
            
            self.resultBox.innerHTML = ""
            /*
            if term.isEmpty {
                /// Term is empty will load most used codes by default
                self.usedFiscCode.forEach { code in
                    self.addCodeResult( term: term, code: code)
                }
                return
            }
            
            if term.count <= 3{
                
                // Is Exacly
                self.usedFiscCode.forEach { code in
                    if code.c.lowercased() == term {
                        included.append(code.c)
                        self.addCodeResult( term: term, code: code)
                    }
                    if code.v.lowercased() == term {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Starts with
                self.usedFiscCode.forEach { code in
                    if !included.contains(code.c) {
                        if code.c.lowercased().starts(with: term) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                    if code.v.lowercased().starts(with: term) {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Contains
                self.usedFiscCode.forEach { code in
                    if !included.contains(code.c) {
                        if "\(code.c) \(code.v)".lowercased().contains(term) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Is Exacly
                fiscCodesBase.forEach { code in
                    if code.c.lowercased() == term {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                    if code.v.lowercased() == term {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Starts with
                fiscCodesBase.forEach { code in
                    if code.c.lowercased().starts(with: term) {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                    if code.v.lowercased().starts(with: term) {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Contains
                fiscCodesBase.forEach { code in
                    if "\(code.c) \(code.v)".lowercased().contains(term) {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                return
            }
            */
            self.fiscCodeField
                .removeClass(.isNok)
                .removeClass(.isOk)
                .class(.isLoading)
            
            getFiscalPackagingTypes(term: term) { term, resp in
                
                self.fiscCodeField
                    .removeClass(.isNok)
                    .removeClass(.isOk)
                    .removeClass(.isLoading)
                
                if term != self.fiscCodeDescription.pseudo.purgeSpaces {
                    return
                }
                
                if self.fiscCodeDescription.purgeSpaces.pseudo != term {
                    return
                }
                
                resp.forEach { code in
                    self.addCodeResult( term: term, code: code)
                }
                
            }
            
            
        }
    }
    
    func addCodeResult(term: String, code: APISearchResultsGeneral){
        
        var resultBoxHtml = self.resultBox.innerHTML
        
        if resultBoxHtml.contains("fiscCode_\(code.c)"){
            return
        }
        
        resultBoxHtml.removeAll()
        
        self.resultBox.appendChild (
            
            FiscResultView(type: .fiscCode,term: term, data: code, callback: { data in
                self.resultBox.innerHTML = ""
                
                self.currentCode = data.c
                
                fiscCodeRefrence[data.c] = data.v
                
                self.fiscCodeDescription = "\(data.c) \(data.v)"
                
                self.fiscCodeField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                self.callback(data)
                
            }).margin(all: 0.px)
        )
    }
    
}
