//
//  OrderImageView.swift
//  
//
//  Created by Victor Cantu on 8/17/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class OrderImageView: Div {
    
    override class var name: String { "div" }
    
    @State var id: UUID?
    
    @State var name: String
    
    /// can be a  base64 string of url
    @State var url: String
    
    private var callback: ((
        _ id: UUID?,
        _ name: String
    ) -> ())
    
    init(
        id: UUID?,
        name: String,
        url: String,
        callback: @escaping ((
            _ id: UUID?,
            _ name: String
        ) -> ())
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var loadPercent: String = ""
 
    let viewId: UUID = .init()
    
    @DOM override var body: DOM.Content {
        Table{
            Tr{
                Td{
                    Span(self.$loadPercent)
                        .color(.white)
                }
                .align(.center)
                .verticalAlign(.middle)
            }
            .hidden(self.$id.map{ ($0 == nil) ? false : true})
        }
        .width(100.percent)
        .height(100.percent)
    }
    
    override func buildUI() {
        custom("background-image", "url('\(url)')")
        custom("width", "calc(50% - 10px)")
        backgroundRepeat(.noRepeat)
        backgroundSize(all: .cover)
        backgroundPosition(.center)
        borderRadius(all: 24.px)
        backgroundColor(.black)
        margin(all: 5.px)
        cursor(.pointer)
        height(107.px)
        float(.left)
        onClick {
            self.callback(self.id, self.name)
        }
    }
}

