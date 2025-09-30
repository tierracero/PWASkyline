//
//  EmailBoxQuickView.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//


import TCFundamentals
import Foundation
import MailAPICore
import Web

class EmailBoxQuickView: Div {
    
    override class var name: String { "div" }
    
    var item: MailBox
    
    private var callback: ((
    ) -> ())
    
    init(
        item: MailBox,
        callback: @escaping ((
        ) -> ())
    ) {
        self.item = item
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            
            Div{
                
            }
            .backgroundColor(.blue)
            .borderRadius(11.px)
            .height(22.px)
            .width(22.px)
            
            Div{
                
            }
            .backgroundColor(.yellow)
            .borderRadius(11.px)
            .height(22.px)
            .width(22.px)
            
        }
        .width(24.px)
        .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        backgroundColor(.grayBlackDark)
        borderRadius(12.px)
        padding(all: 7.px)
        margin(all: 3.px)
        overflow(.hidden)
        
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}



