//
//  ChatMessageView.swift
//  
//
//  Created by Victor Cantu on 8/12/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ChatMessageView: Div {
    
    override class var name: String { "div" }

    let type: RoomType
    
    var note: CustSocialMessage
    
    let users: [CustUsername]
    
    init(
        type: RoomType,
        note: CustSocialMessage,
        users: [CustUsername]
        
    ) {
        self.type = type
        self.note = note
        self.users = users
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var defaultImage = "/skyline/media/tierraceroRoundLogoBlack.svg"
    
    @State var userName = "..."
    
    ///new, sent, recived, read
    @State var status: MessageStatus = .new
    
    @State var msgStatus = ""
    
    @State var messageText = ""
    
    lazy var userAvatar = Img().src("/skyline/media/defaultPanda.png")
    
    lazy var mediaImage = Img().src(self.$defaultImage)
    
    lazy var mediaAsincLoader = Div()
    
    var userTokens: [String] = []
    
    @DOM override var body: DOM.Content {
        
        switch type {
        case .userToUser:
            if note.senderid == custCatchMyChatToken {
                loadUserMesage(self.note)
            }
            else{
                loadCounterMesage(self.note)
            }
        case .public:
            
            if let senderid = note.senderid  {
                if userTokens.contains(senderid) {
                    loadUserMesage(self.note)
                }
                else{
                    loadCounterMesage(self.note)
                }
            }
            else {
                loadUserMesage(self.note)
            }
            
        case .siweToSiwe:
            Div().class(.clear)
        case .customerService:
            Div().class(.clear)
        case .social:
            
            if note.isMine {
                loadUserMesage(self.note)
            }
            else{
                loadCounterMesage(self.note)
            }
            
        case .siweToUser:
            Div().class(.clear)
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        backgroundColor(.grayBlack)
        
        $status.listen {
            switch $0 {
            case .new:
                self.msgStatus = "/skyline/media/wait_msg_status.png"
            case .sent:
                self.msgStatus = "/skyline/media/pend_msg_status.png"
            case .recived:
                self.msgStatus = "/skyline/media/delv_msg_status.png"
            case .read:
                self.msgStatus = "/skyline/media/read_msg_status.png"
            }
        }
        
        status = note.status
        
        messageText = note.message
        
        defaultImage = "/skyline/media/tierraceroRoundLogoWhite.svg"
        
        userTokens = users.map{ $0.usertoken }
        
        var userRefrence: [String : CustUsername] = [:]
        
        users.forEach { user in
            userRefrence[user.usertoken] = user
        }
        
        switch type {
        case .userToUser:
            break
        case .public:
            if let senderid = note.senderid {
                if let user = userRefrence[senderid] {
                    userName = user.nick
                }
                else{
                    userName = "Cliente"
                }
            }
            else {
                userName = "ChatBot"
            }
            
        case .siweToSiwe:
            break
        case .customerService:
            break
        case .social:
            
            if note.isMine {
                
                if let id = self.note.senderid {
                    
                    getUserRefrence(id: .folio(id)) { user in
                        
                        guard let user else {
                            self.userName = "Sistema"
                            return
                        }
                        
                        if !user.avatar.isEmpty {
                            self.userAvatar.load("/contenido/\(user.avatar)")
                        }
                        
                        if user.username.contains("@") {
                            self.userName = "@\(user.username.explode("@").first ?? user.firstName)"
                        }
                        else{
                            self.userName = user.firstName
                        }
                    }
                }
                else{
                    self.userName = "Sistema"
                }
            }
            else {
                if let id = self.note.senderid {
                    
                    getSocialAccountRefrence(id: .folio(id)) { user in
                        
                        guard let user else {
                            self.userName = "Cliente"
                            return
                        }
                        
                        if !user.avatar.isEmpty {
                            self.userAvatar.load(user.avatar)
                        }
                        
                        self.userName = user.name
                        
                    }
                }
            }
            
        case .siweToUser:
            break
        }
        
        
        switch note.type {
        case .msg:
            break
        case .msgQry:
            break
        case .msgRsp:
            break
        case .img:
            
            var parts = note.message.explode("/")
            
            let file = parts.last ?? ""
            
            parts.removeLast()
            
            mediaImage
                .load(self.note.message)
                .cursor(.pointer)
                .onClick {
                    addToDom(MediaViewer(
                        relid: nil,
                        type: .orderChat,
                        url: parts.joined(separator: "/") + "/",
                        files: [.init(
                            fileId: self.note.id,
                            file: file,
                            avatar: file,
                            type: .image
                        )],
                        currentView: 0
                    ))
                }
            
        case .doc:
            break
        case .link:
            break
        case .voice:
            break
        case .vdo:
            break
        }
        
    }
    
    func loadCounterMesage(_ note: CustSocialMessage) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(12.px)
            
            Div{
                Span(self.$userName).marginRight(12.px)
                Span("\(cratedAt.formatedLong) \(cratedAt.time)")
            }
            .align(.left)
            .marginLeft(12.px)
            .marginRight(12.px)
            .color(.gray)
            
            Div().class(.clear).marginTop(3.px)
            
            /// msg, msgQry, msgRsp, img, doc, link, voice, vdo
            switch self.note.type {
            case .msg, .msgQry, .msgRsp:
                Div{
                    self.mediaAsincLoader
                    Span(self.$messageText)
                }
                    .textAlign(.left)
                    .float(.left)
                    .marginLeft(35.px)
                    .backgroundColor(.gray)
                    .color(.white)
                    .maxWidth(70.percent)
                    .display(.tableCell)
                    .padding(all: 10.px)
                    .borderRadius(all: 24.px)
                    .fontSize(18.px)
            case .img:
                Div{
                    self.mediaImage
                        .width(300.px)
                }
                .textAlign(.left)
                .float(.left)
                .marginLeft(35.px)
                .backgroundColor(.gray)
                .color(.white)
                .maxWidth(70.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .borderRadius(all: 24.px)
                .fontSize(18.px)
                
            case .doc:
                Span("Un suoported media")
            case .link:
                Span("Un suoported media")
            case .voice:
                Span("Un suoported media")
            case .vdo:
                Span("Un suoported media")
            }
            
            Div().class(.clear).marginTop(3.px)
            
            /// Icons && user
            Div{
                Div{
                    Div{
                        self.userAvatar
                            .width(100.percent)
                            .height(100.percent)
                    }
                    .borderRadius(all: 22.5.px)
                    .overflow(.hidden)
                    .width(35.px)
                    .height(35.px)
                    .position(.relative)
                    .top(-25.px)
                    .right(-7.px)
                    .backgroundColor(.white)
                    .border(width: .medium, style: .solid, color: .lightGray)
                }
                .width(35.px)
                .height(20.px)
                
            }
            .align(.left)
            
            Div().class(.clear).marginTop(3.px)
        }
        
    }
    
    func loadUserMesage(_ note: CustSocialMessage) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(12.px)
            
            Div{
                Span("\(cratedAt.formatedLong) \(cratedAt.time)")
                Span(self.$userName).marginLeft(12.px)
            }
            .align(.right)
            .color(.gray)
            .marginLeft(12.px)
            .marginRight(12.px)
            
            Div().class(.clear).marginTop(3.px)
            
            switch self.note.type {
            case .msg, .msgQry, .msgRsp:
                Div{
                    self.mediaAsincLoader
                    Span(self.$messageText)
                }
                    .textAlign(.right)
                    .float(.right)
                    .marginRight(35.px)
                    .backgroundColor(.dodgerBlue)
                    .color(.white)
                    .maxWidth(70.percent)
                    .display(.tableCell)
                    .padding(all: 10.px)
                    .borderRadius(all: 24.px)
                    .fontSize(18.px)
            case .img:
                Div{
                    self.mediaImage
                        .width(300.px)
                }
                .textAlign(.right)
                .float(.right)
                .marginRight(35.px)
                .color(.white)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .borderRadius(all: 24.px)
                .fontSize(18.px)
            case .doc:
                Span("Un suoported media")
            case .link:
                Span("Un suoported media")
            case .voice:
                Span("Un suoported media")
            case .vdo:
                Span("Un suoported media")
            }
            
            Div().class(.clear).marginTop(3.px)
            
            /// Icons && user
            Div{
                
                Div{
                    
                    Div{
                        self.userAvatar
                            .width(100.percent)
                            .height(100.percent)
                    }
                    .borderRadius(all: 22.5.px)
                    .overflow(.hidden)
                    .width(35.px)
                    .height(35.px)
                    .position(.relative)
                    .top(-25.px)
                    .left(-7.px)
                    .backgroundColor(.white)
                    .border(width: .medium, style: .solid, color: .lightGray)
                    
                    Div{
                        Img()
                            .src(self.$msgStatus)
                            .width(18.px)
                    }
                    .overflow(.hidden)
                    .width(18.px)
                    .height(18.px)
                    .position(.relative)
                    .top(-42.px)
                    .left(-44.px)
                    
                }
                .width(35.px)
                .height(20.px)
                
            }
            .align(.right)
            
            Div().class(.clear).marginTop(3.px)
        }
        
    }
    
    func loadGeneralMesage(_ note: CustSocialMessage) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(12.px)
            
            Div("\(cratedAt.formatedLong) \(cratedAt.time)")
                .align(.left)
                .color(.gray)
                .marginLeft(12.px)
                .marginRight(12.px)
            
            Div().class(.clear).marginTop(3.px)
            
            switch self.note.type {
            case .msg, .msgQry, .msgRsp:
                Div{
                    self.mediaAsincLoader
                    Span(self.$messageText)
                }
                    .textAlign(.left)
                    .float(.left)
                    .marginLeft(35.px)
                    .color(.lightGray)
                    .maxWidth(70.percent)
                    .display(.tableCell)
                    .padding(all: 10.px)
                    .borderRadius(all: 24.px)
                    .fontSize(18.px)
            case .img:
                Div{
                    self.mediaImage
                        .width(300.px)
                }
                .textAlign(.left)
                .float(.left)
                .marginLeft(35.px)
                .color(.white)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .borderRadius(all: 24.px)
                .fontSize(18.px)
                
            case .doc:
                Span("Un suoported media")
            case .link:
                Span("Un suoported media")
            case .voice:
                Span("Un suoported media")
            case .vdo:
                Span("Un suoported media")
            }
           
            Div().class(.clear).marginTop(3.px)
             
            /// Icons && user
            Div{
                Div{
                    Div{
                        self.userAvatar
                            .width(100.percent)
                            .height(100.percent)
                    }
                    .borderRadius(all: 22.5.px)
                    .overflow(.hidden)
                    .width(35.px)
                    .height(35.px)
                    .position(.relative)
                    .top(-25.px)
                    .right(-7.px)
                    .backgroundColor(.white)
                    .border(width: .medium, style: .solid, color: .lightGray)
                }
                .width(35.px)
                .height(20.px)
                
            }
            .align(.left)
            
            Div().class(.clear)
            
            Div(self.$userName)
                .marginLeft(12.px)
                .marginRight(12.px)
                .align(.right)
                .color(.gray)
            
            Div().class(.clear).marginTop(3.px)
        }
        
    }
    
    func updateMessageStatus(_ newStatus: MessageStatus) {
        
        // Current Status
        switch status {
        case .new:
            switch newStatus{
            case .new:
                /// new to new does not requier update
                break
            case .sent, .recived, .read:
                status = newStatus
            }
        case .sent:
            switch newStatus{
            case .new, .sent:
                /// does not requier update
                break
            case .recived, .read:
                status = newStatus
            }
        case .recived:
            switch newStatus{
            case .new, .sent, .recived:
                /// does not requier update
                break
            case .read:
                status = newStatus
            }
        case .read:
            break
        }
        
    }
    
    func newMedia(mediaUrl: URLConformable) {
        messageText = ""
        mediaAsincLoader.appendChild(Img()
            .src("https://\(custCatchUrl)/contenido/defaultLogoBlackSquare.svg")
            .load(mediaUrl)
            .width(300.px)
        )
    }
}
