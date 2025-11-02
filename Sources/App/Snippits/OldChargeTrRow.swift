//
//  OldChargeTrRow.swift
//
//
//  Created by Victor Cantu on 4/25/22.
//

import TCFundamentals
import Foundation
import Web
@available(*, deprecated, message: "Uee FinaceTrRow insted")
class OldChargeTrRow: Tr {
    
    override class var name: String { "tr" }
    
    let preCharge: Bool
    
    let isCharge: Bool
    
    let id: UUID?
    
    let pocs: [CustPOCInventoryOrderView]
    
    @State var name: String
    
    @State var cuant: Int64
    
    @State var price: Int64
    
    let puerchaseOrder: Bool
    
    private var edit: ((
        _ viewId: UUID
    ) -> ())
    
    
    init(
        preCharge: Bool = false,
        isCharge: Bool,
        id: UUID,
        name: String,
        cuant: Int64,
        price: Int64,
        puerchaseOrder: Bool,
        edit: @escaping ((
            _ viewId: UUID
        ) -> ())
    ) {
        self.preCharge = preCharge
        self.isCharge = isCharge
        self.id = id
        self.pocs = []
        self.name = name
        self.cuant = cuant
        self.price = price
        self.puerchaseOrder = puerchaseOrder
        self.edit = edit
        super.init()
    }
    
    init(
        pocs: [CustPOCInventoryOrderView],
        edit: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        self.preCharge = false
        self.isCharge = true
        self.id = nil
        self.pocs = pocs
        self.name = pocs.first?.name ?? "N/A"
        self.cuant = (pocs.count.toInt64 * 100)
        self.price = (pocs.first?.soldPrice ?? 0)
        self.puerchaseOrder = false
        self.edit = edit
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    let viewId: UUID = .init()
    
    @State var cuantString: String = ""
    
    @State var priceString: String = ""
    
    @State var total: String = ""
    
    @DOM override var body: DOM.Content {
        
        Td{
            Img()
                .src({ (self.preCharge || !self.isCharge) ? "/skyline/media/cross.png" : "/skyline/media/pencil.png" }())
                .height(18.px)
                .cursor(.pointer)
                .onClick {
                    self.edit(self.viewId)
                }
            
        }.width(20.px)
        
        Td(self.$cuantString)
            .fontSize(12.px)
        
        Td(self.$name)
            .class(.oneLineText)
            .fontSize(12.px)
        
        Td(self.$priceString)
            .fontSize(12.px)
        
        Td(self.$total)
            .fontSize(12.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.$cuant.listen {
            self.cuantString = $0.formatMoney
            self.total = ((self.cuant * self.price) / 100).formatMoney
        }
        
        self.$price.listen {
            self.priceString = $0.formatMoney
            self.total = ((self.cuant * self.price) / 100).formatMoney
        }
        
        self.cuantString = self.cuant.formatMoney
        
        self.priceString = self.price.formatMoney
        
        self.total = ((self.cuant * self.price) / 100).formatMoney
        
    }
}
