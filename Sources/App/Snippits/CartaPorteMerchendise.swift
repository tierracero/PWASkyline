//
//  CartaPorteMerchendise.swift
//  
//
//  Created by Victor Cantu on 1/13/23.
//

import Foundation

import Foundation
import TCFundamentals
import Web

class CartaPorteMerchendise: Div {
    
    override class var name: String { "div" }
    
    let merchadise: FiscalMercanciaItem
    
    private var callback: ((
        _ id: UUID
    ) -> ())
    
    init(
        merchadise: FiscalMercanciaItem,
        callback: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        self.merchadise = merchadise
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let viewid = UUID()
    
    @DOM override var body: DOM.Content {
        Div().clear(.both).marginBottom(3.px)
        Div {
            Div {
                
                Div("Description")
                    .class(.oneLineText)
                    .width(30.percent)
                    .float(.left)
                
                
                Div("Unis")
                    .class(.oneLineText)
                    .width(10.percent)
                    .float(.left)
                
                
                Div("Peso")
                    .class(.oneLineText)
                    .width(10.percent)
                    .float(.left)
                
                
                Div("Origen")
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                
                Div("Destino")
                    .width(25.percent)
                    .float(.left)
                
                Div().class(.clear)
                
            }
            .marginBottom(7.px)
            .fontSize(12.px)
            .color(.gray)
            
            Div{
                
                Div(self.merchadise.description)
                    .class(.oneLineText)
                    .width(30.percent)
                    .float(.left)
                
                
                Div(self.merchadise.units.fromCents.toString)
                    .class(.oneLineText)
                    .width(10.percent)
                    .float(.left)
                
                
                Div(self.merchadise.kilograms.fromCents.toString)
                    .class(.oneLineText)
                    .width(10.percent)
                    .float(.left)
                
                
                Div("\(self.merchadise.from) \(self.merchadise.fromStoreName)")
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                
                Div("\(self.merchadise.to) \(self.merchadise.toStoreName)")
                    .class(.oneLineText)
                    .width(25.percent)
                    .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            .fontSize(14.px)
            .color(.white)
            
            Div{
                
                Div("Codigo Fiscal")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                Div("Unidad Fiscal")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                Div("Tipo Embalaje")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                Div("Peligoso")
                    .class(.oneLineText)
                    .width(10.percent)
                    .float(.left)
                
                Div("Clave M. P.")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            .fontSize(12.px)
            .color(.gray)
            
            Div{
                Div("\(self.merchadise.fiscCode) \(self.merchadise.fiscCodeName)")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                Div("\(self.merchadise.fiscUnit) \(self.merchadise.fiscUnitName)")
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                // pack
                Div(self.merchadise.packagingName)
                    .class(.oneLineText)
                    .width(22.5.percent)
                    .float(.left)
                
                /// dangerous
                Div(self.merchadise.isDangerousMatirial.rawValue)
                    .class(.oneLineText)
                    .width(10.percent)
                    .align(.right)
                    .float(.left)
                
                /// dan name
                Div(self.merchadise.dangerousMatirialName)
                .width(22.5.percent)
                .class(.oneLineText)
                .float(.left)
                
                Div().class(.clear)
            }
            .marginBottom(7.px)
            .fontSize(14.px)
            .color(.white)
            
        }
        .custom("width", "calc(100% - 50px)")
        .float(.left)
        
        Div {
            Table {
                Tr {
                    Td {
                        Img()
                            .src("/skyline/media/cross.png")
                            .cursor(.pointer)
                            .onClick { _, event in
                                event.stopPropagation()
                                
                                self.callback(self.merchadise.id)
                                
                            }
                    }
                    .verticalAlign(.middle)
                    .align(.center)
                }
            }
            .height(100.percent)
            .width(100.percent)
        }
        .height(85.px)
        .width(50.px)
        .float(.left)
        
        Div().clear(.both).marginBottom(3.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.roundGrayBlackDark)
        
        backgroundColor(.grayBlackDark)
        
        margin(all: 7.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
}
