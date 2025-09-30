//
//  EmailBoxView.swift
//  
//
//  Created by Victor Cantu on 2/18/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import Web

class EmailBoxView: Div {
    
    override class var name: String { "div" }
    
    let item: MailBox
    
    @State var count: Int
    
    let currentBox: State<String>
    
//    private var switchMode: ((
//    ) -> ())
    
    init(
        item: MailBox,
        count: Int,
        currentBox: State<String>
    ) {
        self.item = item
        self.count = count
        self.currentBox = currentBox
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var boxIcon = ""
    
    var boxName = ""
    
    lazy var nameDiv = Div(self.boxName)
        .class(.oneLineText)
        .marginLeft(7.px)
        .fontSize(24.px)
        .color(.white)
        .float(.left)
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div{
                
                Img()
                    .class(.iconWhite)
                    .src(self.boxIcon)
                    .marginLeft(5.px)
                    .marginTop(5.px)
                    .height(20.px)
                    .width(20.px)
                
            }
            .height(30.px)
            .width(30.px)
            .float(.left)
            
            self.nameDiv
            
            Div(self.$count.map({ $0.toString }))
                .hidden(self.$count.map({$0 <= 0}))
                .class(.oneLineText)
                .textAlign(.right)
                .marginLeft(7.px)
                .fontSize(24.px)
                .width(55.px)
                .float(.left)
                .color(.deepSkyBlue)
            
            Div().class(.clear)
        }
        .padding(all: 3.px)
        
    }
    
    override func buildUI() {
        
        super.buildUI()
        
        marginBottom(3.px)
        cursor(.pointer)
        
        backgroundColor(self.currentBox.map({ ($0 == self.item.name) ? .black : .transparent }))
        
        if item.name == "INBOX" {
            boxName = "Entrada"
            boxIcon = "/skyline/media/mail_inbox.png"
        }
        else if item.name == "INBOX.Sent" {
            boxName = "Envados"
            boxIcon = "/skyline/media/mail_sent.png"
        }
        else if item.name == "INBOX.Trash" {
            boxName = "Basura"
            boxIcon = "/skyline/media/mail_trash.png"
        }
        else if item.name == "INBOX.spam" {
            boxName = "No Deseado"
            boxIcon = "/skyline/media/mail_spam.png"
        }
        else {
            boxName = (item.name.explode(".").last ?? "").capitalizeFirstLetter
            boxIcon = "/skyline/media/mail_folder.png"
        }
        
        $count.listen {
            if $0 > 0 {
                self.nameDiv
                    .custom("width", "calc(100% - 100px)")
            }
            else {
                self.nameDiv
                    .custom("width", "calc(100% - 40px)")
            }
        }
        
        if count > 0 {
            nameDiv
                .custom("width", "calc(100% - 100px)")
        }
        else {
            nameDiv
                .custom("width", "calc(100% - 40px)")
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
}
