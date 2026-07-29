//
//  SplashScreen.swift
//  
//
//  Created by Victor Cantu on 3/18/22.
//

import Foundation
import Web

public class SplashScreen: PageController {
	
	@DOM public override var body: DOM.Content {
		Div {
            /*
			Table{
				Tr{
					Td{
						Img()
							.src("skyline/media/tierraceroRoundLogoWhite.svg")
							.width(256.px)
							.height(256.px)
							
					}
					.verticalAlign(.middle)
					.align(.center)
				}
			}
			.width(100.percent)
			.height(100.percent)
            */
		}
		.position(.fixed)
		.width(100.percent)
		.height(100.percent)
        .backgroundColor(.init(r: 29, g: 32, b: 38))
	}
	
	public override func buildUI() {
		super.buildUI()
		
		title = "Tierra Cero"
		metaDescription = "Hacemos tu empresa más grande"
        
        rendered( )

	}
    
    override public func didAddToDOM() {
        
        super.didAddToDOM()
        
        if let _ = isMobile() {
            History.pushState(path: "app")
            return
        }
        
        loadBasicStatus { status in
            
            guard let status else {
                Dispatch.asyncAfter(0) {
                    /// Session
                    History.pushState(path: "login")
                }
                return
            }
            
            if status == .hotline {
                /// go to  suspendad page
                History.pushState(path: "hotline")
                return
            }
            else if status == .active {
                if !skylineLandingPage.isEmpty {
                    History.pushState(path: skylineLandingPage)
                    return
                }
                History.pushState(path: "work")
            }
            else {
                
            }
            
        }
        
        
        
    }
}
