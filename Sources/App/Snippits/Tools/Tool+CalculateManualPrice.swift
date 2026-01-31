//
//  Tool+CalculateManualPrice.swift
//  
//
//  Created by Victor Cantu on 10/15/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView {
    
    class CalculateManualPrice: Div {
        
        override class var name: String { "div" }
        
        let cost: Int64
        
        private var callback: ((
            _ pricea: Double,
            _ priceb: Double,
            _ pricec: Double
        ) -> ())
        
        init(
            cost: Int64,
            callback: @escaping ((
                _ pricea: Double,
                _ priceb: Double,
                _ pricec: Double
            ) -> ())
        ) {
            self.cost = cost
            self.callback = callback
            
            super.init()
        }
         
        required init() {
            fatalError("init() has not been implemented")
        }
        
        
        @State var priceaSugestion = ""
        
        @State var pricebSugestion = ""
        
        @State var pricecSugestion = ""
        
        @State var priceaPercent = "50"
        
        @State var pricebPercent = "40"
        
        @State var pricecPercent = "30"
        
        lazy var priceaField = InputText(self.$priceaPercent)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .placeholder("0 ~ 1000")
            .textAlign(.right)
            .height(28.px)
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
        
        lazy var pricebField = InputText(self.$pricebPercent)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .placeholder("0 ~ 1000")
            .textAlign(.right)
            .height(28.px)
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
        
        lazy var pricecField = InputText(self.$pricecPercent)
            .custom("width", "calc(100% - 16px)")
            .class(.textFiledBlackDark)
            .placeholder("0 ~ 1000")
            .textAlign(.right)
            .height(28.px)
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
                    
                    H2("Calculo Manual")
                        .color(.lightBlueText)
                        .float(.left)
                        .marginLeft(7.px)
                    
                    Div().class(.clear)
                    
                    Div()
                        .height(12.px)
                        .clear(.both)
                    
                    Div{
                        H2("Costo")
                            .color(.white)
                            .float(.left)
                        
                        H2(self.cost.formatMoney)
                            .color(.white)
                            .float(.right)
                    }
                    
                    Div()
                        .height(12.px)
                        .clear(.both)
                    
                    /// Price A
                    Div{
                        Label("Precio A")
                            .color(.white)
                        
                        Div()
                            .clear(.both)
                            .height(3.px)
                        
                        Div{
                            self.priceaField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div(self.$priceaSugestion.map{ $0.isEmpty ? " - - " : $0 })
                                .color(.lightBlueText)
                                .marginRight(12.px)
                                .textAlign(.right)
                                .fontSize(28.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div()
                            .clear(.both)
                            .height(7.px)
                    }
                    
                    Div()
                        .height(12.px)
                        .clear(.both)
                    
                    /// Price B
                    Div{
                        Label("Precio B")
                            .color(.white)
                        
                        Div()
                            .clear(.both)
                            .height(3.px)
                        
                        Div{
                            self.pricebField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div(self.$pricebSugestion.map{ $0.isEmpty ? " - - " : $0 })
                                .color(.lightBlueText)
                                .marginRight(12.px)
                                .textAlign(.right)
                                .fontSize(28.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div()
                            .clear(.both)
                            .height(7.px)
                    }
                    
                    Div()
                        .height(12.px)
                        .clear(.both)
                    
                    /// Price C
                    Div{
                        Label("Precio C")
                            .color(.white)
                        
                        Div()
                            .clear(.both)
                            .height(3.px)
                        
                        Div{
                            self.pricecField
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div{
                            Div(self.$pricecSugestion.map{ $0.isEmpty ? " - - " : $0 })
                                .color(.lightBlueText)
                                .marginRight(12.px)
                                .textAlign(.right)
                                .fontSize(28.px)
                        }
                        .width(50.percent)
                        .float(.left)
                        
                        Div()
                            .clear(.both)
                            .height(7.px)
                    }
                    
                    Div("Modificar")
                        .class(.uibtnLargeOrange)
                        .textAlign(.center)
                        .width(95.percent)
                        .onClick {
                            self.modifyPercentage()
                        }
                    
                }
            }
            .backgroundColor(.backGroundGraySlate)
            .custom("left", "calc(50% - 150px)")
            .custom("top", "calc(50% - 175px)")
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(350.px)
            .width(300.px)
            
        }
        
        override func buildUI() {
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            $priceaPercent.listen {
                self.calca()
            }
            
            $pricebPercent.listen {
                self.calcb()
            }
            
            $pricecPercent.listen {
                self.calcc()
            }
            
            calca()
            calcb()
            calcc()
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
            priceaField.select()
        }
        
        func calca(){
            
            let _cost = cost.toDouble / 100
            
            guard var percent = Double(priceaPercent.replace(from: ",", to: "")) else {
                return
            }
            
            percent = (percent / 100)
            
            priceaSugestion = (_cost + (_cost * percent)).formatMoney
            
        }
        
        func calcb(){
            
            let _cost = cost.toDouble / 100
            
            guard var percent = Double(pricebPercent.replace(from: ",", to: "")) else {
                return
            }
            
            percent = (percent / 100)
            
            pricebSugestion = (_cost + (_cost * percent)).formatMoney
            
        }
        
        func calcc(){
            
            let _cost = cost.toDouble / 100
            
            guard var percent = Double(pricecPercent.replace(from: ",", to: "")) else {
                return
            }
            
            percent = (percent / 100)
            
            pricecSugestion = (_cost + (_cost * percent)).formatMoney
            
        }
        
        func modifyPercentage(){
            
            let _cost = cost.toDouble / 100
            
            guard var percent = Double(priceaPercent.replace(from: ",", to: "")) else {
                showError(.generalError, "Ingrese porcentaje valido.")
                priceaField.select()
                return
            }
            
            percent = (percent / 100)
            
            let pricea = (_cost + (_cost * percent))
            
            guard var percent = Double(pricebPercent.replace(from: ",", to: "")) else {
                showError(.generalError, "Ingrese porcentaje valido.")
                pricebField.select()
                return
            }
            
            percent = (percent / 100)
            
            let priceb = (_cost + (_cost * percent))
            
            guard var percent = Double(pricecPercent.replace(from: ",", to: "")) else {
                showError(.generalError, "Ingrese porcentaje valido.")
                pricecField.select()
                return
            }
            
            percent = (percent / 100)
            
            let pricec = (_cost + (_cost * percent))
            
            self.callback(pricea, priceb, pricec)
            
            self.remove()
            
        }
        
    }
}
