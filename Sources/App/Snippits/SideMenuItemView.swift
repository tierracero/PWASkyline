//
//  SideMenuItemView.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import Web

class SideMenuItemView: Div {
    
    override class var name: String { "div" }
    
    var icon: String
    var title: String
    var subTitle: String
    var caller: String
    private var callback: ((_ caller: String) -> ())
    
    init(
        icon: String,
        title: String,
        subTitle: String,
        caller: String,
        callback: @escaping ((_ caller: String) -> ())
    ) {
        self.icon = icon
        self.title = title
        self.subTitle = subTitle
        self.caller = caller
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            Img()
                .src(self.icon)
                .marginRight(7.px)
                .height(40.px)
        }
        .float(.left)
        Div{
            Div{
                
                Strong(self.title)
                    .fontSize(24.px)
                    
            }
            .class(.oneLineText)
            Div(self.subTitle)
                .class(.oneLineText)
                .fontSize(18.px)
        }
        .float(.left)
        .custom("width", "calc(100% - 48px)")
        Div().class(.clear)
    }
    
    override func buildUI() {
        margin(all: 7.px)
        cursor(.pointer)
        onClick {
            self.callback(self.caller)
        }
    }
    
}
