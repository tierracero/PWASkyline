//
//  ServiceNotAvailbleViewControler.swift
//  
//
//  Created by Victor Cantu on 12/5/22.
//

import Foundation
import Web

public class ServiceNotAvailbleViewControler: PageController {
    
    @DOM public  override var body: DOM.Content {
        Div {
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
        }
        .position(.fixed)
        .width(100.percent)
        .height(100.percent)
        .background(.linearGradient(angle: -30, .black/20, .rgb( 14, 27, 40)/80, .black))
    }
    
    public override func buildUI() {
        super.buildUI()
        
        title = "Tierra Cero"
        metaDescription = "Hacemos tu empresa más grande"
        
        height(100.percent)
        width(100.percent)
        
        rendered()

    }
    
    override public func didAddToDOM() {
        
        super.didAddToDOM()
        
        if let _ = isMobile() {
            History.pushState(path: "app")
            return
        }
        
    }
}

