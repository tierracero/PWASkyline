//
//  SocialManagerPostPageRow.swift
//  
//
//  Created by Victor Cantu on 4/12/23.
//

import TCFundamentals
import Foundation
import Web

class SocialManagerPostPageRow: Div {
    
    override class var name: String { "div" }
    
    let caption: String
    
    let manager: CustSocialPostManagment
    
    let page: CustSocialPageQuick?
    
    /*
    private var callback: ((
        _ action: CustSaleActionQuick
    ) -> ())
    */
    
    init(
        caption: String,
        manager: CustSocialPostManagment,
        page: CustSocialPageQuick?
        /*
        callback: @escaping ((
            _ action: CustSaleActionQuick
        ) -> ())
         */
    ) {
        self.caption = caption
        self.manager = manager
        self.page = page
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
    @State var comments = ""
    
    lazy var pageAvatar = Img()
        .src("/skyline/media/scicon_\(self.manager.profileType.rawValue).jpg")
        .custom("width", "calc(100% - 10px)")
        .borderRadius(12.px)
        .padding(all: 5.px)
    
    @DOM override var body: DOM.Content {
        
        Div{
            self.pageAvatar
        }
            .align(.center)
            .width(100.px)
            .float(.left)
        
        Div {
            
            Div{
                
                Img()
                    .src("/skyline/media/scicon_\(self.manager.profileType.rawValue).jpg")
                    .borderRadius(7.px)
                    .marginRight(3.px)
                    .float(.left)
                    .width(28.px)
                
                Div(self.$pageName)
                    .custom("width", "calc(100% - 24)")
                    .class(.oneLineText)
                    .color(.white)
                    .float(.left)
                
                Div().class(.clear)
                
            }
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
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        self.class(.uibtnLarge)
            .width(97.percent)
        
        like = manager.like.toString
        
        dislike = manager.dislike.toString
        
        love = manager.love.toString
        
        care = manager.care.toString
        
        wow = manager.wow.toString
        
        haha = manager.haha.toString
        
        sorry = manager.sorry.toString
        
        angry = manager.angry.toString
        
        other = manager.other.toString
        
        comments = manager.comments.toString
        
        if let page {
            
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
}
