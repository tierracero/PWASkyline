//
//  MoneyManager+NewDailyCut+FinancialRow.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.NewDailyCutView {
    
    class FinancialRow: Div {
        
        override class var name: String { "div" }
        
        let item: API.custAPIV1.FinancialsRender
        
        private var selectionChange: ((
        ) -> ())
        
        init(
            _ item: API.custAPIV1.FinancialsRender,
            selectionChange: @escaping ((
            ) -> ())
        ) {
            self.item = item
            self.selectionChange = selectionChange
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var isChecked = true
        
        @DOM override var body: DOM.Content {
            
            /// Toggle
            Div{
                InputCheckbox(self.$isChecked)
                    .marginLeft(12.px)
                    .onChange {
                        self.selectionChange()
                    }
            }
            .align(.left)
            .width(5.percent)
            .float(.left)
            /// Date
            Div(getDate(self.item.createdAt).formatedLong)
                .width(15.percent)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .width(15.percent)
                .minHeight(20.px)
                .float(.left)
            /// Origin Order sale
            Div("\(self.item.type.description) \(self.item.comments) \(self.item.amount.formatMoney)")
                .width(50.percent)
                .minHeight(20.px)
                .float(.left)
            /// Cost
            Div(self.item.balance.formatMoney)
                .textAlign(.right)
                .width(15.percent)
                .minHeight(20.px)
                .float(.left)
            
        }
        
        override func buildUI() {
            super.buildUI()
            marginTop(3.px)
            
        }
    }
}
