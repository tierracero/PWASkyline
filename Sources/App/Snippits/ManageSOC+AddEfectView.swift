//
//  ManageSOC+AddEfectView.swift
//
//
//  Created by Victor Cantu on 11/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManageSOCView {
    
    class AddEfectView: Div {
        
        override class var name: String { "div" }
        
        let codeType: SOCCodeType
        
        let currentEfect: [CustSOCCodeStratergy]
        
        private var callback: ((
            _ efect: CustSOCCodeStratergy
        ) -> ())
        
        init(
            codeType: SOCCodeType,
            currentEfect: [CustSOCCodeStratergy],
            callback: @escaping (_: CustSOCCodeStratergy) -> Void
        ) {
            self.codeType = codeType
            self.currentEfect = currentEfect
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        @State var allefect: [CustSOCCodeStratergy] = []
        
        @State var efect: CustSOCCodeStratergy? =  nil
        
        @State var isCompatible: Bool = false
        
        @State var unCompatibleReason = ""
        
        @DOM override var body: DOM.Content {
            
            /// Product Detail View
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView3)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Agergar Efecto")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                
                Div{
                    
                    Div{
                        ForEach(self.$allefect){ _efect in
                            Div(_efect.description).class(.uibtnLarge)
                                .border(width: .medium, style: self.$efect.map{ ($0 != _efect) ? .none : .solid }, color: .lightBlue )
                                .width(90.percent)
                                .marginTop(7.px)
                                .onClick {
                                    self.efect = _efect
                                }
                        }
                    }
                    .custom("height", "calc(100% - 14px)")
                    .class(.roundDarkBlue)
                    .padding(all: 7.px)
                    .overflow(.auto)
                }
                .custom("height", "calc(100% - 35px)")
                .width(40.percent)
                .float(.left)
                
                Div{
                    Div{
                        Table().noResult(label: "🗳 Seleccione efecto para continuar")
                            .hidden(self.$efect.map{ $0 != nil })
                        
                        Div{
                            Div{
                             
                                H1(self.$efect.map{ $0?.description ?? "Seleccione Efecto" })
                                    
                                Div().height(7.px).clear(.both)
                                
                                H2(self.$efect.map{ $0?.helpText ?? "Seleccione Efecto" })
                                    .color(.lightGray)
                            }
                            .custom("height", "calc(100% - 50px)")
                            
                            Div{
                                
                                Span(self.$unCompatibleReason)
                                    .hidden(self.$isCompatible)
                                    .color(.gray)
                                Div("+ Agregar")
                                    .hidden(self.$isCompatible.map{ !$0 })
                                    .class(.uibtnLargeOrange)
                                    .onClick {
                                        self.addSocEfect()
                                    }
                                    
                            }
                            .align(.right)
                        }
                        .hidden(self.$efect.map{ $0 == nil })
                        .height(100.percent)
                    }
                    .custom("height", "calc(100% - 14px)")
                    .padding(all: 7.px)
                    .class(.roundBlue)
                    .marginLeft(7.px)
                }
                .custom("height", "calc(100% - 35px)")
                .width(60.percent)
                .float(.left)
                
            }
            .custom("left", "calc(50% - 374px)")
            .custom("top", "calc(50% - 224px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(400.px)
            .width(700.px)
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
            
            CustSOCCodeStratergy.allCases.forEach { _efect in
                
                if let accountId = tcaccount?.id {
                    if let linkedIds = _efect.relatedAccount {
                        guard linkedIds.contains(accountId) else {
                            return
                        }
                    }
                }
                
                allefect.append(_efect)
                
            }
            
            $efect.listen {
                
                self.isCompatible = false
                self.unCompatibleReason = ""
                
                guard let efect = $0 else {
                    self.unCompatibleReason = "No se puedo obtener el codigo, contacte a Soporte TC"
                    return
                }
                
                if !efect.compatibility.contains(self.codeType) {
                    self.unCompatibleReason = "El codigo es compatibe con un Codigo de Servicio tipo \(self.codeType.description)"
                    return
                }
                
                if self.currentEfect.contains(efect) {
                    self.unCompatibleReason = "Este codigo ya esta activo"
                    return
                }
                
                if !efect.available {
                    self.unCompatibleReason = "Este codigo no esta disponible aun, si le interesa usar lo contacte a Soporte TC"
                    return
                }
                
                self.isCompatible = true
                
            }
            
        }
        
        func addSocEfect(){
            
            self.isCompatible = false
            self.unCompatibleReason = ""
            
            guard let efect else {
                self.unCompatibleReason = "No se puedo obtener el codigo, contacte a Soporte TC"
                return
            }
            
            if !efect.compatibility.contains(self.codeType) {
                self.unCompatibleReason = "El codigo es compatibe con un Codigo de Servicio tipo \(self.codeType.description)"
                return
            }
            
            if self.currentEfect.contains(efect) {
                self.unCompatibleReason = "Este codigo ya esta activo"
                return
            }
            
            if !efect.available {
                self.unCompatibleReason = "Este codigo no esta disponible aun, si le interesa usar lo contacte a Soporte TC"
                return
            }
            
            self.callback(efect)
            
            self.remove()
            
        }
    }
}
