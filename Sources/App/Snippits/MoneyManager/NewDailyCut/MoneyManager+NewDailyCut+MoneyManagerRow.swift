//
//  MoneyManager+NewDailyCut+MoneyManagerRow.swift
//  
//
//  Created by Victor Cantu on 7/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView.NewDailyCutView {
    
    class MoneyManagerRow: Div {
        
        override class var name: String { "div" }
        
        let item: CustMoneyManager
        
        private var selectionChange: ((
        ) -> ())
        
        init(
            _ item: CustMoneyManager,
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
                    .onClick {
                        self.selectionChange()
                    }
            }
            .width(10.percent)
            .align(.left)
            .float(.left)
            /// Date
            Div(getDate(self.item.createdAt).formatedShort)
                .width(10.percent)
                .float(.left)
            /// Folio
            Div(self.item.folio)
                .width(10.percent)
                .float(.left)
            /// Pagos
            Div(self.item.paymentsTotal.formatMoney)
                .width(10.percent)
                .float(.left)
            /// Dinero
            Div(self.item.financialsTotal.formatMoney)
                .width(10.percent)
                .float(.left)
            /// Gastos
            Div(self.item.expensesTotal.formatMoney)
                .width(10.percent)
                .float(.left)
            /// Depositos
            Div(self.item.inBoxNew.formatMoney)
                .width(10.percent)
                .float(.left)
            /// Faltantes
            Div(self.item.faltante.formatMoney)
                .width(10.percent)
                .float(.left)
            /// Cortes
            Div(self.item.moneyManagerTotal.formatMoney)
                .width(10.percent)
                .float(.left)
            /// SubTotoles
            Div(self.item.total.formatMoney)
                .textAlign(.right)
                .width(10.percent)
                .float(.left)
            Div().clear(.both)
        
        }
        
        override func buildUI() {
            super.buildUI()
            marginTop(3.px)
            
        }
    }
}
