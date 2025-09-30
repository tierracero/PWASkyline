//
//  MessageObject.swift
//  
//
//  Created by Victor Cantu on 6/1/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class MessageObject: Div {
    
    override class var name: String { "div" }
    
    let type: MediaDownloadType
    
    let relid: UUID
    
    let name: String
    /// light, dark
    @State var style: StyleType
    
    var note: CustOrderLoadFolioNotes
    
    init(
        type: MediaDownloadType,
        relid: UUID,
        name: String,
        /// light, dark
        style: StyleType,
        note: CustOrderLoadFolioNotes
    ) {
        self.type = type
        self.relid = relid
        self.name = name
        self.style = style
        self.note = note
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var titleColor: Color = .black
    
    @State var bodyColor: Color = .gray
    
    @State var footerColor: Color = .lightGray
    
    @State var defaultImage = "/skyline/media/tierraceroRoundLogoBlack.svg"
    
    @State var activity = ""
    
    @State var userName = "..."
    
    @State var loadPercent = ""
    
    @State var videoSrc = ""
    
    @State var poster = ""
    
    @State var waStatus: WAMessageStatus? =  nil
    
    @State var messageStatus: String = ""
    
    /// [SocialReactionItem]
    @State var reactions: [SocialReactionItem] = []
    
    let viewid: UUID = .init()
    
    lazy var userAvatar = Img()
        .src("/skyline/media/defaultPanda.png")
    
    lazy var watslcon: Img = .init()
    lazy var telelcon: Img = .init()
    lazy var mediaImage = Img()
        .cursor(self.$activity.map{ $0.isEmpty ? .default : .pointer })
        .src(self.$defaultImage)
        .width(100.percent)
        .onClick {
            
            if self.activity.isEmpty {
                return
            }
            
            addToDom(MediaViewer(
                relid: self.relid,
                type: self.type,
                url: "https://\(custCatchUrl)/fileNet/",
                files: [.init(
                    fileId: nil,
                    file: self.activity,
                    avatar: self.activity,
                    type: .image
                )],
                currentView: 0
            ))
        }
    
    @DOM override var body: DOM.Content {
        switch note.type {
        case .all,  .work,  .webNote:
            H2("Elemento no Soportado")
        case .webNoteClie:
            loadCustomerMesage(self.note)
        case .webNoteClieBlur:
            loadCustomerMesage(self.note)
                .opacity(0.5)
        case .webNoteRep:
            loadUserMesage(self.note)
        case .webNoteRepBlur:
            loadUserMesage(self.note)
                .opacity(0.5)
        case  .webNoteAuto,  .webNoteAutoBlur:
            loadGeneralMesage(self.note)
        case .autoNota, .general, .gps, .fraude, .product,  .payment, .charge,  .bizFinance,  .altaPrioridad:
            loadGeneralMesage(self.note)
        }
    }
    
    override func buildUI() {
        super.buildUI()
        
        switch self.style {
        case .light:
            backgroundColor(.white)
        case .dark:
            backgroundColor(.grayBlack)
            
            titleColor = .gray
            bodyColor = .lightGray
            footerColor = .gray
            
            defaultImage = "/skyline/media/tierraceroRoundLogoWhite.svg"
            
        }
        
        if let id = self.note.createdBy {
            getUserRefrence(id: .id(id)) { user in
                
                guard let user = user else {
                    self.userName = "Sistema"
                    return
                }
                
                if !user.avatar.isEmpty {
                    self.userAvatar.load("https://\(custCatchUrl)/contenido/\(user.avatar)")
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
        
        switch self.note.subType {
        case .msg:
            activity = note.activity
        case .msgQry:
            activity = note.activity
        case .msgRsp:
            activity = note.activity
        case .img:
            if !self.note.activity.isEmpty {
                activity = note.activity
                self.mediaImage.load("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
            }
        case .doc:
            break
        case .link:
            break
        case .voice:
            break
        case .vdo:
            videoSrc = "https://\(custCatchUrl)/fileNet/\(self.note.activity)"
            poster = "https://\(custCatchUrl)/fileNet/\(self.note.activity)".replace(from: ".mp4", to: ".jpg")
            activity = note.activity
        }
        
        $waStatus.listen {
            
            guard let status = $0 else {
                return
            }
            
            switch status {
            case .pending:
                self.messageStatus = "/skyline/media/pend_msg_status.png"
            case .sent:
                self.messageStatus = "/skyline/media/wait_msg_status.png"
            case .delivered:
                self.messageStatus = "/skyline/media/delv_msg_status.png"
            case .viewed:
                self.messageStatus = "/skyline/media/read_msg_status.png"
            }
        }
        
        waStatus = note.waStatus
        
        reactions = note.reactions
        
    }
    
    func loadCustomerMesage(_ note: CustOrderLoadFolioNotes) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                
                Span("\(cratedAt.formatedLong) \(cratedAt.time)")
                    .marginRight(7.px)
                
                Strong(self.name)
                    .color(self.$style.map{ ($0 == .light) ? .black : .white })
                
                
            }
            .color(self.$titleColor)
            .marginRight(12.px)
            .marginLeft(12.px)
            .fontSize(13.px)
            .align(.left)
            
            Div().class(.clear).marginTop(3.px)
            
            switch self.note.subType {
            case .msg,  .msgQry, .msgRsp:
                Div(self.$activity)
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
                    Div{
                        self.mediaImage
                    }
                    .width(70.percent)
                    .float(.left)
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
               
                Div{
                    Img().src("/skyline/media/attachment.png")
                        .width(100.px)
                    
                    Div().class(.clear)
                    
                    Div(self.note.activity)
                        .class(.oneLineText)
                        .color(.lightGray)
                        .textAlign(.right)
                        .fontSize(12.px)
                        .width(100.px)
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
            case .link:
                Span("Un suoported media")
            case .voice:
                Div{
                    Audio()
                        .controls(true)
                        .src("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
                        .width(250.px)
                        .controls(true)
                }
                .textAlign(.left)
                .marginRight(35.px)
                .color(.white)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .borderRadius(all: 24.px)
                .fontSize(18.px)
                .paddingLeft(32.px)
            case .vdo:
                Div{
                    Video{
                        Source()
                            .src(self.$videoSrc)
                    }
                    .poster(self.$poster)
                    .width(70.percent)
                    .controls(true)
                }
                .textAlign(.left)
                .marginRight(35.px)
                .color(.white)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .borderRadius(all: 24.px)
                .fontSize(18.px)
                .paddingLeft(32.px)
            }
            
            Div().class(.clear).marginTop(3.px)
            
            /// Icons && user
            Div{
                
                if self.note.subType == .img || self.note.subType == .doc  {
                    Img()
                        .src("/skyline/media/download2.png")
                        .paddingRight(83.percent)
                        .paddingTop(-7.percent)
                        .cursor(.pointer)
                        .float(.right)
                        .height(18.px)
                        .onClick {
                            self.downloadMedia(
                                file: self.note.activity,
                                type: .orderChat,
                                size: .fullSize
                            )
                        }
                }
                
                Div{
                    Div{
                        self.userAvatar
                            .width(100.percent)
                            .height(100.percent)
                    }
                    .border(width: .medium, style: .solid, color: .lightGray)
                    .borderRadius(all: 22.5.px)
                    .backgroundColor(.white)
                    .position(.relative)
                    .overflow(.hidden)
                    .height(35.px)
                    .width(35.px)
                    .top(-25.px)
                    .right(-7.px)
                }
                .height(20.px)
                .width(35.px)
                
            }
            .align(.left)
            
            Div().class(.clear).marginTop(3.px)
            
            
        }
    }
    
    func loadUserMesage(_ note: CustOrderLoadFolioNotes) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                Span("\(cratedAt.formatedLong) \(cratedAt.time)")
                    .marginRight(7.px)
                Strong(self.$userName)
                    .color(self.$style.map{ ($0 == .light) ? .black : .white })
            }
            .color(self.titleColor)
            .marginRight(12.px)
            .marginLeft(12.px)
            .fontSize(13.px)
            .align(.right)
            
            Div().class(.clear).marginTop(3.px)
            
            switch self.note.subType {
            case .msg,  .msgQry, .msgRsp:
                Div(self.$activity)
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
                    
                    Div{
                        self.mediaImage
                            .width(100.percent)
                            .cursor(.pointer)
                            .onClick {
                                addToDom(MediaViewer(
                                    relid: self.relid,
                                    type: self.type,
                                    url: "https://\(custCatchUrl)/fileNet/",
                                    files: [.init(
                                        fileId: nil,
                                        file: self.note.activity,
                                        avatar: self.note.activity,
                                        type: .image
                                    )],
                                    currentView: 0
                                ))
                            }
                    }
                    .width(70.percent)
                    .float(.right)
                }
                .borderRadius(all: 24.px)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .marginRight(35.px)
                .textAlign(.right)
                .fontSize(18.px)
                .color(.white)
                .float(.right)
                
            case .doc:
                Div{
                    Img().src("/skyline/media/attachment.png")
                        .width(100.px)
                    Div().class(.clear)
                    Div(self.note.activity)
                        .color(.lightGray)
                        .fontSize(16.px)
                        .width(100.px)
                        
                }
                .borderRadius(all: 24.px)
                .maxWidth(50.percent)
                .display(.tableCell)
                .padding(all: 10.px)
                .marginRight(35.px)
                .textAlign(.right)
                .fontSize(18.px)
                .float(.right)
                .color(.white)
            case .link:
                Span("Un supported media")
            case .voice:
                
                Div{
                    Audio()
                        .controls(true)
                        .src("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
                        .width(250.px)
                        .controls(true)
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
                
            case .vdo:
                
                Div{
                    Video{
                        Source()
                            .src("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
                    }
                    .width(25.percent)
                    .controls(true)
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
                
            }
            
            Div().class(.clear).marginTop(3.px)
            
            /// Icons && user
            
            Div{
                
                Div{
                    self.userAvatar
                        .width(100.percent)
                        .height(100.percent)
                }
                .border(width: .medium, style: .solid, color: .lightGray)
                .borderRadius(all: 22.5.px)
                .backgroundColor(.white)
                .position(.relative)
                .overflow(.hidden)
                .height(35.px)
                .width(35.px)
                .top(-25.px)
                .left(-7.px)
            }
            .float(.right)
            .height(20.px)
            .width(35.px)
            
            Img()
                .hidden(self.$messageStatus.map{ $0.isEmpty })
                .src(self.$messageStatus)
                //.cursor(.pointer)
                .marginRight(7.px)
                .marginTop(3.px)
                .height(18.px)
                .float(.right)
            
            
            Div{
                ForEach(self.$reactions) { reaction in
                    Span(reaction.name)
                        .marginRight(7.px)
                        .marginTop(3.px)
                        .height(18.px)
                        .float(.right)
                }
            }
            .float(.right)
            .height(20.px)
            .width(35.px)
            
            if self.note.subType == .img  || self.note.subType == .doc {
                Img()
                    .src("/skyline/media/download2.png")
                    .marginRight(7.px)
                    .cursor(.pointer)
                    .marginTop(3.px)
                    .float(.right)
                    .height(18.px)
                    .onClick {
                        self.downloadMedia(
                            file: self.note.activity,
                            type: .orderChat,
                            size: .fullSize
                        )
                    }
            }
             
            Div().clear(.both).marginTop(3.px)
            
        }
    }
    
    func loadGeneralMesage(_ note: CustOrderLoadFolioNotes) -> Div {
        
        let cratedAt = getDate(note.createdAt)
        
        return Div {
            
            Div().class(.clear).marginTop(3.px)
            
            Div{
                Span("\(cratedAt.formatedLong) \(cratedAt.time)")
                    .marginRight(7.px)
                
                Strong(self.$userName)
                    .color(self.$style.map{ ($0 == .light) ? .black : .white })
            }
                .align(.left)
                .fontSize(13.px)
                .marginLeft(12.px)
                .marginRight(12.px)
                .color(self.$titleColor)
            
            Div().class(.clear).marginTop(3.px)
            
            switch self.note.subType {
            case .msg,  .msgQry, .msgRsp:
                
                if self.note.type == .altaPrioridad {
                    Div(self.$activity)
                        .color(r: 255, g: 84, b: 84)
                        .borderRadius(all: 24.px)
                        .maxWidth(70.percent)
                        .display(.tableCell)
                        .padding(all: 10.px)
                        .marginLeft(35.px)
                        .textAlign(.left)
                        .fontSize(24.px)
                        .float(.left)
                    
                    Div().height(3.px).clear(.both)
                    
                    Div{
                        Div("Bajar Prioridad")
                            .class(.uibtn)
                            .onClick {
                                self.lowerNotePriority()
                            }
                    }
                    .align(.right)
                    
                }
                else {
                    
                    Div(self.$activity)
                        .borderRadius(all: 24.px)
                        .color(self.$bodyColor)
                        .maxWidth(70.percent)
                        .display(.tableCell)
                        .padding(all: 10.px)
                        .marginLeft(35.px)
                        .textAlign(.left)
                        .fontSize(18.px)
                        .float(.left)
                }
                
            case .img:
                Div{
                    self.mediaImage
                        .width(25.percent)
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
                
                Div{
                    Img().src("/skyline/media/attachment.png")
                        .width(70.percent)
                    Div().class(.clear)
                    Span(self.note.activity)
                        .fontSize(16.px)
                        .color(.lightGray)
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
                
                
            case .link:
                Span("Un suoported media")
            case .voice:
                Div{
                    Audio()
                        .controls(true)
                        .src("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
                        .width(250.px)
                        .controls(true)
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
                
                
                
            case .vdo:
                Div{
                    Video{
                        Source()
                            .src("https://\(custCatchUrl)/fileNet/\(self.note.activity)")
                    }
                    .width(25.percent)
                    .controls(true)
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
    
    func downloadMedia(file: String, type: MediaDownloadType, size: MediaDownloadSize){
        
        let url = baseSkylineAPIUrl(ie: "downloadMediaFile") +
        "&file=\(file)" +
        "&type=\(type.rawValue)" +
        "&size=\(size)" +
        "&storeid=\(custCatchStore.uuidString)"
        
        _ = JSObject.global.goToURL!(url)
    }
    
    func lowerNotePriority(){
        
        addToDom(ConfirmationView(
            type: .yesNo,
            title: "Bajar Prioridad",
            message: "¿Esta seguro que desea bajar la prioridad de la nota?",
            callback: { isConfirmed, comment in
                
                API.custAPIV1.lowerNotePriority(
                    noteId: .order(self.note.id)
                ) { resp in
                    loadingView(show: false)
                    
                    guard let resp else {
                        showError(.errorDeCommunicacion, "No se pudo comunicar con el servir para obtener usuario")
                        return
                    }
                    
                    guard resp.status == .ok else {
                        showError(.errorGeneral, resp.msg)
                        return
                    }
                    
                    showSuccess(.operacionExitosa, "Se cambio la prioridad")
                    
                }
                
            }
        ))
        
    }
    
    func loadImage(_ image: String ){
        
        mediaImage.load("https://\(custCatchUrl)/fileNet/thump_\(image)")
        
        activity = image
        
    }
    
    func updateReactions(reactions: [SocialReactionItem]) {
        self.reactions = reactions
    }
    
}
