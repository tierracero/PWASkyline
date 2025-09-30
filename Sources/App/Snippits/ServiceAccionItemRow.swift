//
//  ServiceAccionItemRow.swift
//  
//
//  Created by Victor Cantu on 4/3/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceAccionItemRow: Div {
    
    override class var name: String { "div" }
    
    let type: SaleActionType
    let action: CustSaleActionQuick
    
    private var callback: ((
        _ action: CustSaleActionQuick
    ) -> ())
    
    init(
        type: SaleActionType,
        action: CustSaleActionQuick,
        callback: @escaping ((
            _ action: CustSaleActionQuick
        ) -> ())
    ) {
        self.type = type
        self.action = action
        self.callback = callback
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var name: String = ""
    
    @State var requestCompletition: Bool = false
    
    @State var isFavorite: Bool = false
    
    @State var productionCost: Int64 = 0
    
    @State var productionTime: Int64 = 0
    
    @State var productionLevel: SaleActionDificultltyLevel = .easy
    
    @State var workforceLevel: SaleActionEmployeeLevel = .worker
    
    @DOM override var body: DOM.Content {
        
        Div{
            
            Img()
                .src(self.$isFavorite.map{ $0 ? "/skyline/media/heart.png" : "/skyline/media/heart_gray.png"})
                .marginTop(12.px)
                .height(35.px)
            
        }
        .align(.center)
        .width(50.px)
        .float(.left)
        .onClick { _, event in
            event.preventDefault()
        }
        
        Div{
            
            Div{
                Span(self.$name)
                Span( self.$productionCost.map {  $0.formatMoney } )
                    .float(.right)
            }
                .class(.oneLineText)
                .fontSize(24.px)
                .color(.white)
            
            Div{

                Span(self.$workforceLevel.map{ $0.description })
                    .marginRight(7.px)
                
                Span("|")
                    .marginRight(7.px)
                
                Span(self.$productionLevel.map{ $0.description })
                    .marginRight(7.px)
                
                Span("|")
                    .marginRight(7.px)
                
                Span(self.$productionTime.map{ $0.toString })
                    .marginRight(7.px)
                
            }
            .class(.oneLineText)
            .fontSize(18.px)
            .color(.gray)
            
        }
        .custom("width", "calc(100% - 115px)")
        .padding(all: 3.px)
        .margin(all: 3.px)
        .float(.left)
        
        Div{
            
            Img()
                .src("/skyline/media/pencil.png")
                .marginTop(12.px)
                .height(35.px)
                .onClick { _, event in
                    
                    addToDom(ServiceAccionView(type: self.type, id: self.action.id, callback: { action in
                        self.callback(action)
                    }))
                    
                    event.stopPropagation()
                }
            
        }
        .align(.center)
        .width(50.px)
        .float(.left)
        .onClick { _, event in
            event.preventDefault()
        }
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
        
        self.class(.uibtnLarge)
            .width(97.percent)
            /*
            .onClick {
                self.callback(self.action)
                self.remove()
            }
             */
        
        name = action.name
        
        requestCompletition = action.requestCompletition
        
        isFavorite = action.isFavorite
        
        productionCost = (action.workforceLevel.value.fromCents * action.productionTime.fromCents * 100.toFloat ).toCents
        
        productionTime = action.productionTime
        
        productionLevel = action.productionLevel
        
        workforceLevel = action.workforceLevel
        
    }
}
