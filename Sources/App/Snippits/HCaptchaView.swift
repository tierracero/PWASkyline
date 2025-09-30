//
//  HCaptchaView.swift
//  
//
//  Created by Victor Cantu on 1/8/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class HCaptchaView: Div {
    
    override class var name: String { "div" }
    
    private var callback: ((
        _ response: String
    ) -> ())
    
     init(
         callback: @escaping ((
            _ response: String
         ) -> ())
     ) {
         self.callback = callback
         
         super.init()
         
     }
     
     required init() {
         fatalError("init() has not been implemented")
     }
    
    @DOM override var body: DOM.Content {
        
        
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.subView)
                    .onClick {
                        self.remove()
                    }
                
                Strong("Captcha")
                    .color(.lightBlueText)
                    .float(.left)
                    .marginLeft(7.px)
                
            }
            
            Div().clear(.both)
            
            Div{
                
                Div()
                    .data("callback", "hCaptchaTokenUpdater")
                    .data("sitekey", hCaptchaSiteKey)
                    .id("hCaptchaDiv")
                    /*
                     add data-error-callback
                     https://docs.hcaptcha.com/configuration
                     */
                    .class(.hCaptcha)
            }
            .marginBottom(12.px)
            .marginTop(12.px)
            .align(.center)
            .height(78.px)
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(50% - 175px)")
        .custom("top", "calc(50% - 100px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 7.px)
        .height(200.px)
        .width(350.px)
        
    }
    
    override func buildUI() {
        self.class(.transparantBlackBackGround)
        height(100.percent)
        width(100.percent)
        position(.fixed)
        left(0.px)
        top(0.px)
        
        Window.shared.addEventListener("hCaptchaToken", options: .init(capture: true, once: false, passive: false)) { event in
            
            Console.clear()
            
            Console.dir(event.jsEvent)
            
            if !CustomEvent(event.jsEvent).detail.isEmpty {
                print("🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  🟢  ")
                self.callback(CustomEvent(event.jsEvent).detail)
                self.remove()
            }
            else {
                print("❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ❌  ")
            }
            
        }
        
    }
    
    override public func didAddToDOM() {
        _ = JSObject.global.hcaptcha.render("hCaptchaDiv")
    }
    
}

