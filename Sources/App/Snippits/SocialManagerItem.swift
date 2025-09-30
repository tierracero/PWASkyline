//
//  SocialManagerItem.swift
//  
//
//  Created by Victor Cantu on 10/19/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web
import XMLHttpRequest
class SocialManagerItem: Div {
    
    override class var name: String { "div" }
 
    let page: CustSocialPageQuick
    
    init(
        page: CustSocialPageQuick
    ){
        self.page = page
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var isCheked = true
    
    var url = ""
    
    @DOM override var body: DOM.Content {
        
        Img()
            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            .load(self.page.avatar)
            .borderRadius(all: 20.percent)
            .padding(all: 3.px)
            .height(50.px)
            .float(.left)
        
        Div{
            Div{
                Img()
                    .src("/skyline/media/scicon_\(self.page.profileType.rawValue).jpg")
                    .borderRadius(all: 30.percent)
                    .overflow(.hidden)
                    .marginRight(3.px)
                    .height(12.px)
                    
                Span(self.page.profileType.description).color(.gray)
                    .fontSize(12.px)
                
                Div().class(.clear)
            }
            
            Div(self.page.name)
                .class(.oneLineText)
                .fontSize(29.px)
        }
        .custom("width", "calc(100% - 130px)")
        .marginLeft(7.px)
        .color(.white)
        .float(.left)
        
        Div{
            InputCheckbox().toggle(self.$isCheked)
        }
        .marginLeft(3.px)
        .marginTop(12.px)
        .width(50.px)
        .float(.left)
        
        Div().class(.clear)
    }
    
    
    override func buildUI() {
        self.class(.roundDarkBlue)
        marginBottom(3.px)
        
        if self.page.profileType == .facebook {
            url = "https://graph.facebook.com/\(self.page.pageid)/picture?type=square"
        }
        else if self.page.profileType == .instagram {
            url = self.page.avatar
        }
        
        super.buildUI()
    }
    
}
