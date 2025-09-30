//
//  FiscOperatorFieldItem.swift
//
//
//  Created by Victor Cantu on 3/18/25.
//

import Foundation
import TCFundamentals
import Web

class FiscOperatorFieldItem: Div {
    
    override class var name: String { "div" }
    
    let id: UUID
    
    /// First and Last name [meta1]
    @State var name: String
    
    /// Licence number meta2
    @State var licence: String
    
    /// RFC meta3
    @State var rfc: String
    
    /// Date that licence expire meta4
    @State var expireAt: Int64?
    
    private var editItem: ((
        _ id: UUID,
        _ name: String,
        _ licence: String,
        _ rfc: String,
        _ expireAt: Int64?
    ) -> ())
    
    private var removeItem: (() -> ())
    
    init(
        _ operator: CustFiscalOperator,
        editItem: @escaping ((
            _ id: UUID,
            _ name: String,
            _ licence: String,
            _ rfc: String,
            _ expireAt: Int64?
        ) -> ()),
        removeItem: @escaping (() -> ())
    ) {
        self.id = `operator`.id
        self.name = `operator`.name
        self.licence = `operator`.licence
        self.rfc = `operator`.rfc
        self.expireAt = `operator`.expireAt
        self.editItem = editItem
        self.removeItem = removeItem
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @DOM override var body: DOM.Content {
        
        Div{
        
            Div{
                
                Div{
                    
                    Div {
                        Span(self.$rfc)
                            .marginRight(12.px)
                        Span(self.$name)
                    }
                    .class(.oneLineText)
                    .fontSize(18.px)
                    
                    Div().clear(.both).height(3.px)
                    
                    Div{
                        
                        Span(self.$licence)
                        
                        Span(self.$expireAt.map{
                            if let uts = $0  {
                                return getDate(uts).formatedLong
                            }
                            else {
                                return "N/D"
                            }
                        }).float(.right)
                        
                    }
                    .class(.oneLineText)
                    .fontSize(14.px)
                    
                }
                .custom("width", "calc(100% - 35px)")
                .float(.left)
                
                Div{
                    Table {
                        Tr{
                            Td{
                                Img()
                                    .src("/skyline/media/pencil.png")
                                    .cursor(.pointer)
                                    .height(18.px)
                                    .onClick { _, event in
                                        
                                        let view = CartaPorteOperator(.init(
                                            id: self.id,
                                            name: self.name,
                                            licence: self.licence,
                                            rfc: self.rfc,
                                            expireAt: self.expireAt
                                        )) { `operator` in

                                            self.name = `operator`.name
                                            self.licence = `operator`.licence
                                            self.rfc = `operator`.rfc
                                            self.expireAt = `operator`.expireAt
                                            
                                            self.editItem(
                                                `operator`.id,
                                                `operator`.name,
                                                `operator`.licence,
                                                `operator`.rfc,
                                                `operator`.expireAt
                                            )
                                            
                                        }
                                        
                                        addToDom(view)
                                        
                                        event.stopPropagation()
                                        
                                    }
                            }
                            .verticalAlign(.middle)
                            .align(.right)
                        }
                    }
                    .height(100.percent)
                    .width(100.percent)
                }
                .width(35.px)
                .float(.left)
                
                Div().clear(.both)
                
            }
            .margin(all: 7.px)
            
        }
        .custom("width", "calc(100% - 14px)")
        .class(.uibtnLarge)
        
    }
    
    override func buildUI() {
        super.buildUI()
        margin(all: 7.px)
    }
    
    
}
