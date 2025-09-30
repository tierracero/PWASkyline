//
//  ServiceProductionElementsRow.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceProductionElementsRow: Div {
    
    override class var name: String { "div" }
    
    var object: CustProductionElement
    
    private var removed: ((
    ) -> ())
    
    init(
        object: CustProductionElement,
        removed: @escaping ((
        ) -> ())
    ) {
        self.object = object
        self.removed = removed
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var name: String = ""
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div(self.$name)
                .fontSize(22.px)
                .color(.white)
            
        }
        .custom("width", "calc(100% - 49px)")
        .padding(all: 3.px)
        .margin(all: 3.px)
        .float(.left)
        
        Div{
            
            Img()
                .src("/skyline/media/pencil.png")
                .marginTop(7.px)
                .height(24.px)
                .onClick { _, event in
                    
                    event.stopPropagation()
                }
            
        }
        .align(.center)
        .width(35.px)
        .float(.left)
        .onClick { _, event in
            event.stopPropagation()
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.uibtnLarge)
            .width(97.percent)
            .onClick {
                
                //addToDom(ServiceOperationalObjectsView)
                
                
            }
        
        name = object.name
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
}
