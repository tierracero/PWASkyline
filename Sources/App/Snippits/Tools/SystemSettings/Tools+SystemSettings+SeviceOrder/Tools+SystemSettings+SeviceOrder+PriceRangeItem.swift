//
//  Tools+SystemSettings+SeviceOrder+PriceRangeItem.swift
//  
//
//  Created by Victor Cantu on 9/11/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.SeviceOrder {
    
    class PriceRangeItem: Div {
        
        override class var name: String { "div" }
        
        let rangeNumber: Int
        
        var currentLastRange: State<UUID?>
        
        private var callback: ((
        ) -> ())
        
        @State var id: UUID
        @State var lowerRange: String
        @State var upperRange: String
        @State var pricea: String
        @State var priceb: String
        @State var pricec: String
        
        init(
            rangeNumber: Int,
            currentLastRange: State<UUID?>,
            item: ConfigStoreProcessingPriceRange,
            callback: @escaping ( (
            ) -> ())
        ) {
            self.rangeNumber = rangeNumber
            self.currentLastRange = currentLastRange
            self.id = item.id
            self.lowerRange = item.lowerRange.formatMoney
            self.upperRange = (item.upperRange == 0) ? "" : item.upperRange.formatMoney
            self.pricea = (item.pricea == 0) ? "" : item.pricea.formatMoney
            self.priceb = (item.priceb == 0) ? "" : item.priceb.formatMoney
            self.pricec = (item.pricec == 0) ? "" : item.pricec.formatMoney
            self.callback = callback
            
            super.init()
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        lazy var lowerRangeField = InputText(self.$lowerRange)
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .width(85.percent)
            .placeholder("0.00")
            .disabled(true)
            .opacity(0.5)
        
        lazy var upperRangeField = InputText(self.$upperRange)
            .disabled(self.currentLastRange.map{ $0 != self.id })
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .width(85.percent)
            .placeholder("0.00")
        
        lazy var priceaField = InputText(self.$pricea)
            .disabled(self.currentLastRange.map{ $0 != self.id })
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .width(90.percent)
            .marginTop(3.px)
            .placeholder("0")
        
        lazy var pricebField = InputText(self.$priceb)
            .disabled(self.currentLastRange.map{ $0 != self.id })
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .width(90.percent)
            .marginTop(3.px)
            .placeholder("0")
        
        lazy var pricecField = InputText(self.$pricec)
            .disabled(self.currentLastRange.map{ $0 != self.id })
            .onFocus { tf in tf.select() }
            .class(.textFiledBlackDark)
            .textAlign(.right)
            .width(90.percent)
            .marginTop(3.px)
            .placeholder("0")
        
        @State var middleRange: Int64 = 0
        
        @State var rangeText: String = ""
        
        @State var priceaCalc: String = ""
        
        @State var pricebCalc: String = ""
        
        @State var pricecCalc: String = ""
        
        @DOM override var body: DOM.Content {
            
            Div{
                
                Div{
                    // Rango #
                    Div{
                    
                        Img()
                            .closeButton(.subView)
                            .hidden(self.currentLastRange.map{ $0 != self.id })
                            .marginRight(0.px)
                            .width(18.px)
                            .onClick {
                                self.callback()
                            }
                        
                        H4("Rango \(self.rangeNumber.toString)")
                            .color(.yellowTC)
                            .marginRight(7.px)
                            .float(.left)
                        
                        
                        H4(self.$rangeText)
                            .color(.lightGray)
                            .marginRight(7.px)
                            .float(.left)
                        
                        Div().clear(.both)
                        
                    }
                    .marginBottom(7.px)
                    
                    // Rango Inferior
                    Div{
                        Div("Inferior")
                            .color(.white)
                        .width(50.percent)
                        .float(.left)
                        Div{
                            self.lowerRangeField
                        }
                        .width(50.percent)
                        .float(.left)
                        Div().clear(.both)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    // Rango Superior
                    Div{
                        Div("Superior")
                            .color(.white)
                        .width(50.percent)
                        .float(.left)
                        Div{
                            self.upperRangeField
                        }
                        .width(50.percent)
                        .float(.left)
                        Div().clear(.both)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both)
                    
                }
                .marginBottom(3.px)
                
                H3("Porcentajes de Ganacia")
                    .marginBottom(3.px)
                    .color(.lightBlueText)
                
                Div{
                    
                    Div(self.$middleRange.map{ ($0 == 0) ? "Ingrese rango superiror para calcular" : " Ejemplo de precio: $\($0.formatMoney)" })
                    .marginTop(7.px)
                    .color(.white)
                    
                    Div{
                        
                        Div{
                            Label("% Precio A")
                                .color(.lightGray)
                                .marginTop(3.px)
                            
                            self.priceaField
                            
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Label("% Precio B")
                                .color(.lightGray)
                                .marginTop(3.px)
                            
                            self.pricebField
                            
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Label("% Precio C")
                                .color(.lightGray)
                                .marginTop(3.px)
                            
                            self.pricecField
                            
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                            
                    }
                    
                    Div{
                        
                        Div{
                            Div(self.$priceaCalc.map{ $0.isEmpty ? "--" : $0 })
                                .textAlign(self.$priceaCalc.map{ $0.isEmpty ? .center : .right })
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Div(self.$pricebCalc.map{ $0.isEmpty ? "--" : $0 })
                                .textAlign(self.$pricebCalc.map{ $0.isEmpty ? .center : .right })
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div{
                            Div(self.$pricecCalc.map{ $0.isEmpty ? "--" : $0 })
                                .textAlign(self.$pricecCalc.map{ $0.isEmpty ? .center : .right })
                        }
                        .width(33.percent)
                        .float(.left)
                        
                        Div().clear(.both)
                    }
                    .marginTop(3.px)
                    .color(.gray)
                    
                }
                
            }
            .padding(all: 7.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            backgroundColor(.init(r: 57, g: 62, b: 70))
            borderRadius(7.px)
            margin(all: 7.px)
            
            $upperRange.listen {
                self.calcMiddleRange()
            }
            
            $pricea.listen {
                self.calcRangeA()
            }
            
            $priceb.listen {
                self.calcRangeB()
            }
            
            $pricec.listen {
                self.calcRangeC()
            }
            
            calcMiddleRange()
            
        }
        
        func calcMiddleRange(){
            
            rangeText = ""
            
            priceaCalc = ""
            
            pricebCalc = ""
            
            pricecCalc = ""
            
            middleRange = 0
            
            if upperRange.isEmpty {
                return
            }
            
            guard let lower = Double(lowerRange.replace(from: ",", to: "")) else {
                return
            }
            
            guard let higher = Double(upperRange.replace(from: ",", to: "")) else {
                return
            }
            
            guard higher > lower else{
                return
            }
            
            middleRange = (higher - ((higher - lower) / 2.toDouble)).toCents
            
            rangeText = "\(lower.formatMoney) ~ \(higher.formatMoney)"
            
            calcRangeA()
            
            calcRangeB()
            
            calcRangeC()
        }
        
        func calcRangeA(){
            priceaCalc = ""
            if middleRange == 0 {
                return
            }
            
            guard var percent = Double(self.pricea.replace(from: ",", to: "")) else {
                return
            }
            
            percent = percent / 100
            
            priceaCalc = PriceRanger.calculateRevenuePercent(
                baseCost: middleRange,
                percent: percent
            ).formatMoney
            
        }
        
        func calcRangeB(){
            pricebCalc = ""
            if middleRange == 0 {
                return
            }
            guard var percent = Double(self.priceb.replace(from: ",", to: "")) else {
                return
            }
            percent = percent / 100
            
            pricebCalc = PriceRanger.calculateRevenuePercent(
                baseCost: middleRange,
                percent: percent
            ).formatMoney
        }
        
        func calcRangeC(){
            
            pricecCalc = ""
            if middleRange == 0 {
                return
            }
            guard var percent = Double(self.pricec.replace(from: ",", to: "")) else {
                return
            }
            percent = percent / 100
            
            pricecCalc = PriceRanger.calculateRevenuePercent(
                baseCost: middleRange,
                percent: percent
            ).formatMoney
        }
        
    }
}

