//
//  SalePoint+SelectItemView.swift
//  
//
//  Created by Victor Cantu on 7/21/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension SalePointView {
    class SelectItemView: Div {
        
        override class var name: String { "div" }
        
        @State var items: [CustPOCInventorySoldObject]
        
        init(
            items: [CustPOCInventorySoldObject]
        ) {
            self.items = items
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
            
            Div {
                // Top Tools
                Div{
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Seleccione Inventario")
                        .color(.lightBlueText)
                }
                .paddingBottom(3.px)
                
                Div{
                    Div{
                        Div("Id")
                            .width(30.percent)
                            .float(.left)
                        Div("Serie")
                            .width(30.percent)
                            .float(.left)
                        Div("Precio")
                            .width(30.percent)
                            .float(.left)
                        Div("")
                            .width(10.percent)
                            .float(.left)
                    
                        Div().clear(.both)
                        
                    }
                    
                    ForEach(self.items){ item in
                        Div{
                            
                            Div(item.id.uuidString.explode("-").last ?? "N/D")
                                .class(.oneLineText)
                                .width(30.percent)
                                .minHeight(30.px)
                                .float(.left)
                            
                            Div(item.series)
                                .class(.oneLineText)
                                .width(30.percent)
                                .minHeight(30.px)
                                .float(.left)
                            
                            Div(item.soldPrice?.formatMoney ?? "N/D")
                                .class(.oneLineText)
                                .width(30.percent)
                                .textAlign(.right)
                                .minHeight(30.px)
                                .float(.left)
                            
                            Div{
                                Img()
                                    .src("skyline/media/maximizeWindow.png")
                                    .class(.iconWhite)
                                    .textAlign(.right)
                                    .cursor(.pointer)
                                    .width(18.px)
                                    .onClick {
                            
                                        addToDom(InventoryItemDetailView(itemid: item.id){ price in
                                            
                                        })
                                    }
                            }
                                .width(10.percent)
                                .float(.left)
                            
                            Div().clear(.both)
                        }
                        Div()
                            .clear(.both)
                            .height(3.px)
                    }
                }
                .custom("height", "calc(100% - 35px)")
                .overflow(.auto)
                .color(.white)
                
            }
            .custom("left", "calc(50% - 200px)")
            .custom("top", "calc(50% - 254px)")
            .backgroundColor(.backGroundGraySlate)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(486.px)
            .width(500.px)
            
        }
        
        override func buildUI() {
            
            self.class(.transparantBlackBackGround)
            height(100.percent)
            position(.absolute)
            width(100.percent)
            left(0.px)
            top(0.px)
                        
        }
    }
}
