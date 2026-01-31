//
//  OrderView+OrderProjectChargeView.swift
//
//
//  Created by Victor Cantu on 10/3/24.
//

import Foundation
import TCFundamentals
import Web

extension OrderView {
    
    class OrderProjectChargeView: Div {
        
        override class var name: String { "div" }
        
        let charge: CustOrderProjetcManagerCharge
        
        private let updatePrice: (() -> ())
        
        init(
            charge: CustOrderProjetcManagerCharge,
            updatePrice: @escaping () -> Void
        ) {
            self.charge = charge
            self.updatePrice = updatePrice
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var estimetadCalculation: String = "0.00"
        
        @State var realCost: String = ""
        
        @State var realUnits: String = ""
        
        @State var realCalculation: String = "0.00"
        
        lazy var realCostField = InputText(self.$realCost)
            .placeholder("0.00")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
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
        
        lazy var realUnitsField = InputText(self.$realUnits)
            .placeholder("0.00")
            .custom("width","calc(100% - 24px)")
            .class(.textFiledBlackDark)
            .textAlign(.right)
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
                H2(self.charge.name)
            }
            .class(.oneLineText)
            .width(40.percent)
            .float(.left)
            
            Div{
                H2(self.charge.estimatedUnits.toString)
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.gray)
            
            Div{
                H2(self.charge.estimatedCost.formatMoney)
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.gray)
            
            Div{
                H2((self.charge.estimatedCost * self.charge.estimatedUnits.toInt64).formatMoney)
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.gray)
            
            Div{
                self.realUnitsField
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.white)
            
            Div{
                self.realCostField
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.white)
            
            Div{
                H2(self.$realCalculation)
            }
            .width(10.percent)
            .align(.right)
            .float(.left)
            .color(.white)
            
            Div().clear(.both)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            custom("width", "calc(100% - 22px)")
            
            self.class(.uibtn)
            
            realUnits = charge.realUnits.toString
            
            realCost = charge.realCost.formatMoney
            
            calcRealBalance()
            
            $realCost.listen {
                
                guard let units = Int(self.realUnits.replace(from: ",", to: "")) else {
                    print("🔴 realUnits \(self.realUnits)")
                    return
                }
                
                guard let cost = Double(self.realCost.replace(from: ",", to: "")) else {
                    print("🔴 realUnits \(self.realCost)")
                    return
                }
                
                self.updateRealBalance(currentUnits: units, currentCost: cost.toCents)
                
                self.calcRealBalance()
                
                
            }
            
            $realUnits.listen {
                
                guard let units = Int(self.realUnits.replace(from: ",", to: "")) else {
                    print("🔴 realUnits \(self.realUnits)")
                    return
                }
                
                guard let cost = Double(self.realCost.replace(from: ",", to: "")) else {
                    print("🔴 realUnits \(self.realCost)")
                    return
                }
                
                self.updateRealBalance(currentUnits: units, currentCost: cost.toCents)
                
                self.calcRealBalance()
            }
            
            
        }
        
        func calcRealBalance() {
            
            realCalculation = "0.00"
            
            guard let units = Int(realUnits.replace(from: ",", to: "")) else {
                print("🔴 realUnits \(realUnits)")
                return
            }
            
            guard let cost = Double(realCost.replace(from: ",", to: "")) else {
                print("🔴 realUnits \(realCost)")
                return
            }
            
            realCalculation = (units.toDouble * cost).formatMoney
            
            updatePrice()
            
        }
        
        func updateRealBalance(currentUnits: Int, currentCost: Int64) {
            
            Dispatch.asyncAfter(0.5) {
                
                guard let units = Int(self.realUnits.replace(from: ",", to: "")) else {
                    print("🔴 realUnits \(self.realUnits)")
                    return
                }
                
                guard let cost = Double(self.realCost.replace(from: ",", to: ""))?.toCents else {
                    print("🔴 realUnits \(self.realCost)")
                    return
                }
                
                guard units == currentUnits else {
                    print("🔴 units aint match")
                    return
                }
                
                guard cost == currentCost else {
                    print("🔴 cost aint match")
                    return
                }
                
                API.custOrderV1.updateCustProjectCharge(
                    chargeId: self.charge.id,
                    units: units,
                    cost: cost
                ) { resp in
                
                    guard let resp else {
                        showError(.comunicationError, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.generalError, resp.msg)
                        return
                    }
                    
                    print("🟢 charge update")
                    
                }
            }
        }
    }
}
