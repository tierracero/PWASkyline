//
// SalePoint+BudgetHistoricalView
//

import TCFundamentals
import Foundation
import Web
import XMLHttpRequest

extension SalePointView {

    class BudgetHistoricalView: Div {
        
        override class var name: String { "div" }
        
        var budgets: [API.custPDVV1.GetBudgetsObjeto]
        
        private var callback: ((
            _ budgetId: UUID
        ) -> ())
        
        init(
            budgets: [API.custPDVV1.GetBudgetsObjeto],
            callback: @escaping ((
                _ budgetId: UUID
            ) -> ())
        ) {
            self.budgets = budgets
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
            .custom("left", "calc(50% - 399px)")
            .custom("top", "calc(50% - 174px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .height(300.px)
            .width(550.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            budgets.forEach { item in
                
                self.itemsView.appendChild(
                    
                    Div{
                        
                        Div {
                            Div(item.folio)
                                .width(25.percent)
                                .float(.left)
                            Div(getDate(item.createdAt).formatedLong)
                                .width(25.percent)
                                .float(.left)

                            Div("UNIS: \(item.units.toString)")
                                .width(25.percent)
                                .float(.left)
                            Div(item.total.formatMoney)
                                .width(25.percent)
                                .float(.left)
                        }
                        
                        Div().class(.clear).height(3.px)
                        
                        Div("\(item.customer) \(item.mobile)")
                        .class(.oneLineText)

                        Div().class(.clear).height(3.px)
                        
                    }
                    .custom("width", "calc(100% - 24px)")
                    .marginBottom(7.px)
                    .padding(all: 3.px)
                    .class(.uibtn)
                    .onClick {
                        self.callback(item.id)
                        self.remove()
                    }
                )
                
            }
            
        }
        
        override func didAddToDOM(){
            super.didAddToDOM()
        }
        
        
    }

}