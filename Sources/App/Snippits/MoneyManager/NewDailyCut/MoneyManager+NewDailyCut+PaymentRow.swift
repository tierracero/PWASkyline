//
//  MoneyManager+NewDailyCut+PaymentRow.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.NewDailyCutView {
    
    class PaymentRow: Div {
        
        override class var name: String { "div" }
        
        let item: API.custAPIV1.PaymentToRender
        
        let relatedFolio: String
        
        private var selectionChange: ((
        ) -> ())
        
        init(
            item: API.custAPIV1.PaymentToRender,
            relatedFolio: String,
            selectionChange: @escaping ((
            ) -> ())
        ) {
            self.item = item
            self.relatedFolio = relatedFolio
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
                    .onClick {
                        self.selectionChange()
                    }
            }
            .align(.left)
            .width(80.px)
            .float(.left)
            /// Date
            Div(getDate(self.item.createdAt).formatedShort)
                .width(120.px)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .width(120.px)
                .float(.left)
            /// Origin Order sale
            Div(self.relatedFolio)
                .width(120.px)
                .float(.left)
            /// Description
            Div("\(self.item.description) \(self.item.fiscCode.description) \(self.item.ref)  \(self.item.auth)")
                .custom("width", "calc(100% - 570px)")
                .class(.oneLineText)
                .float(.left)
            /// Cost
            Div(self.item.cost.formatMoney)
                .width(120.px)
                .textAlign(.right)
                .float(.left)
            Div().clear(.both)
            
        }
        
        override func buildUI() {
            super.buildUI()
            marginTop(3.px)
            
        }
    }
}


