//
//  EmailQuickView.swift
//  
//
//  Created by Victor Cantu on 2/17/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import Web

class EmailQuickView: Div {
    
    override class var name: String { "div" }
    
    var item: MessagePreview
    
    private var callback: ((
    ) -> ())
    
    init(
        item: MessagePreview,
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
    
    /// `seen` - this message is flagged as already read
    @State var seen: Bool = false
    
    /// `flagged` - this message is flagged
    @State var flagged: Bool = false
    
    /// `answered` - this message is flagged as answered
    @State var answered: Bool = false
    
    @State var from: String = ""
    
    @State var timeString: String = ""
    
    var hasAttachment = false
    
    @DOM override var body: DOM.Content {
        Div{
            
            Div{
                
            }
            .hidden(self.$seen)
            .backgroundColor(.dodgerBlue)
            .borderRadius(11.px)
            .margin(all: 2.px)
            .height(14.px)
            .width(14.px)
            
            Div{
                
            }
            .hidden(self.$flagged.map{ !$0 })
            .backgroundColor(.darkOrange)
            .borderRadius(11.px)
            .margin(all: 2.px)
            .height(14.px)
            .width(14.px)
            
            Img()
                .src("/skyline/media/clip.png")
                .hidden(self.hasAttachment)
                .borderRadius(11.px)
                .margin(all: 2.px)
                .class(.iconWhite)
                .height(14.px)
                .width(14.px)
            
        }
        .paddingRight(2.px)
        .minHeight(40.px)
        .width(18.px)
        .float(.left)
        
        Div{
            Div{
                
                Div(self.$from)
                    .custom("width", "calc(70% - 0px)")
                    .class(.oneLineText)
                    .fontWeight(.bold)
                    .color(.white)
                    .float(.left)
                
                
                Div(self.$timeString)
                    .class(.oneLineText)
                    .width(30.percent)
                    .textAlign(.right)
                    .float(.left)
                    .color(.gray)
                
                
                
                Div().class(.clear)
            }
            
            Div(self.item.subject)
                .class(.oneLineText)
                .color(.gray)
            
        }
        .custom("width", "calc(100% - 24px)")
        .fontSize(14.px)
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
        onClick {
            self.callback()
            self.seen = true
        }
        
        
        seen = item.seen
        flagged = item.flagged
        answered = item.answered
        
        from = item.from.explode("<").first?.purgeSpaces ?? ""
        
        let date = getDate(item.recivedAt)
        
        if ( (getNow() - item.recivedAt) < 86400 ) {
            timeString = "\(date.hour):\(date.minute)"
        }
        else {
            timeString = date.formatedLong
        }
        
        hasAttachment = !(item.attachments > 0)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}


