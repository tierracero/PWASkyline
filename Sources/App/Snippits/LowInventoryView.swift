//
//  LowInventoryView.swift
//  
//
//  Created by Victor Cantu on 3/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class LowInventoryView: Div {
    
    override class var name: String { "div" }
    
    private var generatePurchaseOrder: ((
    ) -> ())
    
    init(
        generatePurchaseOrder: @escaping ((
        ) -> ())
    ) {
        self.generatePurchaseOrder = generatePurchaseOrder
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("Inventario Bajo")
                    .float(.left)
                    .color(.gray)
                
                Div().class(.clear)
                
            }
            
            Div{
                
                Img()
                    .src("/skyline/media/icon-alert.svg")
                    .marginBottom(12.px)
                    .height(100.px)
                    Br()
                H2("No cuenta con suficiente inventario, puede seleccionar de otra tienda o puede crear una orden de compra.")
                    .marginBottom(12.px)
                    .color(.lightGray)
                
                Div {
                    Div("Agregar de Otra Tienda")
                        .class(.uibtnLarge)
                        .width(90.percent)
                        .onClick {
                            self.remove()
                        }
                }
                .marginBottom(12.px)
                .align(.center)
                
                Div{
                    
                    Div("Generar Orden de Compra")
                        .class(.uibtnLargeOrange)
                        .width(90.percent)
                        .onClick {
                            self.generatePurchaseOrder()
                            self.remove()
                        }
                    
                }
                .marginBottom(12.px)
                .align(.center)
                
                
                
            }
            .align(.center)
            
            
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 250px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .top(30.percent)
        .width(500.px)
        
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
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
    }
    
    
}
