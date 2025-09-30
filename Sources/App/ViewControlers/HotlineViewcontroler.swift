//
//  HotlineViewcontroler.swift
//  
//
//  Created by Victor Cantu on 12/5/22.
//

import TCFundamentals
import TCFireSignal
import Foundation
import Web

public class HotlineViewcontroler: PageController {
    
    lazy var viewContainer = Div()
        .height(100.percent)
        .width(100.percent)
    
    @DOM public  override var body: DOM.Content {
        self.viewContainer
    }
    
    public override func buildUI() {
        super.buildUI()
        
        height(100.percent)
        width(100.percent)
        
        
        self.position(.fixed)
        
        self.background(.linearGradient(angle: -30, .black/20, .rgb( 14, 27, 40)/80, .black))
        
        title = "Tierra Cero"
        
        metaDescription = "Hacemos tu empresa más grande"
    
        let view = AnaliticsView(asMainView: true, notification: .dueAlert(dueIn: .due))
        self.viewContainer.appendChild(view)
        
        WebApp.current.document.head.body {
            
            Script()
                .src("https://code.jquery.com/jquery-3.7.1.js")
                .type("text/javascript")
                .onLoad {
                    print("https://code.jquery.com/jquery-3.7.1.js  🟢")
                }
            
            Script()
                .src("https://code.jquery.com/ui/1.14.1/jquery-ui.js")
                .type("text/javascript")
                .onLoad {
                    print("https://code.jquery.com/ui/1.14.1/jquery-ui.js  🟢")
                }
            
            Script()
                .src("https://js.openpay.mx/openpay.v1.min.js")
                .type("text/javascript")
                .onLoad {
                    print("https://js.openpay.mx/openpay.v1.min.js  🟢")
                }
        }
        
        rendered()
        
    }
    
    override public func didAddToDOM() {
        super.didAddToDOM()
    }
    
}

