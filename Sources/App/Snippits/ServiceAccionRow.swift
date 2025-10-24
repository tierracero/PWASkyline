//
//  ServiceAccionRow.swift
//  
//
//  Created by Victor Cantu on 4/4/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionRow: Div {
    
    override class var name: String { "div" }
    
    let type: SaleActionType
    
    var action: CustSaleActionQuick
    
    private var removed: ((
    ) -> ())
    
    init(
        type: SaleActionType,
        action: CustSaleActionQuick,
        removed: @escaping ((
        ) -> ())
    ) {
        self.type = type
        self.action = action
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
                .src("/skyline/media/cross.png")
                .marginTop(7.px)
                .height(24.px)
                .onClick { _, event in
                    self.removed()
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
            .id(Id(stringLiteral: self.action.id.uuidString))
            .width(97.percent)
            .onClick {
                
                addToDom(ServiceAccionView(
                    type: self.type,
                    id: self.action.id
                ) { action in
                    self.action = action
                    self.name = action.name
                })
                
            }
        
        name = action.name
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
}
