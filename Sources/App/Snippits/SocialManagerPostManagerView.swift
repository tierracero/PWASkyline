//
//  SocialManagerPostManagerView.swift
//  
//
//  Created by Victor Cantu on 4/12/23.
//
import TCFundamentals
import Foundation
import TCSocialCore
import Web

class SocialManagerPostManagerView: Div {
    
    override class var name: String { "div" }
    
    let caption: String
    
    let post: CustSocialPostMain
    
    let manager: CustSocialPostManagment
    
    let page: CustSocialPageQuick
    
    let reactions: [Reaction]
    
    @State var comments: [Comment]
    
    /*
    private var callback: ((
        _ action: CustSaleActionQuick
    ) -> ())
    */
    
    init(
        caption: String,
        post: CustSocialPostMain,
        manager: CustSocialPostManagment,
        page: CustSocialPageQuick,
        reactions: [Reaction],
        comments: [Comment]
        /*
        callback: @escaping ((
            _ action: CustSaleActionQuick
        ) -> ())
         */
    ) {
        self.caption = caption
        self.post = post
        self.manager = manager
        self.page = page
        self.reactions = reactions
        self.comments = comments
        super.init()
    }
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var pageName = ""
    
    @State var like = ""
    @State var dislike = ""
    @State var love = ""
    @State var care = ""
    @State var wow = ""
    @State var haha = ""
    @State var sorry = ""
    @State var angry = ""
    @State var other = ""
    
    lazy var pageAvatar = Img()
        .src("/skyline/media/scicon_\(self.page.profileType.rawValue).jpg")
        .custom("width", "calc(100% - 10px)")
        .borderRadius(12.px)
        .padding(all: 5.px)
    
    lazy var mediaContainer = Div()
        .align(.center)
        .width(100.px)
        .float(.left)
        .onClick {
            
        }
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            /// Header
            Div {
                
                Img()
                    .closeButton(.uiView2)
                    .onClick{
                        self.remove()
                    }
                
                H2("Ver interacciones sociales")
                    .color(.titleBlue)
                    .float(.left)
                
            }
            
            Div().class(.clear).marginBottom(7.px)
            
            Div{
                
                Div{
                    
                    self.mediaContainer
                    
                    Div{
                        
                        Img()
                            .src("/skyline/media/scicon_\(self.page.profileType.rawValue).jpg")
                            .borderRadius(7.px)
                            .marginRight(3.px)
                            .float(.left)
                            .width(28.px)
                        
                        Div(self.$pageName)
                            .class(.oneLineText)
                            .fontSize(24.px)
                            .color(.white)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                        Div{
                            
                            // like
                            Div{
                                Img()
                                    .src("/skyline/media/icon_like.png")
                                    .padding(all: 3.px)
                                    .width(18.px)
                            }
                            .float(.left)
                            Div(self.$like)
                                .color(self.$like.map{ ($0 == "0") ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                            
                            // dislike
                            Div{
                                Img()
                                    .src("/skyline/media/icon_dislike.png")
                                    .padding(all: 3.px)
                                    .width(18.px)
                            }.float(.left)
                            Div(self.$dislike)
                                .color(self.$dislike.map{ ($0 == "0") ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                            
                            // love
                            Div{
                                Img()
                                    .src("/skyline/media/icon_love.png")
                                    .padding(all: 3.px)
                                    .width(18.px)
                            }.float(.left)
                            Div(self.$love)
                                .color(self.$love.map{ ($0 == "0") ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                            
                            // care
                            Div{
                                Img()
                                    .src("/skyline/media/icon_care.png")
                                    .padding(all: 3.px)
                                    .width(18.px)
                            }.float(.left)
                            
                            Div(self.$care)
                                .color(self.$care.map{ ($0 == "0") ? .gray : .white })
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
                            .float(.left)
                            Div(self.$wow)
                                .color(self.$wow.map{ ($0 == "0") ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                        }
                        
                        Div().class(.clear)
                        
                        Div{
                    
                            // haha
                            Div{
                                Img()
                                    .src("/skyline/media/icon_haha.png")
                                    .padding(all: 3.px)
                                    .width(18.px)
                            }
                            .float(.left)
                            Div(self.$haha)
                                .color(self.$haha.map{ ($0 == "0") ? .gray : .white })
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
                            .float(.left)
                            Div(self.$sorry)
                                .color(self.$sorry.map{ ($0 == "0") ? .gray : .white })
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
                            .float(.left)
                            Div(self.$angry)
                                .color(self.$angry.map{ ($0 == "0") ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                            
                            // other
                            Div{
                                Img()
                                    .src("/skyline/media/icon_other.png")
                                    .padding(all: 3.px)
                                    
                                    .width(18.px)
                            }.float(.left)
                            Div(self.$other)
                                .color(self.$other.map{ ($0 == "0") ? .gray : .white })
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
                            .float(.left)
                            Div(self.$comments.map{ $0.count.toString })
                                .color(self.$comments.map{ $0.isEmpty ? .gray : .white })
                                .marginRight(7.px)
                                .fontSize(18.px)
                                .float(.left)
                        }
                        
                    }
                    .custom("width", "calc(100% - 112px)")
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .color(.white)
                    .float(.left)
                }
                
                Div().class(.clear)
            
                ForEach(self.$comments){ comment in
                    SocialManagerPostCommentRow(
                        mainid: self.post.id,
                        managerid: self.manager.id,
                        postid: self.manager.postid,
                        parentCommentId: nil,
                        page: self.page,
                        comment: comment
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
                    .marginBottom(12.px)
                }
                
            }
            .custom("height", "calc(100% - 32px)")
            .overflow(.auto)
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 250px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(80.percent)
        .top(10.percent)
        .width(500.px)
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        switch post.postType {
        case .text:
            mediaContainer.appendChild(
                Img()
                .src("/skyline/media/skylineapp.svg")
                .custom("width", "calc(100% - 10px)")
                .borderRadius(12.px)
                .padding(all: 5.px)
            )
        case .image:
            mediaContainer.appendChild(
                Img()
                .src("https://\(custCatchUrl)/contenido/thump_\(post.media)")
                .custom("width", "calc(100% - 10px)")
                .borderRadius(12.px)
                .padding(all: 5.px)
            )
        case .video, .shorts:
            mediaContainer.appendChild(
                Img()
                .src("https://\(custCatchUrl)/contenido/thump_\(post.media.replace(from: ".mp4", to: ".jpg"))")
                .custom("width", "calc(100% - 10px)")
                .borderRadius(12.px)
                .padding(all: 5.px)
            )
        case .threeDimentions:
            mediaContainer.appendChild(
                Img()
                .src("/skyline/media/skylineapp.svg")
                .custom("width", "calc(100% - 10px)")
                .borderRadius(12.px)
                .padding(all: 5.px)
            )
        }
        
        var _like = 0
        var _dislike = 0
        var _love = 0
        var _care = 0
        var _wow = 0
        var _haha = 0
        var _sorry = 0
        var _angry = 0
        var _other = 0
        let comments = comments.count.toString
        
        reactions.forEach { reaction in
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
        
        pageName = page.name
        
        if !page.username.isEmpty {
            pageName += " @\(page.username)"
        }
        
        var url = ""
        
        if page.profileType == .facebook {
            url = "https://graph.facebook.com/\(page.pageid)/picture?type=square"
        }
        else if page.profileType == .instagram {
            url = page.avatar
            
        }
        
        if !url.isEmpty {
            pageAvatar.load(url)
        }
        
    }
}
