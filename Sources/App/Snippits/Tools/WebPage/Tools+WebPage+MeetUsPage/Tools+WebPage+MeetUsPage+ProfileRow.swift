//
//  Tools+WebPage+MeetUsPage+ProfileRow.swift
//  
//
//  Created by Victor Cantu on 1/24/25.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.WebPage.MeetUsPage {
    
    class ProfileRow: Div {
        
        override class var name: String { "div" }
        
        let item: CustWebContent
        
        @State var name: String
        
        @State var descr: String
        
        private var callback: ((
            _ view: ProfileRow
        ) -> ())
        
        init(
            item: CustWebContent,
            callback: @escaping ((
                _ view: ProfileRow
            ) -> ())
        ) {
            self.item = item
            self.name = item.name
            self.descr = item.description
            self.callback = callback
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var avatar = Img()
            .src("/skyline/media/tierraceroRoundLogoWhite.svg")
            .borderRadius(12.px)
            .objectFit(.cover)
            .height(60.px)
            .width(60.px)
        
        @DOM override var body: DOM.Content {
            
            Div {
                
                Div {
                    self.avatar
                }
                .margin(all: 3.px)
                .align(.center)
                .width(76.px)
                .float(.left)
                
                Div {
                    H3(self.$name)
                        .color(.white)
                    
                    Div().clear(.both).height(3.px)
                    
                    H4(self.$descr)
                        .color(.gray)
                }
                .custom("width", "calc(100% - 89px)")
                .class(.oneLineText)
                .margin(all: 3.px)
                .float(.left)
                
            }
            .class(.uibtnLarge)
            .width(97.percent)
            .onClick {
                self.callback(self)
            }
            
            
        }
        
        override func didAddToDOM() {
            super.didAddToDOM()
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            if !item.avatar.isEmpty {
                avatar.load("https://\(custCatchUrl)/contenido/thump_\(item.avatar)")
            }
            
        }
        
    }
}

