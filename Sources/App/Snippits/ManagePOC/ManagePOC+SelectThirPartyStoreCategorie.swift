//
//  ManagePOC+SelectThirPartyStoreCategorie.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class SelectThirPartyStoreCategorie: Div {
        
        override class var name: String { "div" }
        
        var items: [API.custPOCV1.CategorizerObject]
        
        /// When you do changes to  soc create a call back to parent view
        private var callback: ((
            _ item: API.custPOCV1.CategorizerObject
        ) -> ())
        
        init(
            items: [API.custPOCV1.CategorizerObject],
            callback: @escaping ( (
                _ item: API.custPOCV1.CategorizerObject
            ) -> ())
            
        ) {
            self.items = items
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var brandGrid = Div()
            .custom("height", "calc(100% - 35px)")
            .class(.roundDarkBlue)
            .overflow(.auto)
        
        @DOM override var body: DOM.Content {
            Div{
                
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.uiView4)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Selecciona Categoria del Producto")
                        .color(.lightBlueText)
                        .float(.left)
                    
                    Div().class(.clear)
                }
                
                self.brandGrid
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 7.px)
            .height(50.percent)
            .width(40.percent)
            .left(30.percent)
            .top(25.percent)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            top(0.px)
            left(0.px)
            
            items.forEach { item in
                brandGrid.appendChild(
                    Div("\(item.subCategorieId) \(item.subCategorieName)")
                        .class(.uibtn, .oneLineText)
                        .width(95.percent)
                        .onClick{
                            self.callback(item)
                            self.remove()
                        }
                )
            }
            
        }
        
    }
}
