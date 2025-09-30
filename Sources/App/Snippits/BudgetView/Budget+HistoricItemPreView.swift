//
//  Budget+HistoricItemPreView.swift
//
//
//  Created by Victor Cantu on 12/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension BudgetView {
    
    class HistoricItemPreView: Div {
        
        override class var name: String { "div" }
        
        let orderId: UUID
        
        var payload: API.custOrderV1.LoadServiceOrderBudgetsResponse
        
        private var callback: ((
        ) -> ())
        
        init(
            orderId: UUID,
            payload: API.custOrderV1.LoadServiceOrderBudgetsResponse,
            callback: @escaping ((
            ) -> ())
        ) {
            self.orderId = orderId
            self.payload = payload
            self.callback = callback
            
            super.init()
        }
        
        required init() {
            fatalError("init() has not been implemented")
        }
        
        @State var folio: String = ""
        
        @State var budgetCost: Float = 0
        
        @State var balance: Float = 0
        
        lazy var chargesGrid = Table {
            Tr{
                
                Td("Marca")
                    .align(.left)
                    .width(120.px)
                
                Td("Modelo / Nombre")
                    .align(.left)
                
                Td("Hubicación")
                    .align(.left)
                    .width(120.px)
                
                Td("Uni.")
                    .align(.center)
                    .width(75.px)
                
                Td("C. Uni.")
                    .align(.center)
                    .width(75.px)
                
                Td("Sub Total")
                    .align(.center)
                    .width(100.px)
            }
        }
            .width(100.percent)
            .color(.white)
        
        @DOM override var body: DOM.Content {
            
            Div{
                /// Header
                Div{
                    
                    Img()
                        .closeButton(.uiView2)
                        .onClick{
                            self.remove()
                        }
                    
                    H2(self.$folio.map{ "Presupuesto \($0)" })
                        .color(.lightBlueText)
                        .float(.left)
                    
                }
                
                Div().class(.clear).height(7.px)

                Div{
                    self.chargesGrid
                }
                .custom("height", "calc(100% - 90px)")
                .class(.roundDarkBlue)
                .padding(all: 7.px)
                .overflow(.auto)
                
                Div{
                    
                    H2(self.$balance.map{ $0.formatMoney })
                        .color(.lightBlueText)
                        .fontSize(36.px)
                        .float(.right)
                    
                    if custCatchHerk >= sneekPeekLimit {
                        Div{
                            H2(self.$budgetCost.map{ "\($0.formatMoney) CI" })
                                .fontSize(18.px)
                                .color(.gray)
                            
                            H2(self.$budgetCost.map{ "\(( self.balance - $0 ).formatMoney) GA" } )
                                .fontSize(18.px)
                                .color(.yellowTC)
                        }
                        .hidden(self.$budgetCost.map {  $0 == 0 })
                        .marginRight(7.px)
                        .textAlign(.right)
                        .float(.right)
                    }
                    
                    Div{
                        Div("Conectar Presupuesto")
                        .class(.uibtnLargeOrange)
                        .marginTop(-5.px)
                        .onClick {
                            
                            addToDom(ConfirmationView(
                                type: .acceptDeny,
                                title: "Confirmar Accion",
                                message: "Desea ligar el presipuesto a la orden", callback: { isConfirmed, comment in
                                    
                                    guard let manager = self.payload.manager else {
                                        showError(.errorGeneral, "No se localizo id del manager")
                                        return
                                    }
                                    
                                    loadingView(show: true)
                                    
                                    API.custOrderV1.linkServiceOrderBudget(
                                        budgetId: manager.id,
                                        orderId: self.orderId
                                    ) { resp in
                                        
                                        guard let resp else {
                                            showError(.errorDeCommunicacion, .serverConextionError)
                                            return
                                        }
                                        
                                        guard resp.status == .ok else {
                                            showError(.errorGeneral, resp.msg)
                                            return
                                        }
                                        
                                        self.callback()
                                        self.remove()
                                        
                                    }
                                }
                            ))
                            
                        }
                    }
                    .paddingTop(7.px)
                    .float(.left)
                    
                }
                
            }
            .custom("height", "calc(100% - 150px)")
            .custom("width", "calc(100% - 150px)")
            .backgroundColor(.grayBlack)
            .borderRadius(all: 24.px)
            .position(.absolute)
            .padding(all: 12.px)
            .left(75.px)
            .top(75.px)
            
        }
        
        override func buildUI() {
            super.buildUI()
            
            self.class(.transparantBlackBackGround)
            position(.absolute)
            height(100.percent)
            width(100.percent)
            left(0.px)
            top(0.px)
            
            loadBudget()
        }
        
        func calcBalance(){
//            
//            var bal: Int64 = 0
//            
//            var cost: Int64 = 0
//            
//            itemRefrence.forEach { id, item in
//                bal += ((item.units * item.price) / 100)
//                
//                cost += ((item.units * item.unitCost) / 100)
//                
//            }
//            
//            self.balance = bal.fromCents
//            
//            self.budgetCost = cost.fromCents
//            
        }
        
        func loadBudget() {
     
            
            guard let manager = self.payload.manager else {
                showError(.errorGeneral, "No se localizo id del manager \(#function)")
                return
            }
            
            
            //self.budgetid = payload.manager.id
            
            self.folio = manager.folio
            
            //self.budgetStatus.wrappedValue = payload.manager.status
            
            //OrderCatchControler.shared.updateParameter( self.orderid, .budgetStatus(payload.manager.status))
            
            /// Products
            payload.saleObjects.forEach { item in
                
                var bod = ""
                if let bodid = item.ids.first?.custStoreBodegas {
                    if let name = bodegas[bodid]?.name {
                        bod = name
                    }
                }
                
                var sec = ""
                if let secid = item.ids.first?.custStoreSecciones {
                    if let name = seccions[secid]?.name {
                        sec = name
                    }
                }
                
                let view = ItemPreView(
                    budgetid: manager.id,
                    objectid: item.custPOC.id,
                    type: .product,
                    avatar: "",
                    uuids: item.ids.map{ $0.id },
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.custPOC.cost,
                    subTotal: item.units,
                    costType: .cost_a,
                    brand: item.custPOC.brand,
                    model: item.custPOC.model,
                    name: item.custPOC.name,
                    storagePlace: "\(bod) \(sec)"
                )
                
                chargesGrid.appendChild(view)
                
                balance += ((item.units * item.unitPrice) / 100).fromCents
            
                budgetCost  += ((item.units * item.custPOC.cost) / 100).fromCents
                
            }
            
            
            /// Services
            payload.saleObjectsSOC.forEach { item in
                
                let view = ItemPreView(
                    budgetid: manager.id,
                    objectid: item.custSOC.id,
                    type: .service,
                    avatar: "",
                    uuids: [],
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.custSOC.cost,
                    subTotal: (item.unitPrice * (item.units / 100)),
                    costType: .cost_a,
                    brand: "",
                    model: "",
                    name: item.custSOC.name,
                    storagePlace: "Servicio"
                )
                
                chargesGrid.appendChild(view)
                
                balance += ((item.units * item.unitPrice) / 100).fromCents
                
                budgetCost += ((item.units * item.custSOC.cost) / 100).fromCents
                
            }
            
            /// Manual
            payload.saleObjectsManual.forEach { item in
                
                let view = ItemPreView(
                    budgetid: manager.id,
                    objectid: item.id,
                    type: .manual,
                    avatar: "",
                    uuids: [],
                    price: item.unitPrice,
                    units: item.units,
                    unitCost: item.cost ?? 0,
                    subTotal: (item.units * (item.unitPrice / 100)),
                    costType: .cost_a,
                    brand: "",
                    model: "",
                    name: item.name,
                    storagePlace: "Servicio"
                )
                
                chargesGrid.appendChild(view)
                
                balance += ((item.units * item.unitPrice) / 100).fromCents
                
                budgetCost += ((item.units * item.unitPrice) / 100).fromCents
                
            }
        }
    }
}
