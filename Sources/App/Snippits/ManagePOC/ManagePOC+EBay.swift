//
//  ManagePOC+EBay.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class EBay: Div {
        
        let ebay: CustPOC.EBay
        
        init(
            ebay: CustPOC.EBay
        ) {
            self.ebay = ebay
            
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
