//
//  Budget+HistoricItemsView.swift
//  
//
//  Created by Victor Cantu on 12/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension BudgetView {
    
    class HistoricItemsView: Div {
        
        override class var name: String { "div" }
        
        let accountId: UUID
        
        let orderId: UUID
        
        private var callback: ((
            _ budget: API.custOrderV1.LoadServiceOrderBudgetsResponse
        ) -> ())
        
        init(
            accountId: UUID,
            orderId: UUID,
            callback: @escaping ((
                _ budget: API.custOrderV1.LoadServiceOrderBudgetsResponse
            ) -> ())
        ) {
            self.accountId = accountId
            self.orderId = orderId
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        lazy var itemsView = Div()
            .padding(all: 1.px)
            .margin(all: 1.px)
        
        @DOM override var body: DOM.Content {
            
            Div{
            
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView3)
                        .onClick{
                            self.remove()
                        }
                    
                    H2("Presupuestos Historicos")
                        .color(.lightBlueText)
                        .float(.left)
                }
                
                Div().class(.clear).height(7.px)
                
                Div {
                    self.itemsView
                }
                .custom("height", "calc(100% - 38px)")
                .class(.roundDarkBlue)
                .overflow(.auto)
                
                
            }
            .custom("left", "calc(50% - 225px)")
            .custom("top", "calc(50% - 150px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(300.px)
            .width(450.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custOrderV1.loadServiceOrderBudgets(accountId: accountId) { resp in
                
                loadingView(show: false)
                
                guard let budgets = resp?.data else {
                    showError(.unexpectedResult, .unexpenctedMissingPayload)
                    return
                }
                
                budgets.forEach { item in
                    
                    self.itemsView.appendChild(
                        
                        Div{
                            Div(item.manager?.folio ?? "N/A")
                                .float(.left)
                            Div(getDate(item.manager?.createdAt).formatedLong ?? "N/A")
                                .float(.right)
                            
                            Div().class(.clear)
                            
                            Div("UNI: \(item.manager?.units.toString ?? "N/A")")
                                .fontSize(18.px)
                                .color(.white)
                                .float(.left)
                            
                            Div("$\(item.manager?.total.formatMoney ?? "N/A")")
                                .fontSize(18.px)
                                .color(.white)
                                .float(.right)
                            
                            Div().class(.clear)
                        }
                        .marginBottom(7.px)
                        .padding(all: 3.px)
                        .width(97.percent)
                        .class(.uibtn)
                        .onClick {
                            self.loadDocument(doc: item)
                        }
                    )
                    
                }
            }
        }
        
        override func didAddToDOM(){
            super.didAddToDOM()
        }
        
        func loadDocument(doc: API.custOrderV1.LoadServiceOrderBudgetsResponse) {
            addToDom(HistoricItemPreView(
                orderId: orderId,
                payload: doc,
                callback: {
                self.callback(doc)
                self.remove()
            }))
        }
    }
}
