//
//  OrderView+AddNewOrderProjectChargeView.swift
//  
//
//  Created by Victor Cantu on 10/4/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension OrderView {
    
    class AddNewOrderProjectChargeView: Div {
        
        override class var name: String { "div" }
        
        var projectId: UUID
        
        private var callback: ((
            _ charge: CustOrderProjetcManagerCharge
        ) -> ())
        
        init(
            projectId: UUID,
            callback: @escaping ((
                _ charge: CustOrderProjetcManagerCharge
            ) -> ())
        ) {
            self.projectId = projectId
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var name: String = ""
        
        @State var units: String = ""
        
        @State var cost: String = ""
        
        lazy var nameField = InputText(self.$name)
            .placeholder("Nombre del Cargo")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)

            .onFocus { tf in
                tf.select()
            }
        
        lazy var unitsField = InputText(self.$units)
            .placeholder("Unidades")
            .custom("width","calc(100% - 24px)")
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
            .onFocus { tf in
                tf.select()
            }
        
        lazy var costField = InputText(self.$cost)
            .placeholder("Precio")
            .custom("width","calc(100% - 24px)")
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
            .onFocus { tf in
                tf.select()
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
                    
                    H2("Agregar Tarea")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                }
                
                Div().clear(.both)
                
                Div{
                    
                    Div{
                        Div("Nombre")
                            .margin(all: 3.px)
                            .height(31.px)
                        
                        Div().clear(.both)
                    
                        Div("Unidades")
                            .margin(all: 3.px)
                            .height(31.px)
                    
                        Div("Precio")
                            .margin(all: 3.px)
                            .height(31.px)
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .color(.white)
                    .float(.left)
                    
                    Div{
                        
                        self.nameField
                        
                        Div().clear(.both).height(3.px)
                        
                        self.unitsField
                        
                        Div().clear(.both).height(3.px)
                        
                        self.costField
                        
                        Div().clear(.both).height(3.px)
                        
                    }
                    .height(100.percent)
                    .width(50.percent)
                    .float(.left)
                    
                }
                .custom("height", "calc(100% - 85px)")
                .overflow(.auto)
                .marginTop(7.px)
                
                Div{
                    Div("Agregar Cargo")
                        .class(.uibtnLargeOrange)
                        .onClick {
                            self.addCharge()
                        }
                }
                .marginTop(3.px)
                .align(.right)
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 207px)")
            .custom("top", "calc(50% - 107px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(200.px)
            .width(400.px)
        }
        
        override func buildUI() {
            super.buildUI()
            self.class(.transparantBlackBackGround)
            height(100.percent)
            width(100.percent)
            position(.fixed)
            left(0.px)
            top(0.px)
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
        
        func addCharge(){
            
            guard !name.isEmpty else {
                showError(.generalError, "Ingrese nombre del cargo")
                nameField.select()
                return
            }
            
            guard let units = Int(units) else {
                showError(.generalError, "Ingrese unidades validas")
                unitsField.select()
                return
            }
            
            guard let cost = Double(cost)?.toCents else {
                showError(.generalError, "Ingrese costo valido")
                unitsField.select()
                return
            }
            
            loadingView(show: true)
            
            API.custOrderV1.addCustProjectCharge(
                projectId: projectId,
                units: units,
                cost: cost,
                name: name
            ) { resp in
                
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
                
                self.callback(payload)
                
                self.remove()
                
            }
        }
    }
}
