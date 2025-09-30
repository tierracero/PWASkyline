//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+NominasView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class NominasView: Div {

        override class var name: String { "div" }
        
        @State var nominas: [CustNominaConfiguration]

        init(
            nominas: [CustNominaConfiguration]
        ) {
            self.nominas = nominas
        
            super.init()
            
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var selectedNominaId: UUID? = nil

        @DOM override var body: DOM.Content {
            Div()
        }

        override func buildUI() {
            super.buildUI()
            
            height(100.percent)
            width(100.percent)
            
        }
    
    }
}