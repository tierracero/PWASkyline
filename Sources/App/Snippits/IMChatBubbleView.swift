//
//  IMChatBubbleView.swift
//  
//
//  Created by Victor Cantu on 8/9/22.
//

import Foundation
import TCFundamentals
import Web

/// Instant Comunication Message View
class IMChatBubbleView: Div {
    
    override class var name: String { "div" }
    ///Icon that represents if the msg is un read, read, or user is righting
    @State var icon = ""
    @State var chatNick = "..."
    @State var lastMessageAt: Int64 = 0
    @State var lastMessageAtText: String = ""
    @State var message: String = ""
    /// If has messages that are not viewed
    @State var unSeenMessage: Bool = false
    /// is the user online
    @State var isActive: Bool = false
    /// Hover over icon to view details
    @State var viewDetails: Bool = false
    
    /// This will be used as a 3 second mark that will be trigered every time we recive new message and chat IMChatRoomView is not current room
    ///  this will be used in a while closeNewMessageBubbleTimmer > 0
    @State var closeNewMessageBubbleTimmer = 0
    
    let data: CustChatRoomProfile
    
    private var callback: ((_ room: CustChatRoomProfile) -> ())
    
    init(
        data: CustChatRoomProfile,
        callback: @escaping ((_ room: CustChatRoomProfile) -> ())
    ) {
        self.data = data
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            Div(self.$lastMessageAtText)
                .align(.right)
                .fontSize(14.px)
                .color(.lightGray)
                .marginBottom(3.px)
            
            Div(self.$message)
                .fontSize(20.px)
                .color(.white)
        }
        .border(width: .thin, style: .solid, color: .gray)
        .boxShadow(h: 1.px, v: 1.px, blur: 2.px, color: .transparentBlack)
        .backgroundColor(Color(.rgba(0, 0, 0, 0.8)))
        .borderRadius(all: 7.px)
        .position(.absolute)
        .right(75.px)
        .width(250.px)
        .padding(all: 7.px)
        .hidden(self.$viewDetails.map{ !$0 })
        
        /// Icon (mail / avatar) && (folio / nick)
        Div{
            Div{
                
                Div{
                    Div()
                        .backgroundColor(self.$isActive.map{ $0 ? .greenYellow : .transparent })
                        .borderRadius(all: 5.px)
                        .height(self.$unSeenMessage.map{ $0 ? 7.px : 10.px })
                        .width(self.$unSeenMessage.map{ $0 ? 7.px : 10.px })
                        .margin(all:self.$unSeenMessage.map{ $0 ? 3.px : 2.px })
                }
                .backgroundColor(self.$unSeenMessage.map{ $0 ? .lightBlueText : .transparent })
                .borderRadius(all: 7.px)
                .height(14.px)
                .width(14.px)
                .position(.absolute)
                .marginLeft(33.px)
                .marginTop(29.px)
                Img()
                    .src("skyline/media/default_panda.jpeg")
                    .custom("width", "calc(100% - 6px)")
                    .borderRadius(all: 26.px)
                    .load(self.icon)
               
            }
            
            Div(self.$chatNick)
                .fontSize(12.px)
                .color(.gray)
                .class(.oneLineText)
            
        }
        .padding(all: 3.px)
        .align(.center)
        .height(52.px)
        .width(46.px)
        .onMouseOver {
            // TODO add a ref to se what chat (or chats have a ui opendand dont "view details")
            self.viewDetails = true
        }
        .onMouseLeave {
            self.viewDetails = false
        }
        .onClick {
            self.unSeenMessage = false
            self.viewDetails = false
            self.callback(self.data)
        }
        
        Div().class(.clear)
    }
    
    override func buildUI() {
        super.buildUI()
        
        height(56.px)
        cursor(.pointer)
        borderRadius(all: 12.px)
        padding(all: 3.px)
        marginTop(3.px)
        
        self.$lastMessageAt.listen {
            self.lastMessageAtText = orderTimeMesure(uts: $0, type: .createdAt).timeString
        }
        
        self.$closeNewMessageBubbleTimmer.listen {
            
            if $0 <= 0 {
                self.viewDetails = false
                return
            }

            Dispatch.asyncAfter(1.0) {
                self.closeNewMessageBubbleTimmer -= 1
            }
            
        }
        
        self.icon = self.data.avatar
     
        self.chatNick = self.data.nick
        
        self.lastMessageAt = self.data.lastMessageAt
        
        self.message = self.data.lastMessage
        
        self.unSeenMessage = self.data.unSeenMessage
        
        self.isActive = self.data.isActive
        
        var conterid: UUID? = nil
        
        self.data.members.forEach { id in
            if id != custCatchID {
                conterid = id
            }
        }
        
        if let conterid = conterid {
            if let user = userCathByUUID[conterid] {
                self.icon = user.avatar
                self.chatNick = user.nick
            }
        }
        
        recalculateTime()
        
    }
    
    func updateLastMessage(msg: CustSocialMessage, showBubble: Bool) {
        
        self.lastMessageAt = msg.createdAt
        
        self.message = msg.message
        
        if showBubble {
            self.unSeenMessage = true
            self.viewDetails = true
            self.closeNewMessageBubbleTimmer = 3
        }
    }
    
    func recalculateTime(){
        
        self.lastMessageAtText = orderTimeMesure(uts: self.lastMessageAt, type: .createdAt).timeString
        
        Dispatch.asyncAfter(60) {
            self.recalculateTime()
        }
        
    }
    
}

