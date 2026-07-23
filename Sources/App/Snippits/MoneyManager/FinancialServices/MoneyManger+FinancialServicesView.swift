//
//  MoneyManger+FinancialServicesView.swift
//  
//
//  Created by Victor Cantu on 7/28/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension MoneyManagerView {
    
    class FinancialServicesView: Div {
        
        override class var name: String { "div" }
        
        @State var items: [CustUserFinacialServicesQuick] = []
        
        @DOM override var body: DOM.Content {
            VPopUp(.fitContent(w: 900)) {
                VTitle("Servicios financieros") {
                    USmallTitle(self.$items.map { "\($0.count) movimientos" })
                        .class(Class(TCMoneyManagerClass.badge))

                    USmallButton("＋ Gasto")
                        .attribute("aria-label", "Registrar gasto")
                        .onClick {
                            addToDom(SpendingView { financial in
                                self.openFinancialRecord(financial: financial)
                                self.items.append(financial)
                            })
                        }

                    if custCatchHerk > 1 {
                        USmallButton("＋ Préstamo")
                            .attribute("aria-label", "Registrar préstamo")
                            .onClick {
                                addToDom(LendingView())
                            }
                    }
                } onClose: {
                    self.remove()
                }

                VBodyGrid {
                    VGrid(.full) {
                        VBox(.raised) {
                            Div {
                                Img()
                                    .src("/skyline/media/money_bag.png")
                                    .width(38.px)
                                    .height(38.px)
                                    .custom("object-fit", "contain")

                                Div {
                                    USubTitle("Movimientos por procesar")
                                    UMinorTitle("Consulte saldos, gastos y capital otorgado desde un solo lugar.")
                                        .marginTop(4.px)
                                        .custom("line-height", "1.4")
                                }
                                .custom("min-width", "0")
                            }
                            .display(.grid)
                            .custom("grid-template-columns", "48px minmax(0, 1fr)")
                            .custom("align-items", "center")
                            .custom("gap", "12px")
                        }
                        .class(Class(TCMoneyManagerClass.hero))
                    }

                    VGrid(.full) {
                        Div {
                            ForEach(self.$items) { item in
                                Div {
                                    Div {
                                        USmallTitle("Folio \(item.folio)")
                                            .class(Class(TCMoneyManagerClass.badge))

                                        USubTitle(item.type.description)
                                            .marginTop(6.px)

                                        UMinorTitle(item.comments)
                                            .marginTop(5.px)
                                            .class(.oneLineText)
                                    }
                                    .class(Class(TCMoneyManagerClass.listIdentity))
                                    .custom("min-width", "0")

                                    Div {
                                        Div(item.balance.formatMoney)
                                            .class(Class(TCMoneyManagerClass.listAmount))

                                        UMinorTitle("Saldo")
                                            .marginTop(3.px)
                                            .textAlign(.right)
                                    }
                                }
                                .class(Class(TCMoneyManagerClass.listRow))
                                .attribute("role", "button")
                                .tabIndex(0)
                                .onClick {
                                    self.openFinancialRecord(financial: item)
                                }
                                .onKeyUp { _, event in
                                    guard event.code == "Enter" || event.code == "Space" else {
                                        return
                                    }
                                    event.preventDefault()
                                    self.openFinancialRecord(financial: item)
                                }
                            }
                        }
                        .class(Class(TCMoneyManagerClass.list))
                        .hidden(self.$items.map { $0.isEmpty })

                        VBox(.standard) {
                            Table().noResult(label: "📝 No hay operaciones financieras por procesar")
                        }
                        .class(Class(TCMoneyManagerClass.emptyState))
                        .hidden(self.$items.map { !$0.isEmpty })
                    }
                }
            }
            .class(Class(TCMoneyManagerClass.popup))
        }
        
        override func buildUI() {
            super.buildUI()

            TCMoneyManagerTheme.apply(to: self)
            
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadingView(show: true)
            
            API.custAPIV1.getFianancialServices { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.comunicationError, .unexpenctedMissingPayload)
                    return
                }
                
                self.items = payload.map{ .init(
                    id: $0.id,
                    createdAt: $0.createdAt,
                    targetUser: $0.targetUser,
                    folio: $0.folio,
                    type: $0.type,
                    comments: $0.comments,
                    amount: $0.amount,
                    returned: $0.returned,
                    balance: $0.balance,
                    reciptType: $0.reciptType,
                    status: $0.status
                ) }
                
            }
            
        }
        
        func openFinancialRecord(financial: CustUserFinacialServicesQuick){
            
            loadingView(show: true)
            
            API.custAPIV1.getFianancialService(id: .id(financial.id)) { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.comunicationError, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.generalError, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.comunicationError, .unexpenctedMissingPayload)
                    return
                }
                
                addToDom(DetailView(
                    financial: payload.financial,
                    notes: payload.notes,
                    vendor: payload.vendor,
                    updated: {
                        var _items: [CustUserFinacialServicesQuick] = []
                        
                        self.items.forEach { item in
                            if item.id == payload.financial.id {
                                return
                            }
                            _items.append(item)
                        }
                        
                        self.items = _items
                    }))
                
                
            }
            
        }
        

        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
            $items.removeAllListeners()
        }
    }
    
}


