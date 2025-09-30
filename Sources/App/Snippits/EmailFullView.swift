//
//  EmailFullView.swift
//  
//
//  Created by Victor Cantu on 2/19/23.
//

import TCFundamentals
import Foundation
import MailAPICore
import Web

class EmailFullView: Div {
    
    override class var name: String { "div" }
    
    public let subject: String
    
    public let box: String
    
    public let uid: Int
    
    public let header: MessageHeader
    
    public let mailBody: String
    
    public let attachment: [MessageAttachment]
    
    private var deleteMail: ((
    ) -> ())
    
    private var replyMail: ((
    ) -> ())
    
    init(
        subject: String,
        box: String,
        uid: Int,
        header: MessageHeader,
        mailBody: String,
        attachment: [MessageAttachment],
        deleteMail: @escaping ((
        ) -> ()),
        replyMail: @escaping ((
        ) -> ())
    ) {
        
        self.subject = subject
        self.box = box
        self.uid = uid
        self.header = header
        self.mailBody = mailBody
        self.attachment = attachment
        self.deleteMail = deleteMail
        self.replyMail = replyMail
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var viewTitle = ""
    
    lazy var emailView = Div()
        .custom("width", "calc(100% - 324px)")
        .height(100.percent)
        .marginRight(7.px)
        .overflow(.auto)
        .float(.left)
    
    lazy var attachmentsView = Div()
    
    @DOM override var body: DOM.Content {
        Div{
        
            /// Header
            Div{
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2(self.$viewTitle)
                    .color(.white)
                
            }
            
            Div().class(.clear).height(7.px)
            
            Div{
                
                self.emailView
                    .overflow(.hidden)
                
                Div {
                    
                    Div{
                        Div {
                            
                            Img()
                                .src("/skyline/media/mail_trash.png")
                                .marginRight(24.px)
                                .class(.iconWhite)
                                .cursor(.pointer)
                                .height(24.px)
                                .onClick {
                                    API().mailV1.delete(
                                        username: custCatchUser,
                                        box: self.box,
                                        uid: self.uid
                                    ) { resp in
                                        guard let resp else {
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            return
                                        }
                                        
                                        self.deleteMail()
                                        
                                        self.remove()
                                    }
                                }
                            
                            Img()
                                .src("/skyline/media/mail_replay.png")
                                .marginRight(24.px)
                                .class(.iconWhite)
                                .cursor(.pointer)
                                .height(24.px)
                                .onClick {
                                    self.replyMail()
                                    self.remove()
                                }
                            
                        }
                        .backgroundColor(.grayBlackDark)
                        .borderRadius(12.px)
                        .padding(all: 3.px)
                        .margin(all: 3.px)
                        .align(.center)
                        
                        H3("Archivos Adjuntos")
                            .marginBottom(7.px)
                            .color(.white)
                        
                        self.attachmentsView
                    }
                    .custom("height","calc(100% - 6px)")
                    .margin(all: 3.px)
                }
                .class(.roundDarkBlue)
                .height(99.percent)
                .padding(all: 3.px)
                .margin(all: 3.px)
                .width(300.px)
                .float(.left)
            }
            .custom("height", "calc(100% - 40px)")
            .marginTop(7.px)
        }
        .backgroundColor(.grayBlack)
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .width(80.percent)
        .left(10.percent)
        .top(10.percent)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        self.viewTitle = "\(self.header.from.personal) | \(self.subject)"

        let iframe = IFrame()
            .srcDoc(
                self.mailBody
                .replace(from: "javascript", to: "JS")
                .replace(from: "script", to: "s-cript")
                .replace(from: ".js", to: "")
            )
            .backgroundColor(.white)
            .height(100.percent)
            .width(100.percent)
            
        emailView.appendChild(iframe)
        
        attachment.forEach { file in
            let view = Div{
                Img()
                    .src("/skyline/media/clip.png")
                    .borderRadius(11.px)
                    .margin(all: 2.px)
                    .class(.iconWhite)
                    .height(14.px)
                    .width(14.px)
                
                Span(file.fileName)
            }
            .class(.uibtnLarge)
            .width(95.percent)
            .onClick {
                API().mailV1.downloadAttachment(
                    username: custCatchUser,
                    box: self.box,
                    uid: self.uid,
                    fileName: file.fileName
                )
            }
            
            attachmentsView.appendChild(view)
        }
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    
}
