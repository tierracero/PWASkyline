//
//  SocialManagerPostView.swift
//  
//
//  Created by Victor Cantu on 4/12/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest

class SocialManagerPostView: Div {
    
    override class var name: String { "div" }
    
    
    let post: CustSocialPostMain
    
    /*
    private var callback: ((
        _ action: CustSaleActionQuick
    ) -> ())
    */
    
    init(
        post: CustSocialPostMain
        /*
        callback: @escaping ((
            _ action: CustSaleActionQuick
        ) -> ())
         */
    ) {
        self.post = post
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var like = ""
    @State var dislike = ""
    @State var love = ""
    @State var care = ""
    @State var wow = ""
    @State var haha = ""
    @State var sorry = ""
    @State var angry = ""
    @State var other = ""
    @State var comments = ""
    
    @State var managers: [CustSocialPostManagment] = []
    
    var pageRefrence: [String:CustSocialPageQuick] = [:]
    
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
                    .closeButton(.subView)
                    .onClick{
                        self.remove()
                    }
                
                H2("Ver interacciones sociales")
                    .color(.titleBlue)
                    .float(.left)
                
            }
            
            Div().class(.clear)
            
            Div {
                
                self.mediaContainer
                
                Div {
                    
                    Div(self.post.title)
                        .class(.oneLineText)
                        .marginBottom(12.px)
                        .fontSize(24.px)
                        .color(.white)
                    
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
                        Div(self.$comments)
                            .color(self.$comments.map{ ($0 == "0") ? .gray : .white })
                            .marginRight(7.px)
                            .fontSize(18.px)
                            .float(.left)
                        
                        
                        
                    }
                    
                }
                .custom("width", "calc(100% - 112px)")
                .padding(all: 3.px)
                .margin(all: 3.px)
                .float(.left)
                
            }
           
            Div().class(.clear)
            
            ForEach(self.$managers){ manager in
                SocialManagerPostPageRow(
                    caption: self.post.title,
                    manager: manager,
                    page: self.pageRefrence[manager.pageid]
                )
                .onClick {
                    
                    guard let page = self.pageRefrence[manager.pageid] else {
                        showError(.unexpectedResult, "No se localizo datos de la pagina")
                        return
                    }

                    loadingView(show: true)

                    API.custAPIV1.getSocialPostManager(
                        managerid: manager.id,
                        profileType: manager.profileType,
                        postType: manager.postType,
                        pageid: manager.pageid,
                        postid: manager.postid,
                        mediaid: manager.mediaid
                    ) { resp in

                        loadingView(show: false)

                        guard let resp else {
                            showError(.errorDeCommunicacion, .serverConextionError)
                            return
                        }

                        guard resp.status == .ok  else{
                            showError(.errorGeneral, resp.msg)
                            return
                        }
                        
                        guard let payload = resp.data else {
                            return
                        }
                        //CustAPIEndpointV1.GetSocialPostManagerResponse
                        
                        addToDom(SocialManagerPostManagerView(
                            caption: self.post.title,
                            post: self.post,
                            manager: manager,
                            page: page,
                            reactions: payload.reactions,
                            comments: payload.comments
                        ))
                        
                    }
                }
            }
            
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
        
        like = post.like.toString
        
        dislike = post.dislike.toString
        
        love = post.love.toString
        
        care = post.care.toString
        
        wow = post.wow.toString
        
        haha = post.haha.toString
        
        sorry = post.sorry.toString
        
        angry = post.angry.toString
        
        other = post.other.toString
        
        comments = post.comments.toString
        
        loadingView(show: true)
        
        API.custAPIV1.getSocialPost(mainid: self.post.id) { resp in
        
            loadingView(show: false)
            
            guard let resp else {
                showError(.errorDeCommunicacion, .serverConextionError)
                return
            }
            
            guard resp.status == .ok else {
                showError(.errorGeneral, resp.msg)
                return
            }
            
            guard let payload = resp.data else {
                showError(.unexpectedResult, "No se obtuvo payload de data.")
                return
            }
            
            payload.pages.forEach { page in
                self.pageRefrence[page.pageid] = page
            }
            
            self.managers = payload.managers
            
        }
    }
}
