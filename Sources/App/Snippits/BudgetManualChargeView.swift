//
//  BudgetManualChargeView.swift
//  
//
//  Created by Victor Cantu on 10/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class BudgetManualChargeView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ units: Int64,
        _ description: String,
        _ price: Int64,
        _ cost: Int64
    ) -> ())
    
    private var removeCharge: ((
    ) -> ())
    
    init(
        callback: @escaping ((
            _ units: Int64,
            _ description: String,
            _ price: Int64,
            _ cost: Int64
        ) -> ()),
        removeCharge: @escaping ((
        ) -> ())
    ) {
        self.callback = callback
        self.removeCharge = removeCharge
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var units = ""
    
    @State var descr = ""
    
    @State var price = ""
    
    @State var cost = ""
    
    @State var removeButtonIsHidden = true
    
    lazy var unitsField = InputText(self.$units)
        .class(.textFiledBlackDarkLarge)
        .placeholder("1")
        .width(200.px)
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
        .onEnter {
            self.descriptionField.select()
        }
    
    lazy var descriptionField =  InputText(self.$descr)
        .class(.textFiledBlackDarkLarge)
        .placeholder("Nombre del cargo")
        .width(270.px)
        .onFocus { tf in
            tf.select()
        }
        .onEnter {
            self.priceField.select()
        }
    
    lazy var priceField = InputText(self.$price)
        .class(.textFiledBlackDarkLarge)
        .placeholder("0.00")
        .width(160.px)
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
        .onEnter {
            self.costField.select()
        }
    
    lazy var costField =  InputText(self.$cost)
        .class(.textFiledBlackDarkLarge)
        .placeholder("0.00")
        .width(200.px)
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
        .onEnter {
            
        }
        
    @DOM override var body: DOM.Content {
        Div{
        
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView3)
                    .onClick{
                        self.remove()
                    }
                
                
                H2("Cargo Manual")
                    .color(.lightBlueText)
                    .float(.left)
            }
            
            Div().class(.clear).height(7.px)
            
            /// Units
            Div{
                Label("Cantidad")
                    .color(.lightGray)
                Div{
                    self.unitsField
                }
            }
            .class(.section)
            
            /// Description
            Div{
                Label("Descripcion")
                    .color(.lightGray)
                Div{
                    self.descriptionField
                }
            }
            .class(.section)
            
            /// Price
            Div{
                Label("Precio")
                    .color(.white)
                Div{
                    
                    self.priceField
                    
                    Div("-16")
                        .margin(all: 0.px)
                        .fontSize(20.px)
                        .color(.white)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            guard let _price = Double(self.price.replace(from: ",", to: "")) else {
                                self.unitsField.select()
                                showError(.generalError, "Ingrese precio valido")
                                return
                            }
                            
                            var _tax = Double(taxCalculator(
                                trasladados: 160,
                                cents: _price.toCents
                            ))
                            print(_tax)
                            //_tax = (_tax / 10000.toDouble).rounded() * 10000.toDouble
                            
                            self.price = (_tax / 100).formatMoney
                            
                            //self.price = (_price - (_price * 0.16)).formatMoney
                            
                        }
                    
                    Div("+16")
                        .margin(all: 0.px)
                        .marginRight(12.px)
                        .fontSize(20.px)
                        .color(.white)
                        .float(.right)
                        .class(.uibtn)
                        .onClick {
                            
                            guard let _price = Double(self.price.replace(from: ",", to: "")) else {
                                self.unitsField.select()
                                showError(.generalError, "Ingrese precio valido")
                                return
                            }
                            
                            self.price = (_price * 1.16).formatMoney
                            
                        }
                }
            }
            .class(.section)
            
            /// Cost
            Div{
                Label("Cost")
                    .color(.lightGray)
                Div{
                    self.costField
                    
                }
            }
            .class(.section)
            
            Div().class(.clear)
            
            Div{
                
                Div{
                    
                    Img()
                        .cursor(.pointer)
                        .src("/skyline/media/cross.png")
                        .height(18.px)
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .onClick { img, event in
                            
                        }
                 
                    Span("Eliminar Cargo")
                }
                .hidden(self.$removeButtonIsHidden)
                .class(.uibtn)
                .float(.left)
                .onClick {
                    if self.removeButtonIsHidden {
                        return
                    }
                    self.removeCharge()
                    self.remove()
                }
                
                Div{
                    
                    Img()
                        .cursor(.pointer)
                        .src("/skyline/media/add.png")
                        .height(18.px)
                        .padding(all: 3.px)
                        .paddingRight(0.px)
                        .onClick { img, event in
                            
                        }
                 
                    Span( self.$removeButtonIsHidden.map{ $0 ? "Agergar Cargo" : "Guardar Cambios" } )
                }
                .class(.uibtn)
                .float(.right)
                .onClick {
                    self.addCharge()
                }
            }
            .align(.right)
            
        }
        .custom("left", "calc(50% - 225px)")
        .custom("top", "calc(50% - 150px)")
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .width(450.px)
        
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
    
    override func didAddToDOM(){
        super.didAddToDOM()
        self.unitsField.select()
    }
    
    func addCharge(){
        guard let _units = Float(self.units.replace(from: ",", to: ""))?.toCents else {
            self.unitsField.select()
            showError(.generalError, "Ingrese Unidades valido")
            return
        }
        
        if self.descr.isEmpty {
            self.descriptionField.select()
            showError(.generalError, "Ingrese Description")
            return
        }
        
        guard let _price = Float(self.price.replace(from: ",", to: ""))?.toCents else {
            self.unitsField.select()
            showError(.generalError, "Ingrese precio valido")
            return
        }
        
        let _cost = (Float(self.cost.replace(from: ",", to: "")) ?? 0).toCents
        
        self.callback(
            _units,
            descr,
            _price,
            _cost
        )
        
        self.remove()
        
    }
    
}
