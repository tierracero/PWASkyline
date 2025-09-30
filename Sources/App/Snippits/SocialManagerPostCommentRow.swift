//
//  SocialManagerPostCommentRow.swift
//  
//
//  Created by Victor Cantu on 4/14/23.
//

import TCFundamentals
import Foundation
import TCSocialCore
import Web

class SocialManagerPostCommentRow: Div {
    
    override class var name: String { "div" }
    
    let mainid: UUID
    
    let managerid: UUID
    
    let postid: String
    
    let parentCommentId: String?
    
    let page: CustSocialPageQuick
    
    let comment: Comment
    
    private var removeComment: ((
        _ commentid: String
    ) -> ())
    
    
    init(
        mainid: UUID,
        managerid: UUID,
        postid: String,
        parentCommentId: String?,
        page: CustSocialPageQuick,
        comment: Comment,
        removeComment: @escaping ((
            _ commentid: String
        ) -> ())
    ) {
        self.mainid = mainid
        self.managerid = managerid
        self.postid = postid
        self.parentCommentId = parentCommentId
        self.page = page
        self.comment = comment
        self.removeComment = removeComment
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var date = ""
    
    @State var message = ""
    
    lazy var mediaContainer = Div()
        .margin(all: 3.px)
        .padding(all: 3.px)
        .align(.center)
    
    @State var like = ""
    @State var dislike = ""
    @State var love = ""
    @State var care = ""
    @State var wow = ""
    @State var haha = ""
    @State var sorry = ""
    @State var angry = ""
    @State var other = ""
    
    @State var comments: [Comment] = []
    
    @State var hasAttachment = false
    
    @State var newComment = ""
    
    lazy var newCommentField = InputText(self.$newComment)
        .placeholder("Ingrese comentario...")
        .custom("width","calc(100% - 107px)")
        .class(.textFiledBlackDark)
        .backgroundColor(.rgb(1, 1, 1))
        .height(31.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Div{
                
                Img()
                    .float(.right)
                    .src("/skyline/media/cross.png")
                    .cursor(.pointer)
                    .height(24.px)
                    .onClick { img, event in
                        
                        addToDom(ConfirmView(
                            type: .yesNo,
                            title: "¿Desea eliminar comentatio?",
                            message: "Confirme que desea eliminar el comentario",
                            callback: { isConfirmed, comment in
                                
                                if isConfirmed {
                                    
                                    loadingView(show: true)
                                    
                                    API.custAPIV1.deleteSocialComment(
                                        profileType: self.page.profileType,
                                        pageid: self.page.pageid,
                                        commentid: self.comment.commentid
                                    ) { resp in
                                        
                                        loadingView(show: false)
                                        
                                        guard let resp else {
                                            showError(.errorDeCommunicacion, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            showError(.errorGeneral, resp.msg)
                                            return
                                        }
                                        
                                        self.removeComment(self.comment.commentid)
                                        
                                        
                                    }
                                }
                            }
                        ))
                        
                        event.stopPropagation()
                        
                    }
                
                Span(self.$date)
                    .paddingRight(7.px)
                    .float(.right)
                
                Span(self.comment.from.name)
                    .color(.yellowTC)
            }
            .fontSize(16.px)
            .color(.gray)
            
            Div().class(.clear)
            
            
            if self.parentCommentId == nil {
                
                H2(self.$message)
                    .hidden(self.$message.map{ $0.isEmpty })
                    .marginBottom(7.px)
                    .fontSize(24.px)
                    .color(.white)
            }
            else {
                
                H3(self.$message)
                    .hidden(self.$message.map{ $0.isEmpty })
                    .marginBottom(7.px)
                    .fontSize(24.px)
                    .color(.lightGray)
            }
            
            
            
            Div().class(.clear)
            
            self.mediaContainer
                .hidden(self.$hasAttachment.map{ !$0 } )
                .marginBottom(7.px)
            
            Div().class(.clear)
            
            /// ``Reaction``
            Div{
                
                // like
                Div{
                    Img()
                        .src("/skyline/media/icon_like.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .float(.left)
                .hidden(self.$like.map{ $0 == "0"})
                Div(self.$like)
                    .color(self.$like.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$like.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // dislike
                Div{
                    Img()
                        .src("/skyline/media/icon_dislike.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$dislike.map{ $0 == "0"})
                .float(.left)
                Div(self.$dislike)
                    .color(self.$dislike.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$dislike.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // love
                Div{
                    Img()
                        .src("/skyline/media/icon_love.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$love.map{ $0 == "0"})
                .float(.left)
                Div(self.$love)
                    .color(self.$love.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$love.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // care
                Div{
                    Img()
                        .src("/skyline/media/icon_care.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$care.map{ $0 == "0"})
                .float(.left)
                Div(self.$care)
                    .color(self.$care.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$care.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // wow
                Div{
                    Img()
                        .src("/skyline/media/icon_wow.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$wow.map{ $0 == "0"})
                .float(.left)
                Div(self.$wow)
                    .color(self.$wow.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$wow.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // haha
                Div{
                    Img()
                        .src("/skyline/media/icon_haha.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$haha.map{ $0 == "0"})
                .float(.left)
                Div(self.$haha)
                    .color(self.$haha.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$haha.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // sorry
                Div{
                    Img()
                        .src("/skyline/media/icon_sorry.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$sorry.map{ $0 == "0"})
                .float(.left)
                Div(self.$sorry)
                    .color(self.$sorry.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$sorry.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // angry
                Div{
                    Img()
                        .src("/skyline/media/icon_angry.png")
                        .padding(all: 3.px)
                        
                        .width(18.px)
                }
                
                .hidden(self.$angry.map{ $0 == "0"})
                .float(.left)
                Div(self.$angry)
                    .color(self.$angry.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$angry.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // other
                Div{
                    Img()
                        .src("/skyline/media/icon_other.png")
                        .padding(all: 3.px)
                        
                        .width(18.px)
                }
                .hidden(self.$other.map{ $0 == "0"})
                .float(.left)
                Div(self.$other)
                    .color(self.$other.map{ ($0 == "0") ? .gray : .white })
                    .hidden(self.$other.map{ $0 == "0"})
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
                // comments
                Div{
                    Img()
                        .src("/skyline/media/icon_email_white.png")
                        .padding(all: 3.px)
                        .width(18.px)
                }
                .hidden(self.$comments.map{ $0.isEmpty})
                .float(.left)
                Div(self.$comments.map{ $0.count.toString })
                    .color(self.$comments.map{ ($0.isEmpty) ? .gray : .white })
                    .hidden(self.$comments.map{ $0.isEmpty })
                    .marginRight(7.px)
                    .fontSize(18.px)
                    .float(.left)
                
            }
            .marginBottom(7.px)
            
            Div().class(.clear)
            
            ForEach(self.$comments){ subcomment in
                SocialManagerPostCommentRow(
                    mainid: self.mainid,
                    managerid: self.managerid,
                    postid: self.postid,
                    parentCommentId: self.comment.commentid,
                    page: self.page,
                    comment: subcomment
                ){ commentid in
                    
                    var _comments: [Comment] = []
                    
                    self.comments.forEach { comment in
                        
                        if comment.commentid == commentid {
                            return
                        }
                        
                        _comments.append(comment)
                        
                    }
                    
                    self.comments = _comments
                    
                }
                .marginBottom(7.px)
            }
            .marginBottom(7.px)
            
            
            Div().class(.clear)
            
            if (self.parentCommentId == nil) {
                Div{
                    
                    self.newCommentField
                    
                    Div("Enviar")
                        .backgroundColor(.rgb(1, 1, 1))
                        .class(.uibtn)
                        .fontSize(21.px)
                        .float(.right)
                        .onClick {
                            self.createComment()
                        }
                }
            }
        }
    }
    
    override func didAddToDOM() {
        
        super.didAddToDOM()
        
        self.class(.uibtnLarge)
            .width(97.percent)
        
        var _like = 0
        var _dislike = 0
        var _love = 0
        var _care = 0
        var _wow = 0
        var _haha = 0
        var _sorry = 0
        var _angry = 0
        var _other = 0
        
        let uts = getDate(comment.createdAt)
        
        date = "\(uts.formatedLong) \(uts.time)"
        
        message = comment.message
        
        comments = comment.comments
        
        if let attachment = comment.attachment {
            
            hasAttachment = true
            
            switch attachment.type {
            case .image:
                mediaContainer.appendChild(
                    Img()
                        .src(attachment.url)
                        .borderRadius(12.px)
                        .padding(all: 5.px)
                        .width(200.px)
                )
            case .video:
                mediaContainer.appendChild(
                    Img()
                        .src(attachment.url)
                        .borderRadius(12.px)
                        .padding(all: 5.px)
                        .width(200.px)
                )
            case .audio:
                break
            case .pdf:
                break
            case .doc:
                break
            case .xml:
                break
            case .ptt:
                break
            case .pages:
                break
            case .numbers:
                break
            case .keynote:
                break
            case .general:
                break
            }
            
        }
        
        comment.reactions.forEach { reaction in
            
            switch reaction.type {
            case .none:
                _other += 1
            case .like:
                _like += 1
            case .dislike:
                _dislike += 1
            case .love:
                _love += 1
            case .care:
                _care += 1
            case .wow:
                _wow += 1
            case .haha:
                _haha += 1
            case .sorry:
                _sorry += 1
            case .angry:
                _angry += 1
            }
            
        }
        
        like = _like.toString
        dislike = _dislike.toString
        love = _love.toString
        care = _care.toString
        wow = _wow.toString
        haha = _haha.toString
        sorry = _sorry.toString
        angry = _angry.toString
        other = _other.toString
        
    }
    
    func createComment() {
        
        newComment = newComment.purgeHtml.purgeSpaces
        
        if newComment.isEmpty {
            newCommentField.select()
            return
        }
        
        loadingView(show: true)
        
        var commentid = comment.commentid
        
        if let _commentid = self.parentCommentId {
            commentid = _commentid
        }
        
        API.custAPIV1.addSocialComment(
            mainid: self.mainid,
            managerid: self.managerid,
            profileType: page.profileType,
            pageid: page.pageid,
            postid: self.postid,
            commentid: commentid,
            message: newComment
        ) { resp in
            
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError )
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let newmsg = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }
            
            self.comments.append(newmsg)
            
        }
        
    }
    
}

