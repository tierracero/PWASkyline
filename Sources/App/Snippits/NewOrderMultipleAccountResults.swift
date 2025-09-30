//
//  NewOrderMultipleAccountResults.swift
//  
//
//  Created by Victor Cantu on 8/23/22.
//

import Foundation

import Foundation
import TCFundamentals
import Web
import TCFireSignal

class NewOrderMultipleAccountResults: Div {
    
    override class var name: String { "div" }
    
    let accounts: [CustAcctSearch]
    
    private var callback: ((
        _ account: CustAcctSearch
    ) -> ())
    
    init(
        accounts: [CustAcctSearch],
        callback: @escaping ((
            _ account: CustAcctSearch
        ) -> ())
    ) {
        self.accounts = accounts
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    lazy var accountGrid = Div()
    
    @DOM override var body: DOM.Content {
        Div{
            
            Img()
                .closeButton(.view)
                .onClick{
                    self.remove()
                }
            
            H2("Seleccione Cuenta")
                .color(.lightBlueText)
            
            Div()
                .class(.clear)
                .marginTop(3.px)
            
            self.accountGrid
            
        }
        .borderRadius(all: 24.px)
        .backgroundColor(.white)
        .maxHeight(60.percent)
        .position(.absolute)
        .padding(all: 12.px)
        .width(50.percent)
        .left(25.percent)
        .top(20.percent)
        .overflow(.auto)
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
        
        accounts.forEach { account in
            accountGrid.appendChild(
                Div{
                    Div{
                        Label("\(account.businessName)")
                            .float(.right)
                        Label("Tipo de Cuenta: \(account.type.description)")
                        
                    }
                    .fontSize(16.px)
                    .color(.gray)
                    
                    Div{
                        Strong("\(account.folio) \(account.firstName) \(account.lastName)")
                            .fontSize(24.px)
                    }
                    
                    Div{
                        Label("\(account.mobile) \(account.street) \(account.city) \(account.colony)")
                    }
                    .fontSize(16.px)
                    .color(.gray)
                }
                    .backgroundColor(r: 244, g: 244, b: 244)
                    .borderRadius(all: 24.px)
                    .padding(all: 7.px)
                    .margin(all: 7.px)
                    .onClick {
                        self.remove()
                        self.callback(account)
                    }
                
            )
        }
        
    }
}
