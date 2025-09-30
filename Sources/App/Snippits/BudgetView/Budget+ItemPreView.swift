//
//  Budget+ItemPreView.swift
//  
//
//  Created by Victor Cantu on 12/6/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

extension BudgetView {
    
    class ItemPreView: Tr {
        
        override class var name: String { "tr" }
        
        let budgetid: UUID
        
        let objectid: UUID
        
        ///service, product, manual, rental
        var type: ChargeType
        
        /// Avanatr Image
        var avatar: String
        
        /// poc inventory uuid's id aplicable
        var uuids: [UUID]
        
        /// Sold Rrice
        var price: Int64
        
        /// AKA `quant`
        @State var units: Int64
        
        /// Cost /  Intenal Cost
        /// AKA `cuni`
        var unitCost: Int64
        
        @State var subTotal: Int64
        
        /// cost_a, cost_b, cost_c
        var costType: CustAcctCostTypes
        
        var brand: String
        
        var model: String
        
        var storagePlace: String
        
        @State var name: String
        
        init(
        
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
            storagePlace: String
        ) {
            self.budgetid = budgetid
            self.objectid = objectid
            self.type = type
            self.avatar = avatar
            self.uuids = uuids
            self.price = price
            self.units = units
            self.unitCost = unitCost
            self.subTotal = subTotal
            self.costType = costType
            self.brand = brand
            self.model = model
            self.name = name
            self.storagePlace = storagePlace
            
            super.init()
        }

        required init() {
            fatalError("init() has not been implemented")
        }
        
        @DOM override var body: DOM.Content {
        
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
            
            Td(self.price.formatMoney)
                .align(.center)
                .width(75.px)
            
            Td(self.$units.map { (($0 * self.price) / 100).formatMoney })
                .align(.center)
                .width(100.px)
        }
        
        override func buildUI() {
            super.buildUI()
        }
        
    }
}

