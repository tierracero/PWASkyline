//
//  ManagePOC+ClaroShop.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class ClaroShop: Div {
        
        let claroShop: CustPOC.ClaroShop
        
        init(
            claroShop: CustPOC.ClaroShop
        ) {
            self.claroShop = claroShop
            
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
