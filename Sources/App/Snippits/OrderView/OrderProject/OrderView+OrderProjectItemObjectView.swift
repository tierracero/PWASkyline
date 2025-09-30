//
//  OrderView+OrderProjectItemObjectView.swift
//  
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderView {
    
    class OrderProjectItemObjectView: Div {
        
        override class var name: String { "div" }
     
        let object: CustOrderProjetcManagerItemObject
        
        init(
            object: CustOrderProjetcManagerItemObject
        ) {
            self.object = object
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var divContainer = Div()
            .margin(all: 3.px)
        
        @State var value = ""
        @State var checkBookState: Bool = false
        
        lazy var valueSelect = Select(self.$value)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
            .body {
                Option("Seleccione Opcion").value("")
            }
        
        lazy var valueField = InputText(self.$value)
            .placeholder(self.object.placeholder)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(31.px)
        
        lazy var valueArea = TextArea(self.$value)
            .placeholder(self.object.placeholder)
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .height(75.px)
        
        lazy var valueCheckbox = InputCheckbox().toggle(self.$checkBookState)
            
        
        @DOM override var body: DOM.Content {
            
            H2(self.object.actionName)
                .color({ self.object.isRequired ? .red : .white }())
            
            Div().clear(.both).height(3.px)
            
            P(self.object.helpText)
            
            Div().clear(.both).height(3.px)
            
            self.divContainer
            
            Div().clear(.both).height(3.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            custom("width", "calc(100% - 22px)")
            self.class(.uibtn)
            
            object.options.forEach { option in
                self.valueSelect.appendChild(Option(option).value(option))
            }
            
            switch object.type {
            case .textField:
                divContainer.appendChild(valueField)
            case .textArea:
                divContainer.appendChild(valueArea)
            case .checkBox:
                divContainer.appendChild(valueCheckbox)
                checkBookState = (object.value == "true")
            case .selection:
                divContainer.appendChild(valueSelect)
            case .radio:
                divContainer.appendChild(Div("RADIO NO SOPORTADO").color(.red))
            case .instruction:
                divContainer.appendChild(Div(object.value).color(.lightGrayTC))
            }
         
            value = object.value
            
            $value.listen {
                self.updateRealBalance(currentValue: $0)
            }
            
            $checkBookState.listen {
                if $0 {
                    self.value = "true"
                }
                else {
                    self.value = "false"
                }
            }
            
        }
        
        func updateRealBalance(currentValue: String) {
            
            Dispatch.asyncAfter(0.5) {
                
                guard currentValue == self.value else {
                    print("🔴 VALUE aint match")
                    return
                }
                
                API.custOrderV1.updateCustProjectItemValue(
                    itemId: self.object.id,
                    value: self.value
                ) { resp in
                
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    print("🟢 VALUE update")
                    
                }
            }
        }
    }
}

