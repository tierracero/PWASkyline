//
//  ManagePOC+Enremate.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class Enremate: Div {
        
        let enremate: CustPOC.EnRemate
        
        init(
            enremate: CustPOC.EnRemate
        ) {
            self.enremate = enremate
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
            Div("Pending Implementation")
        }
        
        override func buildUI() {
            super.buildUI()
            
        }
        
    }
}
