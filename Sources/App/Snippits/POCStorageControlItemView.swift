//
//  POCStorageControlItemView.swift.swift
//  
//
//  Created by Victor Cantu on 2/5/23.
//

import Foundation
import TCFundamentals
import Web

class POCStorageControlItemView: Div {
    
    override class var name: String { "div" }
    
    let item: CustPOCInventoryIDSale
    
    init(
        item: CustPOCInventoryIDSale
    ) {
        self.item = item
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var checkbox = InputCheckbox()
        .onClick { _, event in
            event.stopPropagation()
        }
    
    lazy var locationView = Div()
    
    @DOM override var body: DOM.Content {
        
        self.checkbox
            .marginLeft(7.px)
            .float(.left)
        
        Div(item.id.uuidString.explode("-").last ?? "N/A")
            .class(.oneLineText)
            .width(40.percent)
            .marginLeft(7.px)
            .float(.left)
        
        self.locationView
            .class(.oneLineText)
            .width(45.percent)
            .marginLeft(7.px)
            .float(.right)
            .align(.right)
        
        Div().class(.clear)
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        marginBottom(7.px)
        padding(all: 3.px)
        fontSize(12.px)
        self.class(.uibtn)
        width(95.percent)
        onClick {
            addToDom(InventoryItemDetailView(itemid: self.item.id){ price in
                
            })
        }
        
        var str = ""
        
        if let bodid = item.custStoreBodegas {
            str += bodegas[bodid]?.name ?? "B.N/D"
        }
        
        str += " / "
        
        if let secid = item.custStoreSecciones {
            str += seccions[secid]?.name ?? "S.N/D"
        }
     
        locationView.appendChild(Span(str).fontSize(12.px))
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }

}
