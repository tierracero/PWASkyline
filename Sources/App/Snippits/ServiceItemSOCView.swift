//
//  ServiceItemSOCView.swift
//  
//
//  Created by Victor Cantu on 4/1/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceItemSOCView: Div {
    
    override class var name: String { "div" }
    
    let soc: CustSOCQuick
    
    private var callback: ((
        _ update: @escaping (
            _ title: String,
            _ subTitle: String,
            _ price: Int64,
            _ avatar: String
        ) -> ()
    ) -> ())
    
    init(
        soc: CustSOCQuick,
        callback: @escaping ((
            _ update:  @escaping (
                _ title: String,
                _ subTitle: String,
                _ price: Int64,
                _ avatar: String
            ) -> ()
        ) -> ())
    ) {
        self.soc = soc
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var avatar = Img()
    
    @State var name = ""
    
    @State var price: Int64 = 0
    
    @DOM override var body: DOM.Content {
        avatar
            .src("/skyline/media/512.png")
            .borderRadius(all: 12.px)
            .marginRight(7.px)
            .objectFit(.cover)
            .height(50.px)
            .width(50.px)
            .float(.left)
        
        Div(self.$name)
            .custom("width", "calc(100% - 200px)")
            .class(.oneLineText)
            .marginRight(7.px)
            .float(.left)
        
        Div{
            Div(self.$price.map{ $0.formatMoney })
                .class(.oneLineText)
                .marginTop(12.px)
                .color(.white)
        }
        .class(.oneLineText)
        .width(130.px)
        .align(.right)
        .float(.left)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        onClick {
            
            self.callback { name, subTitle, price, avatar in
                
                self.name = name
                
                self.price = price
                
                self.avatar
                    .load("contenido/thump_\(avatar)")
                
            }
            
        }
        
        self.price = soc.pricea
    }
    override func didAddToDOM() {
        super.didAddToDOM()
        self.class(.rowItem, .hiddeToolItem)
        
        name = soc.name
        
        if !soc.avatar.isEmpty {
            avatar.load("conetnido/thump_\(soc.avatar)")
        }
        
    }
    
    override func didRemoveFromDOM() {
        super.didRemoveFromDOM()
    }
    
}

