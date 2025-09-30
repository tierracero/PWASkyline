//
//  MoneyManager+HistoryView.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView {
    
    class HistoryView: Div {
        
        override class var name: String { "div" }
        
        @DOM override var body: DOM.Content {
            //Select Code
            Div{
                /// Header
                Div {
                    
                    Img()
                        .closeButton(.subView)
                        .onClick {
                            self.remove()
                        }
                    
                    H2("Seleccione Servicio")
                        .color(.lightBlueText)
                        .marginLeft(7.px)
                        .float(.left)
                    
                    Div().class(.clear)
                    
                }
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .width(40.percent)
            .left(30.percent)
            .top(25.percent)
            .color(.white)
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
    }
    
}
