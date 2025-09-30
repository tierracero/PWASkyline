//
//  ManagePOC+Amazon.swift
//
//
//  Created by Victor Cantu on 10/5/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ManagePOC {
    
    class Amazon: Div {
        
        let amazon: CustPOC.Amazon
        
        init(
            amazon: CustPOC.Amazon
        ) {
            self.amazon = amazon
            
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
