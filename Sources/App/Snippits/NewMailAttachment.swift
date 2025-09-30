//
//  NewMailAttachment.swift
//  
//
//  Created by Victor Cantu on 2/20/23.
//

import TCFundamentals
import Foundation
import Web

class NewMailAttachment: Div {
    
    override class var name: String { "div" }
    
    let file: File
    
    private var delete: ((
        _ viewid: UUID
    ) -> ())
    
    init(
        file: File,
        delete: @escaping ((
            _ viewid: UUID
        ) -> ())
    ) {
        
        self.file = file
        self.delete = delete
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let viewid: UUID = .init()
    
    @State var loadPercent: String = "0"
    
    @State var isuploaded: Bool = false
    
    var fileName = ""
    
    @DOM override var body: DOM.Content {
        
        Div(self.file.name)
            .custom("width", "calc(100% - 35px)")
            .class(.oneLineText)
            .float(.left)
        
        Img()
            .src("/skyline/media/cross.png")
            .width(30.px)
            .cursor(.pointer)
            .float(.right)
            .onClick {
                self.delete(self.viewid)
            }
            .hidden(self.$isuploaded.map{ !$0 })
        
        Div(self.$loadPercent)
            .textAlign(.center)
            .float(.right)
            .width(35.px)
            .hidden(self.$isuploaded)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.uibtnLarge)
        width(93.percent)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    
}


