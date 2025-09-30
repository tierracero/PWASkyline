//
//  ImageEditorItem.swift
//  
//
//  Created by Victor Cantu on 9/22/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ImageEditorItem: Div {
    
    override class var name: String { "div" }
    
    @State var url: String?
    var width: Int
    var height: Int
    
    private var callback: ((
        _ url: String,
        _ width: Int,
        _ height: Int
    ) -> ())
    
    init(
        url: String?,
        width: Int,
        height: Int,
        callback: @escaping ((
            _ url: String,
            _ width: Int,
            _ height: Int
        ) -> ())
        
    ) {
        self.url = url
        self.width = width
        self.height = height
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var loadPercent = ""
    
    lazy var imageDiv = Div{
        Img()
            .src("skyline/media/tierraceroRoundLogoWhite.svg")
            .hidden(self.$url.map{ $0 != nil })
            .height(100.percent)
            .width(100.percent)
            .opacity(0.24)
        
        Div{
            Table{
                Tr{
                    Td(self.$loadPercent)
                        .verticalAlign(.middle)
                        .fontSize(36.px)
                        .align(.center)
                        .color(.white)
                }
            }
            .width(100.percent)
            .height(100.percent)
        }
        .hidden(self.$loadPercent.map{ $0.isEmpty})
        .position(.absolute)
        .height(100.percent)
        .width(100.percent)
        .top(0.px)
        
    }
    
    @DOM override var body: DOM.Content {
        self.imageDiv
            .backgroundSize(all: .contain)
            .backgroundPosition( .center)
            .backgroundRepeat( .noRepeat)
            .position(.relative)
            .height(100.percent)
            .width(100.percent)
            .cursor(.pointer)
    }
    
    override func buildUI() {
        boxShadow(h: 1.px, v: 1.px, blur: 3.px, color: .black)
        backgroundColor(.grayBlackDark)
        borderRadius(all: 12.px)
        margin(all: 5.px)
        overflow(.hidden)
        cursor(.pointer)
        height(73.px)
        width(73.px)
        float(.left)
        onClick {
            if let url = self.url {
                self.callback(url, self.width, self.height)
            }
        }
        
        if let url = url {
            loadImage(url)
        }
        
    }
    
    override func didAddToDOM(){
        
    }
    
    func loadImage(_ url: String) {
     
        let item = Img()
            .src(url)
            .onLoad {
                
                self.url = url
                
                self.imageDiv
                    .custom("background-image", "url('\(url)')")
            }
    }
    
}
