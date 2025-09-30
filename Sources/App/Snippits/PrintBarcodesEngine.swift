//
//  PrintBarcodesEngine.swift
//  
//
//  Created by Victor Cantu on 11/23/22.
//

import Foundation

import Foundation
import TCFundamentals
import Web

class PrintBarcodesEngine: Div {
    
    let type: TypeOfBarcode
    
    let code: BarcodePrinting
    
    let printPrice: Bool
    
    let fontSize: Int
    
    let logo: String
    
    init(
        type: TypeOfBarcode,
        code: BarcodePrinting,
        printPrice: Bool,
        fontSize: Int,
        logo: String
    ) {
        self.type = type
        self.code = code
        self.printPrice = printPrice
        self.fontSize = fontSize
        self.logo = logo
    }

    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var logoContainer = Img()
        .src(self.logo)
        .objectFit(.contain)
        .width(100.percent)
        .height(100.percent)
    
    @DOM override var body: DOM.Content {
        Div{
            switch self.type {
            case .onlyBarcode:
                
                Div{
                    Svg()
                        .id(Id(stringLiteral: "barcodeContainer"))
                        .width(80.percent)
                }
                .align(.center)
            case .smallRectangled:
                Div{
                    
                    Div("\(self.code.brand) \(self.code.model)")
                        .overflow(.hidden)
                        .width(60.percent)
                        .float(.left)
                    
                    if self.printPrice {
                        Div(self.code.price.formatMoney)
                            .overflow(.hidden)
                            .width(36.percent)
                            .float(.right)
                    }
                    
                    Div()
                        .clear(.both)
                        .height(1.px)
                        .margin(all: 0.px)
                        .padding(all: 0.px)
                }
                
                Div{
                    Svg()
                        .id(Id(stringLiteral: "barcodeContainer"))
                        .width(80.percent)
                }
                .align(.center)
                
            case .rectangled:
                Div{
                    
                    Div("\(self.code.brand) \(self.code.model)")
                        .overflow(.hidden)
                        .width(60.percent)
                        .float(.left)
                    
                    if self.printPrice {
                        Div(self.code.price.formatMoney)
                            .overflow(.hidden)
                            .width(36.percent)
                            .float(.right)
                    }
                    
                    Div()
                        .clear(.both)
                        .height(1.px)
                        .margin(all: 0.px)
                        .padding(all: 0.px)
                }
                
                Div{
                    
                    Div("Marca: \(self.code.brand)")
                        .overflow(.hidden)
                        .width(60.percent)
                        .float(.left)
                    
                    if self.printPrice {
                        Div(self.code.price.formatMoney)
                            .overflow(.hidden)
                            .width(36.percent)
                            .float(.right)
                    }
                    
                    Div()
                        .clear(.both)
                        .height(1.px)
                        .margin(all: 0.px)
                        .padding(all: 0.px)
                }
                
                Div("Modelo: \(self.code.model)")
                    .overflow(.hidden)
                
                Div("Nombre: \(self.code.name)")
                    .overflow(.hidden)
                
                Div{
                    Svg()
                        .id(Id(stringLiteral: "barcodeContainer"))
                        .width(80.percent)
                }
                .align(.center)
                
            case .semiSquered:
                
                Div{
                    
                    Div{
                        Table {
                            Tr{
                                Td{
                                    self.logoContainer
                                }
                                .verticalAlign(.middle)
                                .align(.right)
                            }
                        }
                        .height(100.percent)
                    }
                    .overflow(.hidden)
                    .width(63.percent)
                    .float(.left)
                    
                    if self.printPrice {
                        Div(self.code.price.formatMoney)
                            .overflow(.hidden)
                            .width(36.percent)
                            .float(.right)
                    }
                    
                }
                
                Div()
                    .clear(.both)
                    .height(1.px)
                    .margin(all: 0.px)
                    .padding(all: 0.px)
                
                Div{
                    
                    Div("\(self.code.brand) \(self.code.model)")
                        .overflow(.hidden)
                        .width(60.percent)
                        .float(.left)
                    
                    Div()
                        .clear(.both)
                        .height(1.px)
                        .margin(all: 0.px)
                        .padding(all: 0.px)
                    
                    Div("Marca: \(self.code.brand)")
                        .overflow(.hidden)
                        .width(60.percent)
                        .float(.left)
                    
                    if self.printPrice {
                        Div(self.code.price.formatMoney)
                            .overflow(.hidden)
                            .width(36.percent)
                            .float(.right)
                    }
                    
                    Div()
                        .clear(.both)
                        .height(1.px)
                        .margin(all: 0.px)
                        .padding(all: 0.px)
                }
                
                Div("Modelo: \(self.code.model)")
                    .overflow(.hidden)
                
                Div("Nombre: \(self.code.name)")
                    .overflow(.hidden)
                
                Div{
                    Svg()
                        .id(Id(stringLiteral: "barcodeContainer"))
                        .width(80.percent)
                }
                .align(.center)
                
                
            case .longRectangled:
                
                Div{
                    Table {
                        Tr{
                            Td{
                                self.logoContainer
                            }
                            .verticalAlign(.middle)
                            .align(.right)
                        }
                    }
                    .height(100.percent)
                }
                .width(30.percent)
                .float(.left)
                
                Div{
                    
                    Div{
                        
                        Div("MARCA: \(self.code.brand)")
                            .overflow(.hidden)
                        
                        if self.printPrice {
                            Div("PRECIO: \(self.code.price.formatMoney)")
                                .overflow(.hidden)
                        }
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{

                        Div("MODELO: \(self.code.model)")
                            .overflow(.hidden)
                        
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    if !self.code.name.isEmpty {
                        
                        Div().clear(.both).marginTop(3.px)
                        
                        Div("Nombre: \(self.code.name)")
                            .overflow(.hidden)
                        
                    }
                    
                    Div().clear(.both).marginTop(7.px)
                    
                    Div{
                        Svg()
                            .id(Id(stringLiteral: "barcodeContainer"))
                            .width(80.percent)
                    }
                    .align(.center)
                    
                }
                .width(69.percent)
                .float(.left)
                
            }
        }
        .fontSize(fontSize.px)
    }
    
    override func buildUI() {
        super.buildUI()
    }
}


