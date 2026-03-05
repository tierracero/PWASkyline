//
//  MapMultipleAddressSelctor.swift
//
//
//  Created by Victor Cantu on 10/27/26.
//

import Foundation
import TCFundamentals
import Web

public class MapMultipleAddressSelector: Div {
    
    public override class var name: String { "div" }

    @State var linkedLocations: [AppleMap]
    
    private var callback: ((
        _ appleMap: AppleMap
    ) -> ())
    
    public init(
        linkedLocations: [AppleMap],
        callback: @escaping((
            _ appleMap: AppleMap
        ) -> ())
    ) {
        self.linkedLocations = linkedLocations
        self.callback = callback
        
        super.init()
    }
    
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM public override var body: DOM.Content {

        Div{
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()

                    }
                
                H2("Seleccionar Direccion")
                    .color(.lightBlueText)
            }
            
            Div().class(.clear).marginTop(7.px)
        
            ForEach(self.$linkedLocations){ loc in
                
                Div{
                    Span(loc.formattedAddress ?? "\(loc.name) \(loc.locality) \(loc.postCode)")
                }
                    .custom("width","calc(100% - 24px)")
                    .class(.uibtnLarge, .twoLineText)
                    .onClick {
                        self.callback(loc)
                        self.remove()
                    }
                
            }
            .width(100.percent)
            .maxHeight(300.px)
            .overflow(.auto)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .borderRadius(all: 24.px)
        .padding(all: 12.px)
        .position(.absolute)
        .width(50.percent)
        .left(25.percent)
        .top(24.percent)
        
    }
    
    public override func buildUI() {
        
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        
    }
}
