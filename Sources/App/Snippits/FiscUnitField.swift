//
//  FiscUnitField.swift
//
//
//  Created by Victor Cantu on 7/10/22.
//

import Foundation
// import SkylinePublicAPI
import TCFundamentals
import Web

class FiscUnitField: Div {
    
    override class var name: String { "div" }
    
    var usedFiscUnit: [APISearchResultsGeneral] = []
    
    /// Current Code
    var currentCode: String = ""
    
    @State var textFieldStyle: Class = .textFiledBlackDark
    
    @State var fiscUnitDescription: String = ""
    
    @State var fiscUnitIsSelected: Bool = false
    
    lazy var fiscUnitField: InputText = InputText(self.$fiscUnitDescription)
        //.readonly(true)
        .placeholder("Pieza, Unidad de servicios")
        .class(self.$textFieldStyle)
        .width(93.percent)
        .onFocus({ tf in
            
            tf.text = ""
            
            tf
                .removeClass(.isNok)
                .removeClass(.isLoading)
                .removeClass(.isOk)
            
            self.resultBox.innerHTML = ""
            
            self.usedFiscUnit.forEach { code in
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
        .onPaste {
            self.searcCode()
        }
    
    
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
        self.fiscUnitField
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
        
        loadBasicData()
    }
    
    func loadBasicData(_ callback: (() -> ())? = nil){
        
        getUsedFiscCodes(type: self.type) { success in
            
            if !success {
                showError(.errorDeCommunicacion, "No se pudo comunicar con el servidor para obtener codigos fiscales.")
                self.remove()
                return
            }
            
            self.usedFiscUnit = []
            
            switch self.type{
            case .service:
                self.usedFiscUnit.append(contentsOf: serviceUsedFiscUnit)
            case .product:
                self.usedFiscUnit.append(contentsOf: productUsedFiscUnit)
            case .manual:
                self.usedFiscUnit.append(contentsOf:  manualUsedFiscUnit)
            case .rental:
                self.usedFiscUnit.append(contentsOf: rentalUsedFiscUnit)
            }
            
            if let callback = callback {
                callback()
            }
            
        }
    }
    
    func loadFiscalCodeData(_ code: String){
        
        self.currentCode = code
        
        if !self.currentCode.isEmpty {
        
            self.fiscUnitIsSelected = true
            
            if let name = fiscUnitRefrence[self.currentCode] {
                
                self.fiscUnitDescription = "\(self.currentCode) \(name)"
                
                self.fiscUnitField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                return
            }
            
            self.fiscUnitField
                .removeClass(.isNok)
                .removeClass(.isOk)
                .class(.isLoading)
            
            API.v1.getFiscalUnit(code: self.currentCode) { resp in
                
                guard let resp = resp else {
                    self.fiscUnitField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                guard resp.status == .ok else {
                    self.fiscUnitField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                guard let data = resp.data else {
                    self.fiscUnitField
                        .removeClass(.isNok)
                        .removeClass(.isOk)
                        .removeClass(.isLoading)
                    return
                }
                
                self.fiscUnitField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                fiscUnitRefrence[self.currentCode] = data.value
                
                self.fiscUnitDescription = "\(self.currentCode) \(data.value)"
                
                self.fiscUnitIsSelected = true

            }
        }
        
    }
    
    func searcCode(){
        
        let term = self.fiscUnitDescription.pseudo.purgeSpaces
        
        Dispatch.asyncAfter(0.37) {
            
           if term != self.fiscUnitDescription.pseudo.purgeSpaces {
               return
           }
            
            var included: [String] = []
            
            self.resultBox.innerHTML = ""
            
            if term.isEmpty {
                /// Term is empty will load most used codes by default
                self.usedFiscUnit.forEach { code in
                    self.addCodeResult( term: term, code: code)
                }
                return
            }
            
            if term.count <= 3{
                
                // Is Exacly
                self.usedFiscUnit.forEach { code in
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
                self.usedFiscUnit.forEach { code in
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
                self.usedFiscUnit.forEach { code in
                    if !included.contains(code.c) {
                        if "\(code.c) \(code.v)".contains(term) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                // Is Exacly
                fiscUnitsBase.forEach { code in
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
                fiscUnitsBase.forEach { code in
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
                fiscUnitsBase.forEach { code in
                    if "\(code.c) \(code.v)".lowercased().contains(term) {
                        if !included.contains(code.c) {
                            included.append(code.c)
                            self.addCodeResult( term: term, code: code)
                        }
                    }
                }
                
                return
            }
            
            self.fiscUnitField
                .removeClass(.isNok)
                .removeClass(.isOk)
                .class(.isLoading)
            
            
            getFiscalUnits(term: term) { term, resp in
                
                self.fiscUnitField
                    .removeClass(.isNok)
                    .removeClass(.isOk)
                    .removeClass(.isLoading)
                
               if term != self.fiscUnitDescription.pseudo.purgeSpaces {
                   return
               }
                
                resp.forEach { code in
                    self.addCodeResult( term: term, code: code)
                }
            }
        }
    }
    
    func addCodeResult(term: String, code: APISearchResultsGeneral) {
        
        let resultBoxHtml = self.resultBox.innerHTML
        
        if resultBoxHtml.contains("fiscUnit_\(code.c)"){
            return
        }
        
        self.resultBox.appendChild(
            FiscResultView(type: .fiscUnit, term: term, data: code, callback: { data in
                self.resultBox.innerHTML = ""
                
                self.currentCode = data.c
                
                fiscCodeRefrence[data.c] = data.v
                
                self.fiscUnitDescription = "\(data.c) \(data.v)"
                
                self.fiscUnitField
                    .removeClass(.isNok)
                    .removeClass(.isLoading)
                    .class(.isOk)
                
                self.callback(data)
                
            }).margin(all: 0.px)
        )
    }
}
