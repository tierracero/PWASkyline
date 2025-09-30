//
//  AccountRowView.swift
//
//
//  Created by Victor Cantu on 7/24/22.
//

import Foundation
import TCFundamentals
import Web

class AccountRowView: Div {
    
    override class var name: String { "div" }
    
    var folio = ""
    
    var icon = Img()
        .rowDefaultImage128
        .height(35.px)
        .class(.iconWhite)
        .marginTop(7.px)
    
    let data: CustAcctAPI
    
    private var callback: ((
        _ id: UUID
    ) -> ())
    
    ///OrderAction
    init(
        data: CustAcctAPI,
        callback: @escaping ((_ id: UUID) -> ())
    ) {
        self.data = data
        self.callback = callback
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        Div{
            Div{
                H2(self.folio)
                
                self.icon
                    .paddingTop(3.px)
            }
            .color(.white)
            .align(.center)
            .float(.left)
            .width(80.px)
            
            Div{
                H3(self.data.businessName).color(.gray)
                H1("\(self.data.firstName) \(self.data.lastName)")
                H3("\(self.data.street) \(self.data.colony) \(self.data.city) ").color(.gray)
            }
            .float(.right)
            .custom("width", "calc(100% - 92px)")
            .class(.smallButtonBox)
            .backgroundColor(.init(r: 255, g: 255, b: 255, a: 0.77))

            Div().class(.clear)
            
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        /// Adjust View
        self.class(.smallButtonBox)
        backgroundColor(.folioRowDefaultColor)
        onClick {
            self.callback(self.data.id)
        }
        
        if data.folio.contains("-") {
            let parts = data.folio.explode("-")
            if parts.count > 1 {
                folio = parts[1]
            }
        }
        
        self.folio = self.data.folio
        
        if self.data.folio.contains("-") {
            let parts = self.data.folio.explode("-")
            if let _folio = parts.last {
                self.folio = _folio
            }
        }
        
    }
}

