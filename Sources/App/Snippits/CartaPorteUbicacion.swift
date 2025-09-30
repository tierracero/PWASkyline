//
//  CartaPorteUbicacion.swift
//  
//
//  Created by Victor Cantu on 1/11/23.
//

import Foundation
import TCFundamentals
import Web

class CartaPorteUbicacion: Div {
    
    override class var name: String { "div" }
    
    let placement: FiscalLocationItem
    
    private var callback: ((
        _ id: UUID
    ) -> ())
    
    init(
        placement: FiscalLocationItem,
        callback: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        self.placement = placement
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var isHomeItem: Bool = true
    
    @State var date = ""
    
    @State var time = ""
    
    @State var street = ""
    
    @State var number = ""
    
    @State var refrence = ""
    
    let viewid = UUID()
    
    lazy var bodyDiv = Div{
        
        Div{
            Span("Tipo de ubicación")
                .marginRight(7.px)
                .color(.gray)
            
            Span(self.placement.placementType.description)
                .color(.darkOrange)

            Span(self.placement.placementId)
                .float(.right)
                .color(.darkOrange)
            
            Span("Place ID")
                .marginRight(7.px)
                .float(.right)
                .color(.gray)
        }
        .marginBottom(7.px)
        
        Div {
            Div(self.$isHomeItem.map{ $0 ? "RFC del Emisor" : "RFC del Receptor" })
                .class(.oneLineText)
                .color(.yellowTC)
                .width(25.percent)
                .float(.left)
            
            Div(self.$isHomeItem.map{ $0 ? "Nombre del Emisor" : "Nombre del Receptor" })
                .class(.oneLineText)
                .color(.yellowTC)
                .width(35.percent)
                .float(.left)
            
            Div("Fecha")
                .class(.oneLineText)
                .color(.yellowTC)
                .width(20.percent)
                .float(.left)
            
            Div("Hora (24h)")
                .class(.oneLineText)
                .color(.white)
                .width(20.percent)
                .float(.left)
            
            Div().class(.clear)
        }
        .marginBottom(3.px)
        .fontSize(14.px)
        
        Div {
            
            Div(self.placement.rfc)
                .class(.oneLineText)
                .width(25.percent)
                .color(.white)
                .float(.left)
            
            Div(self.placement.razon)
                .class(.oneLineText)
                .width(35.percent)
                .color(.white)
                .float(.left)
            
            
            Div(self.$date)
                .class(.oneLineText)
                .width(20.percent)
                .color(.white)
                .float(.left)
            
            
            Div(self.$time)
                .class(.oneLineText)
                .width(20.percent)
                .color(.white)
                .float(.left)
                
            Div().class(.clear)
            
        }
        .marginBottom(7.px)
        
        H5(self.$isHomeItem.map{ $0 ? "Direccion de Envio" : "Direccion de Recepcion" })
            .marginBottom(3.px)
            .color(.gray)
        
        Div {
            
            Div("Calle")
                .class(.oneLineText)
                .width(25.percent)
                .color(.white)
                .float(.left)
            
            Div("Numero")
                .class(.oneLineText)
                .width(15.percent)
                .color(.white)
                .float(.left)
            
            Div("Refrence")
                .class(.oneLineText)
                .width(25.percent)
                .color(.white)
                .float(.left)
            
            Div("State")
                .class(.oneLineText)
                .width(20.percent)
                .color(.white)
                .float(.left)
            
            Div("Codigo Postal")
                .color(.yellowTC)
                .class(.oneLineText)
                .width(15.percent)
                .float(.left)
            
            Div().class(.clear)
        }
        .marginBottom(3.px)
        .fontSize(14.px)
     
        Div {
            
            Div(self.$street.map{ $0.isEmpty ? "Calle" : $0 })
                .color(self.$street.map{ $0.isEmpty ? .gray : .white })
                .class(.oneLineText)
                .width(25.percent)
                .float(.left)

            Div(self.$number.map{ $0.isEmpty ? "Numero" : $0 })
                .color(self.$street.map{ $0.isEmpty ? .gray : .white })
                .class(.oneLineText)
                .width(15.percent)
                .float(.left)

            Div(self.$refrence.map{ $0.isEmpty ? "Edificio blanco con negro" : $0 })
                .color(self.$refrence.map{ $0.isEmpty ? .gray : .white })
                .class(.oneLineText)
                .width(25.percent)
                .float(.left)

            Div(self.placement.state.description)
                .class(.oneLineText)
                .width(20.percent)
                .color(.white)
                .float(.left)

            Div(self.placement.zipCode)
                .class(.oneLineText)
                .width(15.percent)
                .color(.white)
                .float(.left)
            
            Div().class(.clear)
        }
        
    }
    
    @DOM override var body: DOM.Content {
        Div().clear(.both).marginBottom(3.px)
        
        if placement.placementType == .origen {
            self.bodyDiv
        }
        else {
            
            self.bodyDiv
            .custom("width", "calc(100% - 50px)")
            .float(.left)
            
            Div{
                Table{
                    Tr{
                        Td{
                            Img()
                                .src("/skyline/media/cross.png")
                                .cursor(.pointer)
                                .onClick { _, event in
                                    event.stopPropagation()
                                    self.callback(self.placement.id)
                                }
                        }
                        .verticalAlign(.middle)
                        .align(.center)
                    }
                }
                .height(100.percent)
                .width(100.percent)
            }
            .height(125.px)
            .width(50.px)
            .float(.left)
            
            
        }
        Div().clear(.both).marginBottom(3.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.roundGrayBlackDark)
        
        backgroundColor(.grayBlackDark)
        
        margin(all: 7.px)
        
        isHomeItem = placement.placementType == .origen
        
        refrence = placement.refrence
        
        street = placement.street
        
        number = placement.number
        
        let _date = getDate(self.placement.uts)
        
        date = _date.formatedShort
        
        time = _date.time
        
    }
    
}
