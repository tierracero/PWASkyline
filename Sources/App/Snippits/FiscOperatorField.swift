//
//  FiscOperatorField.swift
//  
//
//  Created by Victor Cantu on 2/25/23.
//

import Foundation
import TCFundamentals
import Web

class FiscOperatorField: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ name: String,
        _ rfc: String,
        _ licence: String
    ) -> ())
    
    init(
        callback: @escaping ((
            _ name: String,
            _ rfc: String,
            _ licence: String
        ) -> ())
    ) {
        self.callback = callback
        
        super.init()
    }
    
    var operators: [CustFiscalOperator] = []
    
    var operatorsViewrefrence: [UUID: FiscOperatorFieldItem] = [:]
    
    var selctedId: UUID? = nil
    
    @State var term: String = ""
    
    @State var fiscUnitIsSelected: Bool = false
    
    lazy var codeField: InputText = InputText(self.$term)
        .placeholder("RFC")
        .class(.textFiledBlackDark)
        .width(93.percent)
        .onBlur {
            Dispatch.asyncAfter(7) {
                self.resultBox.innerHTML = ""
            }
        }
        .onFocus({ tf in
            
            tf.select()
            
            self.operators.forEach { `operator` in
                self.addCodeResult(operator: `operator`)
            }
        })
    
    let resultBox = Div()
        .backgroundColor(.transparentBlack)
        .borderRadius(12.px)
        .position(.absolute)
        .maxHeight(500.px)
        .margin(all: 0.px)
        .overflow(.auto)
        .width(550.px)
        .zIndex(1)
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        self.codeField
        self.resultBox
    }
    
    override func buildUI() {
        super.buildUI()
        
        API.fiscalV1.getFiscalOperators { resp in
            
            guard let resp else {
                showError(.comunicationError, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.generalError, resp.msg)
                return
            }
            
            guard let data = resp.data else {
                showError(.unexpectedResult, .unexpenctedMissingPayload)
                return
            }
            
            self.operators = data
            
        }
    }
    
    func addCodeResult(operator: CustFiscalOperator) {
    
        let view = FiscOperatorFieldItem(`operator`) { id, name,licence,rfc,expireAt in
            
            var operators: [CustFiscalOperator] = []
            
            self.operators.forEach { op in
                
                if op.id == id {
                    
                    operators.append(.init(
                        id: id,
                        name: name,
                        licence: licence,
                        rfc: rfc,
                        expireAt: expireAt
                    ))
                    
                    return
                }
                
                operators.append(op)
                
            }
            
            self.operators = operators
            
            if self.selctedId == id {
                
                self.callback(
                    name,
                    rfc,
                    licence
                )
                
            }
            
        }
        removeItem: {
            
            var operators: [CustFiscalOperator] = []
            
            self.operators.forEach { op in
                if `operator`.id == op.id {
                    return
                }
                operators.append(op)
            }
            
            self.operatorsViewrefrence[`operator`.id]?.remove()
            
            self.operatorsViewrefrence.removeValue(forKey: `operator`.id)
            
            self.operators = operators
            
        }
        .onClick {
            
            self.selctedId = `operator`.id
            
            guard let view = self.operatorsViewrefrence[`operator`.id] else {
                return
            }
            
            self.term = "\(view.rfc) \(view.name)"
            
            self.callback(
                view.name,
                view.rfc,
                view.licence
            )
            
            self.resultBox.innerHTML = ""
            
        }
        
        operatorsViewrefrence[`operator`.id] = view
        
        self.resultBox.appendChild(view)
        
    }
    
}


