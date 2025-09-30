//
//  BudgetHistoricalView.swift
//  
//
//  Created by Victor Cantu on 3/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class BudgetHistoricalView: Div {
    
    override class var name: String { "div" }
    
    var accountid: UUID
    
    private var callback: ((
        _ budget: CustSaleAdditinalManagerQuick
    ) -> ())
    
    init(
        accountid: UUID,
        callback: @escaping ((
            _ budget: CustSaleAdditinalManagerQuick
        ) -> ())
    ) {
        self.accountid = accountid
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
        
        API.custAPIV1.getBudgets(id: accountid) { budgets in
            
            loadingView(show: false)
            
            budgets.forEach { item in
                
                self.itemsView.appendChild(
                    
                    Div{
                        
                        Div {
                            Div(item.folio)
                                .float(.left)
                            Div(getDate(item.createdAt).formatedLong)
                                .float(.right)
                        }
                        
                        Div().class(.clear)
                        
                        Div {
                            Div("UNIS: \(item.units.toString)")
                                .float(.left)
                            Div(item.total.formatMoney)
                                .float(.right)
                        }
                        
                    }
                    .marginBottom(7.px)
                    .padding(all: 3.px)
                    .width(97.percent)
                    .class(.uibtn)
                    .onClick {
                        self.loadDocument(doc: .init(
                            id: item.id,
                            createdAt: item.createdAt,
                            custStore: item.custStore,
                            folio: item.folio,
                            type: item.type,
                            status: item.status
                        ))
                    }
                )
                
            }
        }
    }
    
    override func didAddToDOM(){
        super.didAddToDOM()
    }
    
    func loadDocument(doc: CustSaleAdditinalManagerQuick) {
        
        if doc.type == .budgetOrder {
            showError(.errorGeneral, "No se pueden cargar presupuestos de orden aun")
            return
        }
        
        callback(doc)
        
        //self.remove()
        
    }
    
}
