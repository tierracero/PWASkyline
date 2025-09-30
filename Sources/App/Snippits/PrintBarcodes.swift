//
//  PrintBarcodes.swift
//  
//
//  Created by Victor Cantu on 11/23/22.
//

import TCFundamentals
import Foundation
import Web

class PrintBarcodes: Div {
    
    override class var name: String { "div" }
    
    var barodes: [BarcodePrinting]
    
    init(
        barodes: [BarcodePrinting]
    ) {
        self.barodes = barodes
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var printPrice: Bool = true
    
    @State var mode: TypeOfBarcode = .onlyBarcode
    
    @State var modeListener: String = TypeOfBarcode.onlyBarcode.rawValue
    
    @State var fontSize: String = "12"
    
    lazy var barcodeGrid = Div()
        .custom("height", "calc(100% - 180px)")
        .padding(all: 7.px)
        .class(.roundBlue)
    
    lazy var priceCheckbox = InputCheckbox().toggle(self.$printPrice)
    
    lazy var modeSelect = Select(self.$modeListener)
        .custom("width","calc(100% - 24px)")
        .class(.textFiledBlackDark)
        .height(31.px)
    
    lazy var fontSizeField = InputText(self.$fontSize)
        .class(.textFiledBlackDark)
        .height(31.px)
        .onKeyDown { tf, event in
            
            if ignoredKeys.contains(event.key) {
                return
            }
            
            guard let _ = Int(event.key) else {
                event.preventDefault()
                return
            }
            
        }
    
    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Imprimir Etiqutas")
                    .color(.lightBlueText)
            }
            .paddingBottom(7.px)
            
            Div {
                
                Div {
                    
                    Div("Tipo de Etiqueta")
                    .color(.white)
                    
                    Div().clear(.both).paddingTop(7.px)
                    
                    self.modeSelect
                    
                }
                .class(.oneThird)
                
                Div {
                    
                    Div{
                        Span("Incluir Precio")
                            .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        self.priceCheckbox
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both).paddingTop(7.px)
                    
                    Div{
                        Div("Tamaño de Letra")
                        .color(.white)
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div{
                        self.fontSizeField
                    }
                    .width(50.percent)
                    .float(.left)
                    
                    Div().clear(.both).paddingTop(7.px)
                    
                }
                .class(.oneThird)
                
                Div {
                    
                    Img()
                        .src("/skyline/media/onlyBarcode.jpg")
                        .hidden( self.$mode.map{ $0 != .onlyBarcode })
                        .height(100.px)

                    Img()
                        .src("/skyline/media/basicRectangled.jpg")
                        .hidden( self.$mode.map{ $0 != .smallRectangled })
                        .height(100.px)

                    Img()
                        .src("/skyline/media/rectangled.jpg")
                        .hidden( self.$mode.map{ $0 != .rectangled })
                        .height(100.px)

                    Img()
                        .src("/skyline/media/semiSquered.jpg")
                        .hidden( self.$mode.map{ $0 != .semiSquered })
                        .height(100.px)
                    
                    Img()
                        .src("/skyline/media/rectangledDetailed.jpg")
                        .hidden( self.$mode.map{ $0 != .longRectangled })
                        .height(100.px)
                    
                }
                .align(.center)
                .class(.oneThird)
                
                Div().class(.clear)
                
            }
            .paddingBottom(7.px)
            
            self.barcodeGrid
                
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.grayBlack)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .width(80.percent)
        .left(10.percent)
        .top(10.percent)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        height(100.percent)
        position(.absolute)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        TypeOfBarcode.allCases.forEach { type in
            modeSelect.appendChild(
                Option(type.description)
                    .value(type.rawValue)
            )
        }
        
        self.barodes.forEach { code in
            
            self.barcodeGrid.appendChild(
                Div{
                    Div{
                        
                        Div("UPC")
                            .class(.oneLineText)
                            .width(30.percent)
                            .float(.left)
                        
                        
                        Div(code.upc)
                            .class(.oneLineText)
                            .width(70.percent)
                            .float(.left)
                        
                        
                        Div().class(.clear)
                        
                        Div("Marca")
                            .class(.oneLineText)
                            .width(30.percent)
                            .float(.left)
                        
                        
                        Div(code.brand)
                            .class(.oneLineText)
                            .width(70.percent)
                            .float(.left)
                        
                        
                        Div().class(.clear)
                        
                        Div("Modelo")
                            .class(.oneLineText)
                            .width(30.percent)
                            .float(.left)
                        
                        
                        Div(code.model)
                            .class(.oneLineText)
                            .width(70.percent)
                            .float(.left)
                        
                        
                        Div().class(.clear)
                        
                        Div("Descripcion")
                            .class(.oneLineText)
                            .width(30.percent)
                            .float(.left)
                        
                        
                        Div(code.name)
                            .class(.oneLineText)
                            .width(70.percent)
                            .float(.left)
                        
                        
                        Div().class(.clear)
                        
                        
                        Div("precio")
                            .class(.oneLineText)
                            .width(30.percent)
                            .float(.left)
                        
                        
                        Div(code.price.formatMoney)
                            .class(.oneLineText)
                            .width(70.percent)
                            .float(.left)
                        
                        
                        Div().class(.clear)
                    }
                    
                }
                    .backgroundColor(.backGroundRow)
                    .class(.roundGrayBlackDark)
                    .cursor(.pointer)
                    .width(23.percent)
                    .margin(all: 3.px)
                    .padding(all: 3.px)
                    .color(.white)
                    .float(.left)
                    .onClick({ tf, event in
                        
                        Console.clear()
                        
                        print(custWebFilesLogos)
                        
                        var logo = "/skyline/media/tierraceroRoundLogoBlack.svg"
                        
                        if let _logo = custWebFilesLogos?.logoIndexMain.avatar {
                            if !_logo.isEmpty {
                                logo = "https://\(custCatchUrl)/contenido/\(_logo)"
                            }
                        }
                        
                        let printBody = PrintBarcodesEngine(
                            type: self.mode,
                            code: code,
                            printPrice: self.printPrice,
                            fontSize: Int(self.fontSize) ?? 12,
                            logo: logo
                        ).innerHTML
                        _ = JSObject.global.printBarcode!(code.upc, printBody)
                    })
            )
        }
    
        if let barcodeType = WebApp.current.window.localStorage.string(forKey: "conservePrintProductBarcodeType") {
            mode = TypeOfBarcode(rawValue: barcodeType) ?? .onlyBarcode
            modeListener = mode.rawValue
        }
    
        if let barcodeSize = WebApp.current.window.localStorage.string(forKey: "conservePrintProductBarcodeSize") {
            fontSize = barcodeSize
        }
        
        if let productPrice = WebApp.current.window.localStorage.string(forKey: "conservePrintProductPrice") {
            printPrice = (productPrice == "true")
        }
        
        $modeListener.listen {
            self.mode = TypeOfBarcode(rawValue: $0)!
            WebApp.current.window.localStorage.set($0, forKey: "conservePrintProductBarcodeType")
        }
        
        $fontSize.listen {
            WebApp.current.window.localStorage.set($0, forKey: "conservePrintProductBarcodeSize")
        }
        
        $printPrice.listen {
            WebApp.current.window.localStorage.set($0.description, forKey: "conservePrintProductPrice")
        }
    }
    
    
}
