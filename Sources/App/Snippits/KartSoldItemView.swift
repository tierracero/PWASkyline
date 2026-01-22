//
//  KartSoldItemView.swift
//  
//
//  Created by Victor Cantu on 1/9/25.
//

import Foundation
import TCFundamentals
import Web

class KartSoldItemView: Tr {
    
    override class var name: String { "tr" }
    
    var id: UUID
    var cost: Int64
    var quant: Int64
    var price: Int64
    var total: Int64
    var hasPriceVariation: Bool
    var data: SearchChargeResponse
    
    init(
        id: UUID,
        cost: Int64,
        quant: Int64,
        price: Int64,
        total: Int64,
        hasPriceVariation: Bool,
        data: SearchChargeResponse
    ) {
        self.id = id
        self.cost = cost
        self.quant = quant
        self.price = price
        self.total = total
        self.hasPriceVariation = hasPriceVariation
        self.data = data
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    var name = ""
    
    var viewDetailButton = false
    
    var items: [CustPOCInventorySoldObject] = []
    
    lazy var img = Img()
        .src("/skyline/media/tc-logo-32x32.png")
        .height(16.px)
        .marginRight(7.px)
    
    @DOM override var body: DOM.Content {
        
        Td(self.data.b)
        Td(self.name)
        //Td("Hubicación")
        Td(self.quant.toString)
            .align(.center)
        Td(self.price.formatMoney)
            .color(self.hasPriceVariation ? .orange : .white)
            .align(.center)
        Td(self.total.formatMoney)
            .align(.center)
        
        Td{
            Img()
                .src("skyline/media/maximizeWindow.png")
                .class(.iconWhite)
                .cursor(.pointer)
                .width(18.px)
                .onClick {
                    self.viewSoldItems()
                }
        }
        .align(.center)
        
    }
    
    override func buildUI() {
        self.padding(all: 12.px)
        self.color(.black)
        
        name = "\(data.u) \(data.m) \(data.n)"
        
    }
    
    func viewSoldItems(){
        
        if items.count == 1 {
            addToDom(InventoryItemDetailView(itemid: items.first!.id){ price in
                
            })
        }
        else {
            addToDom(SalePointView.SelectItemView(items: items) )
        }
        
    }
    
}
