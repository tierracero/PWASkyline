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
            //Select Code
            Div{
                
                Div{
                    
                    /// Header
                    Div {
                        
                        Img()
                            .closeButton(.subView)
                            .onClick {
                                self.remove()
                            }
                        
                        Div(" + Gastos")
                            .marginRight(12.px)
                            .marginTop(-7.px)
                            .fontSize(20.px)
                            .float(.right)
                            .class(.uibtn)
                            .onClick {
                                
                                addToDom(SpendingView { financial in
                                    self.openFinancialRecord(financial: financial)
                                    self.items.append(financial)
                                })
                                
                            }
                        
                        if custCatchHerk > 1 {
                            
                            Div(" + Prestamo")
                                .marginRight(12.px)
                                .marginTop(-7.px)
                                .fontSize(20.px)
                                .float(.right)
                                .class(.uibtn)
                                .onClick {
                                    addToDom(LendingView())
                                }
                        }
                        
                        H2("Finanzas")
                            .color(.lightBlueText)
                            .marginLeft(7.px)
                            .float(.left)
                        
                        Div().class(.clear)
                        
                    }
                    
                    Div().height(7.px)
                    
                    Div{
                        ForEach(self.$items){ item in
                            
                            Div{
                                Div("\(item.folio) \(item.type.description) \(item.comments)")
                                    .class(.oneLineText)
                                    .width(70.percent)
                                    .float(.left)
                                
                                Div(item.balance.formatMoney)
                                    .class(.oneLineText)
                                    .textAlign(.right)
                                    .width(30.percent)
                                    .float(.right)
                                
                                Div().clear(.both)
                            }
                            .width(95.percent)
                            .marginBottom(7.px)
                            .class(.uibtn)
                            .onClick {
                                self.openFinancialRecord(financial: item)
                            }
                            
                        }
                        .hidden(self.$items.map{ $0.isEmpty })
                        
                        Table().noResult(label: "📝 No hay Operaciones Financieras a procesar")
                            .hidden(self.$items.map{ !$0.isEmpty })
                    }
                    .class(.roundDarkBlue)
                    .padding(all: 7.px)
                    .height(400.px)
                    
                }
                .padding(all: 12.px)
                
            }
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .width(35.percent)
            .left(30.percent)
            .top(20.percent)
            .color(.white)
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
            
            API.custAPIV1.getFianancialServices { resp in
                
                loadingView(show: false)
                
                guard let resp else {
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.errorDeCommunicacion, .unexpenctedMissingPayload)
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
                    showError(.errorDeCommunicacion, .serverConextionError)
                    return
                }
                
                guard resp.status == .ok else {
                    showError(.errorGeneral, resp.msg)
                    return
                }
                
                guard let payload = resp.data else {
                    showError(.errorDeCommunicacion, .unexpenctedMissingPayload)
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
        
    }
    
}



