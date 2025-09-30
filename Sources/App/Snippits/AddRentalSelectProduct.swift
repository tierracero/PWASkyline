//
//  AddRentalSelectProduct.swift
//  
//
//  Created by Victor Cantu on 6/2/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class AddRentalSelectProduct: Div {
    
    override class var name: String { "div" }
    
    lazy var prductGrid = Div()
    
    var costType: CustAcctCostTypes
    var currentUsedIDs: [UUID]
    
    var pocs: [API.custPOCV1.LoadDepPOCInventoryResponse.POC]
    
    private var callback: ((_ poc: API.custPOCV1.LoadDepPOCInventoryResponse.POC) -> ())
    
    init(
        costType: CustAcctCostTypes,
        currentUsedIDs: [UUID],
        pocs: [API.custPOCV1.LoadDepPOCInventoryResponse.POC],
        callback: @escaping ((_ poc: API.custPOCV1.LoadDepPOCInventoryResponse.POC) -> ())
    ) {
        self.costType = costType
        self.currentUsedIDs = currentUsedIDs
        self.pocs = pocs
        self.callback = callback
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            Img()
                .closeButton(.uiView1)
                .onClick{
                    self.remove()
                }
            
            H1("Seleccione Producto")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(12.px)
            
            self.prductGrid
        }
        .padding(all: 12.px)
        .top(10.percent)
        .height(80.percent)
        .width(80.percent)
        .custom("left", "calc(10% - 12px)")
        .position(.absolute)
        .backgroundColor(.white)
        .borderRadius(all: 24.px)
    }
    
    override func buildUI() {
        width(100.percent)
        height(100.percent)
        top(0.px)
        left(0.px)
        position(.absolute)
        self.class(.transparantBlackBackGround)
    
        print("🟡  curr id ->")
        print(self.currentUsedIDs)
        print("🟡  curr id ->")
        print(self.currentUsedIDs)
        print("🟡  curr id ->")
        print(self.currentUsedIDs)
        
        self.pocs.forEach { poc in
            
            var cost: Int64 = 0
            
            switch self.costType{
            case .cost_a:
                cost = poc.pricea
            case .cost_b:
                cost = poc.priceb
            case .cost_c:
                cost = poc.pricec
            }
            
            if poc.inPromo {
                cost = poc.pricep
                
            }
            
            let img = Img()
            
            var currentInventory = poc.inventroy.count
            
            poc.inventroy.forEach { item in
                if self.currentUsedIDs.contains(item.id) {
                    currentInventory -= 1
                }
            }
            
            self.prductGrid.appendChild(
                Div{
                    img
                        .borderRadius(all: 12.px)
                        .src("/skyline/media/tc-logo-512x512.png")
                        .width(90.percent)
                    
                    Div().class(.clear)
                    Span(poc.name)
                    Div().class(.clear)
                    Div{
                        Span(String(currentInventory))
                            .float(.left)
                            .marginLeft(7.px)
                        Strong("$"+String(cost.formatMoney))
                            .float(.right)
                            .marginRight(7.px)
                        Div().class(.clear)
                    }
                    Div().class(.clear)
                }
                    .cursor(.pointer)
                    .class(.roundBlue)
                    .float(.left)
                    .align(.center)
                    .width(150.px)
                    .backgroundColor(.white)
                    .borderRadius(all: 12.px)
                    .padding(all: 3.px)
                    .margin(all: 3.px)
                    .onClick {
                        if poc.inventroy.isEmpty {
                            showAlert(.alerta, "Este producto no tiene inventario disponoble.")
                            return
                        }
                        
                        self.callback(poc)
                        
                        self.remove()
                        
                    }
            )
            if !poc.avatar.isEmpty {
                if let pDir = customerServiceProfile?.account.pDir {
                    img.load("https://intratc.co/cdn/\(pDir)/thump_\(poc.avatar)")
                }
            }
        }
    }
}
