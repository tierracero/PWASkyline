//
//  FiscalDocumentRowView.swift
//  
//
//  Created by Victor Cantu on 9/13/22.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class FiscalDocumentRowView: Div {
    
    override class var name: String { "div" }
    
    let isEven: Bool
    
    /// Number of items included
    var units: Int = 0
    
    let item: CustFiscalDocumentControlQuick
    
    @State var searching: Bool = false
    
    private var callback: ((
        _ id: UUID
    ) -> ())
    
    init(
        isEven: Bool,
        item: CustFiscalDocumentControlQuick,
        callback: @escaping ((
            _ id: UUID
        ) -> ())
    ) {
        self.isEven = isEven
        self.item = item
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div(getDate(self.item.officialDate).formatedShort)
            .class(.oneLineText)
            .marginTop(7.px)
            .align(.center)
            .width(110.px)
            .float(.left)
        
        Div(self.item.receptorRfc)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(140.px)
            .float(.left)
            .align(.left)
        
        Div(self.item.emisorRfc)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(140.px)
            .float(.left)
            .align(.left)
        
        Div(self.item.emisorName)
            .custom("width", "calc(100% - 700px)")
            .class(.oneLineText)
            .marginTop(7.px)
            .float(.left)
        
        Div(self.item.serie)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(90.px)
            .float(.left)
            .align(.center)
        
        Div(self.item.folio)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(90.px)
            .float(.left)
            .align(.center)
        
        /// Total
        Div(self.item.total.formatMoney)
            .class(.oneLineText)
            .marginTop(7.px)
            .width(120.px)
            .float(.right)
            .align(.center)
        
        Div().class(.clear).marginBottom(7.px)
        
    }
    
    override func buildUI() {
        super.buildUI()
        padding(all: 3.px)
        margin(all: 3.px)
        
        borderRadius(all: 12.px)
        cursor(.pointer)
        
        if self.item.controlStatus == .filedRequest {
            color(.gray)
        }
        else{
            color(.white)
        }
        
        self.onClick {
            self.callback(self.item.uuid)
        }
        
        if !self.isEven {
            self.backgroundColor(.grayBlackDark)
        }
        
    }

}
