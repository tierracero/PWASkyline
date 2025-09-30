//
//  ServiceAccionItemView.swift
//  
//
//  Created by Victor Cantu on 4/2/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionItemView: Div {
    
    override class var name: String { "div" }
    
    /// saleItem, actionItem
    var type: SaleActionType
    @State var item: CustSaleActionItem?
    
    private var callback: ((
        _ item: CustSaleActionItem
    ) -> ())
    
    init(
        type: SaleActionType,
        item: CustSaleActionItem?,
        callback: @escaping ((
            _ item: CustSaleActionItem
        ) -> ())
    ) {
        self.type = type
        self.item = item
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var objects: [CustSaleActionObjectDecoder] = []
    
    @State var custDocumentSupport: [UUID] = []
    /// in secconds
    @State var productionTime = ""
    
    /// SaleActionDificultltyLevel
    /// easy, medium, hard, expertise
    @State var productionLevel = SaleActionDificultltyLevel.easy.rawValue
    
    /// SaleActionEmployeeLevel
    /// case worker, technician, graduate, engineerClassD, engineerClassC, engineerClassB, engineerClassA, engineerClassAA, engineerClassAAA
    @State var workforceLevel = SaleActionEmployeeLevel.worker.rawValue
    
    @State var requestCompletition = false
    
    @State var isFavorite = false
    
    @State var name = ""
    

    @DOM override var body: DOM.Content {
        Div{
            
            /// Header
            Div{
                
                Img()
                    .closeButton(.view)
                    .onClick{
                        self.remove()
                    }
                
                H2("")
                    .color(.lightBlueText)
                
                Div().class(.clear)
                
            }
            
        }
        .backgroundColor(.backGroundGraySlate)
        .custom("left", "calc(20% - 12px)")
        .borderRadius(all: 24.px)
        .position(.absolute)
        .padding(all: 12.px)
        .height(60.percent)
        .width(60.percent)
        .top(20.percent)
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        self.class(.transparantBlackBackGround)
        position(.absolute)
        height(100.percent)
        width(100.percent)
        left(0.px)
        top(0.px)
    }
}

