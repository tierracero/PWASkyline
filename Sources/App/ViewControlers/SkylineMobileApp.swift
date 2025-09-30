//
//  SkylineMobileApp.swift
//  
//
//  Created by Victor Cantu on 3/21/22.
//

import Foundation
import TCFundamentals
import Web
import JavaScriptKit


public class SkylineMobileApp: PageController {
	
	let appstoreLink = "https://itunes.apple.com/us/app/tierracero/id1177994758?l=es&mt=8"
	let playstoreLink = "https://play.google.com/store/apps/details?id=com.cdominguez.tierracerov3"
	
	@State var fontIsLoaded: Bool = false
	@State var cssIsLoaded: Bool = false
	@State var redirectMessage: String = ""
	@State var os: PushNotificationTokensPlatform? = nil
	
	lazy var loader = LoaderView()
	
	@DOM public override var body: DOM.Content {
		
        Link()
            .href("https://fonts.googleapis.com/css?family=IBM+Plex+Sans:400,600")
            .rel(.stylesheet)
            .onLoad {
                self.fontIsLoaded = true
            }
        
        Link()
            .href("/skyline/css/login.css")
            .rel(.stylesheet)
            .onLoad {
                self.cssIsLoaded = true
            }
        
        
		self.loader
		
		Div {
			Div{
				Table{
					Tr{
						Td{
							Img()
								.src("skyline/media/skylineapp.svg")
								.width(256.px)
								.height(256.px)
						}
						.paddingRight(24.px)
						.verticalAlign(.middle)
						.align(.center)
					}
				}
				.width(100.percent)
				.height(100.percent)
			}
			.height(100.percent)
			.class(.oneTwoFlex)
			
			Div{
				Table{
					Tr{
						Td{
							
							H1("Descarga el App")
								.class(.heroTitle, .mt0)
							
							Div().class(.clear)
								.marginBottom(12.px)
							
							A{
								Img()
									.src("skyline/media/appstoreIcon.svg")
									.width(256.px)
									.custom("height", "auto")
							}
							.href(self.appstoreLink)
							.hidden(self.$os.map({
								if $0 == .iOS || $0 == .Other {
									return false
								}
								else{
									return true
								}
							}))
							
							Div().class(.clear)
								.marginBottom(12.px)
							
							A{
								Img()
									.src("skyline/media/playstoreIcon.svg")
									.width(256.px)
									.custom("height", "auto")
							}
							.href(self.playstoreLink)
							.hidden(self.$os.map({
								if $0 == .Android || $0 == .Other {
									return false
								}
								else{
									return true
								}
							}))
							
							Div().class(.clear)
								.marginBottom(12.px)
							
							P(self.$redirectMessage)
								.class(.heroParagraph)
							
						}
						.paddingLeft(24.px)
						.verticalAlign(.middle)
						.align(.center)
					}
				}
				.width(100.percent)
				.height(100.percent)
			}
			.height(100.percent)
			.class(.oneTwoFlex)
			
			Div{
				Div("Apple y el logotipo de Apple son marcas comerciales de Apple Inc., registradas en EE. UU. y otros países. App Store es una marca de servicio de Apple Inc.")
					.hidden(self.$os.map({
						if $0 == .iOS || $0 == .Other {
							return false
						}
						else{
							return true
						}
					}))
				Div("Google Play y el logotipo de Google Play son marcas comerciales de Google Inc.")
					.hidden(self.$os.map({
						if $0 == .Android || $0 == .Other {
							return false
						}
						else{
							return true
						}
					}))
			}
			.class(.bottomFooterText)
			
			
		}
		.position(.fixed)
		.overflow(.auto)
		.width(100.percent)
		.height(100.percent)
        .background(.linearGradient(angle: -30, .black/20, .rgb( 14, 27, 40)/80, .black))
        
        
	}
	
	public override func buildUI() {
		super.buildUI()
        
        height(100.percent)
        width(100.percent)
        
        $fontIsLoaded.listen {
            if self.fontIsLoaded && self.cssIsLoaded {
                self.loader.remove()
            }
        }
        
        $cssIsLoaded.listen {
            if self.fontIsLoaded && self.cssIsLoaded {
                self.loader.remove()
            }
        }
        
          title = "Tierra Cero"
          metaDescription = "Descarga el app"
          redirectMessage = "Eliga su tienda para continuar."

		rendered()  
        
	}
    
    override public func didAddToDOM() {
        super.didAddToDOM()
        
        guard let os = isMobile() else {
            self.os = .Other
            return
        }
        
        self.os = os
        
        if os == .iOS || os == .Android {
            self.goToStore(os: os, time: 5)
        }
         
    }
    
	
	func goToStore(os: PushNotificationTokensPlatform, time: Int){
        
		guard os == .iOS || os == .Android else {
			return
		}
		
		if time < 0 {
			self.redirectMessage = "Haz clic en la tienda si no eres auto redifigido."
			if os == .iOS {
                Window.shared.jsValue.object?.open.function?.callAsFunction(optionalThis: JSObject.global.window.object, appstoreLink, "_self")
			}
			if os == .Android {
                Window.shared.jsValue.object?.open.function?.callAsFunction(optionalThis: JSObject.global.window.object, appstoreLink, "_self")
			}
			return
		}
		
		self.redirectMessage = "Redirigindo a tinda de aplicaciones en \(time)"
		
		Dispatch.asyncAfter(1) {
			print((time - 1))
			self.goToStore(os: os, time: (time - 1))
		}
		
	}
}

