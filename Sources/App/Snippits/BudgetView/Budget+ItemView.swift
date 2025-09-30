//
//  BudgetItemView.swift
//  
//
//  Created by Victor Cantu on 10/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension BudgetView {
    
    class ItemView: Tr {
        
        override class var name: String { "tr" }
        
        /// Store Id
        var storeid: UUID
        
        let orderid: UUID
        
        let budgetid: UUID
        
        let objectid: UUID
        
        ///service, product, manual, rental
        var type: ChargeType
        
        /// Avanatr Image
        var avatar: String
        
        /// poc inventory uuid's id aplicable
        var uuids: [UUID]
        
        /// Sold Rrice
        @State var price: Int64
        
        /// AKA `quant`
        @State var units: Int64
        
        /// Cost /  Intenal Cost
        /// AKA `cuni`
        @State var unitCost: Int64
        
        @State var subTotal: Int64
        
        /// cost_a, cost_b, cost_c
        var costType: CustAcctCostTypes
        
        var brand: String
        
        var model: String
        
        var storagePlace: String
        
        @State var name: String
        
        private var callback: ((
          _ id: UUID
        ) -> ())
        
        private var updateUnits: ((
        ) -> ())

        init(
            /// Store Id
            storeid: UUID,
        
            orderid: UUID,
        
            budgetid: UUID,
        
            /// chage id
            objectid: UUID,
            ///service, product, manual, rental
            type: ChargeType,
            /// Avanatr Image
            avatar: String,
            /// poc inventory uuid's id aplicable
            uuids: [UUID],
            /// Sold Rrice
            price: Int64,
            /// AKA `quant`
            units: Int64,
            /// Cost /  Intenal Cost
            /// AKA `cuni`
            unitCost: Int64,
            subTotal: Int64,
            /// cost_a, cost_b, cost_c
            costType: CustAcctCostTypes,
            brand: String,
            model: String,
            name: String,
            storagePlace: String,
            callback: @escaping ((
              _ id: UUID
            ) -> ()),
            updateUnits: @escaping ((
            ) -> ())
        ) {
            self.storeid = storeid
            self.orderid = orderid
            self.budgetid = budgetid
            self.objectid = objectid
            self.type = type
            self.avatar = avatar
            self.uuids = uuids
            self.price = price
            self.units = units
            self.unitCost = unitCost
            self.subTotal = (units / 100) * price
            self.costType = costType
            self.brand = brand
            self.model = model
            self.name = name
            self.storagePlace = storagePlace
            self.callback = callback
            self.updateUnits = updateUnits
            
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }
        
        let viewid: UUID = .init()
        
        @DOM override var body: DOM.Content {
        
            Td{
                Img()
                    //.hidden(self.$image.map{ $0 == nil })
                    .src("/skyline/media/pencil.png")
                    .cursor(.pointer)
                    .height(18.px)
                    .onClick {
                         addToDom(BudgetEditItemView(
                            type: self.type,
                            orderid: self.orderid,
                            budgetid: self.budgetid,
                            objectid: self.objectid,
                            name: self.name,
                            price: self.price.formatMoney,
                            units: self.units.formatMoney,
                            updateItem: { updatesUnits, updatedPrice in
                                self.units = updatesUnits
                                self.price = updatedPrice
                                self.subTotal = (updatesUnits / 100) * updatedPrice
                                self.updateUnits()
                            },
                            deleteItem: {
                                self.callback(self.viewid)
                            }))
                    }
            }
                .align(.center)
            
            Td(self.brand)
                .align(.left)
                .width(120.px)
            
            Td("\(self.name) \(self.model)".purgeSpaces)
                .align(.left)
            
            Td(self.storagePlace)
                .align(.left)
                .width(120.px)
            
            Td(self.$units.map { $0.formatMoney })
                .align(.center)
                .width(75.px)
            
            Td(self.$price.map{ $0.formatMoney })
                .align(.center)
                .width(75.px)
            
            Td(self.$subTotal.map{ $0.formatMoney })
                .align(.center)
                .width(100.px)
        }
        
        override func buildUI() {
            super.buildUI()
            
            print("⭐️  BudgetItemView budgetid \(budgetid)")
            
        }
        
        override func didAddToDOM(){
            super.didAddToDOM()
        }
        
        override func didRemoveFromDOM() {
            super.didRemoveFromDOM()
        }
        
    }
    
}
