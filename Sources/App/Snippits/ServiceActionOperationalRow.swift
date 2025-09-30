//
//  ServiceActionOperationalRow.swift
//
//
//  Created by Victor Cantu on 11/13/23.
//

import Foundation
import TCFundamentals
import TCFireSignal
import Web

class ServiceActionOperationalRow: Div {
    
    override class var name: String { "div" }
    
    var showEditControler: Bool
    
    var object: CustSOCActionOperationalObjectQuick
    
    private var removed: ((
    ) -> ())
    
    private var edited: ((
        _ object: CustSOCActionOperationalObjectQuick
    ) -> ())
    
    init(
        showEditControler: Bool,
        object: CustSOCActionOperationalObjectQuick,
        removed: @escaping ((
        ) -> ()),
        edited: @escaping ((
            _ object: CustSOCActionOperationalObjectQuick
        ) -> ())
    ) {
        self.showEditControler = showEditControler
        self.object = object
        self.removed = removed
        self.edited = edited
        
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    @State var name: String = ""
    
    @State var cost: String = ""
    
    @State var time: String = ""
    
    @DOM override var body: DOM.Content {
        
        Div {
            
            Div{
                Div(self.$name)
                    .custom("width", "calc(100% - 200px)")
                    .class(.oneLineText)
                    .float(.left)
                
                Div{
                    Span(self.$cost.map{ "＄ \($0)" })
                        .fontSize(18.px)
                }
                .float(.right)
                
                Div{
                    Span(self.$time.map{ "⏱ \($0)" })
                        .fontSize(18.px)
                }
                .marginRight(12.px)
                .float(.right)
                
            }
            .fontSize(22.px)
            .color(.white)
            
        }
        .custom("width", "calc(100% - 55px)")
        .padding(all: 3.px)
        .margin(all: 3.px)
        .float(.left)
        
        if showEditControler {
            
            Div{
                
                Img()
                    .src("/skyline/media/pencil.png")
                    .marginTop(7.px)
                    .height(24.px)
                    .onClick { _, event in
                        
                        addToDom(ServiceOperationalObjectView(
                            id: self.object.id
                        ) { element in
                            self.object = element
                            self.calcStats()
                            self.edited(element)
                        } removed: {
                            self.removed()
                        })
                    }
                
            }
            .marginRight(7.px)
            .align(.center)
            .width(35.px)
            .float(.left)
            .onClick { _, event in
                event.stopPropagation()
            }
        }
        else {
            Div{
                Img()
                    .src("/skyline/media/cross.png")
                    .marginTop(7.px)
                    .height(24.px)
                    .onClick { _, event in
                        self.removed()
                        event.stopPropagation()
                    }
            }
            .align(.center)
            .width(35.px)
            .float(.left)
            .onClick { _, event in
                event.stopPropagation()
            }
        }
        
    }
    
    override func buildUI() {
        super.buildUI()
        
        self.class(.uibtnLarge)
            .width(97.percent)
            .onClick {
                
                if !self.showEditControler {
                    
                    addToDom(ServiceOperationalObjectView(
                        id: self.object.id
                    ) { element in
                        self.object = element
                        self.calcStats()
                        self.edited(element)
                    } removed: {
                        self.removed()
                    })
                    
                }
                
            }
        name = object.name
        
        calcStats()
        
    }
    
    override func didAddToDOM() {
        super.didAddToDOM()
    }
    
    func calcStats() {
        var cost = (object.productionCost.fromCents * object.productionUnits.fromCents).toCents
        
        cost += (object.productionTime.fromCents * object.productionLevel.value.fromCents).toCents
        
        self.cost = cost.formatMoney
        
        self.time = (object.productionTime / 100).toString
    }
    
}
