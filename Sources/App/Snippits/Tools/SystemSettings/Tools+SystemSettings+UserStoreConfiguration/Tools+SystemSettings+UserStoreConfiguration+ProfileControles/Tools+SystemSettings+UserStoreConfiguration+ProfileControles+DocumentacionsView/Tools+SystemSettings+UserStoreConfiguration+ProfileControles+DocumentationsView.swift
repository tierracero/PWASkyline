//
//  Tools+SystemSettings+UserStoreConfiguration+ProfileControles+DocumentacionsView.swift
//  
//
//  Created by Victor Cantu on 6/9/24.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension ToolsView.SystemSettings.UserStoreConfiguration.ProfileControles {
    
    class DocumentacionsView: Div {

        override class var name: String { "div" }
        
        @State var books: [CustDocumentationBookManagerQuick]
        
        @State var rules: [CustDocumentationRuleManagerQuick] = []
        
        @State var article: [CustDocumentationArticleManagerQuick] = []
        
        /// [ CustDocumentationBookManager.id : [CustDocumentationRuleManagerQuick] ]
        var rulesRefrence: [ UUID : [CustDocumentationRuleManagerQuick] ]
        
        /// [ CustDocumentationRuleManager.id : [CustDocumentationArticleManagerQuick] ]
        var articleRefrence: [ UUID : [CustDocumentationArticleManagerQuick] ]

        init(
            books: [CustDocumentationBookManagerQuick],
            rulesRefrence: [UUID : [CustDocumentationRuleManagerQuick]],
            articleRefrence: [UUID : [CustDocumentationArticleManagerQuick]]
        ) {
            self.books = books
            self.rulesRefrence = rulesRefrence
            self.articleRefrence = articleRefrence

            super.init()
        }

        required init() {
          fatalError("init() has not been implemented")
        }
        
        @State var selectedBookId: UUID? = nil

        @State var selectedRuleId: UUID? = nil

        @State var selectedArticleId: UUID? = nil

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